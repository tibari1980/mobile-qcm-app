import json
import os

path = r'd:\Antigravity-project\Mobile-application-QCM-Sans-Base\assets\data\questions.json'

with open(path, 'r', encoding='utf-8') as f:
    data = json.load(f)

initial_count = len(data)

# Deduplicate based on the question text (normalized)
unique_questions = {}
for item in data:
    q_text = item['question'].strip().lower()
    if q_text not in unique_questions:
        unique_questions[q_text] = item

final_data = list(unique_questions.values())
final_count = len(final_data)

with open(path, 'w', encoding='utf-8') as f:
    json.dump(final_data, f, ensure_ascii=False, indent=2)

print(f"Initial: {initial_count}")
print(f"Doublons supprimés: {initial_count - final_count}")
print(f"Total Final Unique: {final_count}")
