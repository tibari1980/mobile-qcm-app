import json
import os

path = 'assets/data/questions.json'
with open(path, 'r', encoding='utf-8') as f:
    data = json.load(f)

print(f"Total questions: {len(data)}")

seen_ids = set()
dup_ids = []
for q in data:
    if q['id'] in seen_ids:
        dup_ids.append(q['id'])
    seen_ids.add(q['id'])

seen_texts = set()
dup_texts = []
for q in data:
    clean_text = q['question'].strip().lower()
    if clean_text in seen_texts:
        dup_texts.append(q['question'])
    seen_texts.add(clean_text)

print(f"Duplicate IDs: {len(dup_ids)}")
print(f"Duplicate Texts: {len(dup_texts)}")

if dup_texts:
    print("\nSample Duplicate Texts (first 5):")
    for t in dup_texts[:5]:
        print(f"- {t}")
