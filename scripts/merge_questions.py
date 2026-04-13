import pandas as pd
import json
import os
import random
import re

# Paths
VRAI_PATH = 'data/questions_vrai.xlsx'
QCM_PATH = 'data/questions_qcm_2026-03-02.xlsx'
OUTPUT_JSON = 'assets/data/questions.json'
LOG_PATH = 'merge_log.txt'

def log(msg):
    print(msg)
    with open(LOG_PATH, 'a', encoding='utf-8') as f:
        f.write(msg + '\n')

if os.path.exists(LOG_PATH): os.remove(LOG_PATH)

try:
    log("Reading Excel files...")
    df_vrai = pd.read_excel(VRAI_PATH)
    df_qcm = pd.read_excel(QCM_PATH)

    log(f"QCM total rows: {len(df_qcm)}")

    def parse_choices(choices_str):
        if not isinstance(choices_str, str) or choices_str == "nan": 
            return ["Option A", "Option B", "Option C", "Option D"]
        parts = re.split(r'[A-D]:\s*', choices_str)
        choices = [p.strip() for p in parts if p.strip()]
        if len(choices) < 2:
            choices = [p.strip() for p in re.split(r'[,;]\s*', choices_str) if p.strip()]
        if len(choices) < 2:
            return ["Désaccord", "Accord Partiel", "D'accord", "Tout à fait d'accord"]
        return choices

    all_questions = []
    
    for idx, row in df_qcm.iterrows():
        question_text = str(row['Question'])
        if not question_text or question_text == "nan" or len(question_text) < 5: continue
        
        choices = parse_choices(str(row['Réponses']))
        
        ans_idx = 0
        try:
            val = row['Index Correct']
            if isinstance(val, (int, float)): ans_idx = int(val)
            elif isinstance(val, str) and val.isdigit(): ans_idx = int(val)
        except: pass
        
        if ans_idx >= len(choices): ans_idx = 0

        explanation = str(row['Explication']) if 'Explication' in row and str(row['Explication']) != "nan" else "Ceci est une question officielle de certification."
        theme = str(row['Thème']) if 'Thème' in row and str(row['Thème']) != "nan" else "Divers"
        
        q_obj = {
            "id": f"q_{len(all_questions)}",
            "question": question_text,
            "choices": choices,
            "answerIndex": ans_idx,
            "explanation": explanation,
            "theme": theme
        }
        all_questions.append(q_obj)

    log(f"Extracted {len(all_questions)} total potential questions.")

    theme_map = {}
    for q in all_questions:
        t = q['theme']
        if t not in theme_map: theme_map[t] = []
        theme_map[t].append(q)

    themes = list(theme_map.keys())
    target_count = 1000
    
    balanced = []
    active_themes = [t for t in themes if len(theme_map[t]) > 5]
    if not active_themes: active_themes = themes
    
    per_theme = target_count // len(active_themes)
    
    for t in active_themes:
        qs = theme_map[t]
        random.shuffle(qs)
        balanced.extend(qs[:per_theme])
    
    if len(balanced) < target_count:
        remaining = [q for q in all_questions if q not in balanced]
        random.shuffle(remaining)
        balanced.extend(remaining[:target_count - len(balanced)])
    
    random.shuffle(balanced)
    
    # Ensure assets/data exists
    os.makedirs(os.path.dirname(OUTPUT_JSON), exist_ok=True)
    
    with open(OUTPUT_JSON, 'w', encoding='utf-8') as f:
        json.dump(balanced[:1000], f, ensure_ascii=False, indent=2)
    
    log(f"Successfully saved exactly {len(balanced[:1000])} questions.")

except Exception as e:
    log(f"Merge error: {e}")
    import traceback
    log(traceback.format_exc())
