import json
import os
import re

def normalize_text(text):
    if not text: return ""
    # Remove extra spaces, convert to lowercase for comparison
    text = re.sub(r'\s+', ' ', text).strip().lower()
    return text

def score_entry(q):
    score = 0
    # Prefer entries with more choices
    choices = q.get('choices', [])
    score += len(choices) * 10
    
    # Prefer entries with longer explanation
    explanation = q.get('explanation', '')
    score += len(explanation) * 0.1
    
    # Prefer IDs that seem "final"
    qid = q.get('id', '')
    if 'final_v3' in qid:
        score += 50
    
    return score

input_path = 'assets/data/questions.json'
output_path = 'assets/data/questions.json'

with open(input_path, 'r', encoding='utf-8') as f:
    data = json.load(f)

print(f"Initial count: {len(data)}")

# 1. Deduplicate by Question Text
unique_questions = {} # normalized_text -> best_question_entry

for q in data:
    norm = normalize_text(q['question'])
    if norm not in unique_questions:
        unique_questions[norm] = q
    else:
        # Compare and keep the better one
        if score_entry(q) > score_entry(unique_questions[norm]):
            unique_questions[norm] = q

final_list = list(unique_questions.values())
print(f"Count after textual deduplication: {len(final_list)}")

# 2. Fix ID conflicts
# If different questions have the same ID, give them unique ones
id_map = {} # id -> list of questions sharing it
for q in final_list:
    qid = q['id']
    if qid not in id_map:
        id_map[qid] = []
    id_map[qid].append(q)

fixed_list = []
for qid, qs in id_map.items():
    if len(qs) == 1:
        fixed_list.append(qs[0])
    else:
        # Same ID but different question text (since they survived step 1)
        for i, q in enumerate(qs):
            if i == 0:
                fixed_list.append(q)
            else:
                new_id = f"{qid}_v{i+1}"
                q['id'] = new_id
                fixed_list.append(q)

print(f"Final unique count: {len(fixed_list)}")

# 3. Save with pretty print and UTF-8
with open(output_path, 'w', encoding='utf-8') as f:
    json.dump(fixed_list, f, ensure_ascii=False, indent=2)

print("Smart cleanup complete. Output saved to assets/data/questions.json")
