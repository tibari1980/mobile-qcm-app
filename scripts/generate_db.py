import sys
import site
from pathlib import Path
import pandas as pd
import json

# Add user site packages for pandas/openpyxl
sys.path.append(site.getusersitepackages())

def generate():
    try:
        print("Loading Excel files...")
        df1 = pd.read_excel('data/questions_vrai.xlsx')
        df2 = pd.read_excel('data/questions_qcm_2026-03-02.xlsx')
        
        print(f"Loaded {len(df1)} questions from vrai and {len(df2)} from qcm.")
        
        # Merge on ID
        merged = pd.merge(
            df1[['ID', 'Question', 'Explication', 'Thème', 'Niveau', 'Parcours']], 
            df2[['ID', 'Réponses', 'Index Correct']], 
            on='ID', 
            how='inner'
        )
        
        print(f"Merged successfully: {len(merged)} unique questions found.")
        
        # Get themes and counts
        themes = merged['Thème'].unique()
        counts = merged.groupby('Thème').size()
        min_count = counts.min()
        
        print(f"Themes found: {themes.tolist()}")
        print(f"Counts per theme: {counts.to_dict()}")
        print(f"Balancing to {min_count} questions per theme (Total: {min_count * len(themes)})")
        
        # Sample for balancing
        balanced_list = []
        for t in themes:
            theme_subset = merged[merged['Thème'] == t]
            # Random sample for "relevance" (assuming random is okay for now, or use head)
            balanced_list.append(theme_subset.sample(min_count, random_state=42))
            
        balanced_df = pd.concat(balanced_list)
        
        # Convert to JSON format
        questions = []
        for _, row in balanced_df.iterrows():
            # Handle choices parsing
            choices_raw = str(row['Réponses'])
            if '|' in choices_raw:
                choices = [c.strip() for c in choices_raw.split('|')]
            elif choices_raw.startswith('[') and choices_raw.endswith(']'):
                try:
                    choices = json.loads(choices_raw.replace("'", '"'))
                except:
                    choices = [choices_raw]
            else:
                choices = [choices_raw]
            
            questions.append({
                'id': str(row['ID']),
                'question': str(row['Question']),
                'choices': choices,
                'answer': int(row['Index Correct']),
                'explanation': str(row['Explication']),
                'theme': str(row['Thème']),
                'level': str(row['Niveau']),
                'path': str(row['Parcours'])
            })
            
        # Export
        output_dir = Path('lib/core/data')
        output_dir.mkdir(parents=True, exist_ok=True)
        output_path = output_dir / 'questions.json'
        
        with open(output_path, 'w', encoding='utf-8') as f:
            json.dump(questions, f, indent=2, ensure_ascii=False)
            
        print(f"Successfully generated {len(questions)} balanced questions at {output_path}")
        
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    generate()
