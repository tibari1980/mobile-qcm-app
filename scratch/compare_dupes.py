import json
path = 'assets/data/questions.json'
with open(path, 'r', encoding='utf-8') as f:
    data = json.load(f)

text_map = {}
for q in data:
    txt = q['question'].strip().lower()
    if txt not in text_map:
        text_map[txt] = []
    text_map[txt].append(q)

dupes = {k: v for k, v in text_map.items() if len(v) > 1}

# Look at 3 examples of duplicates
count = 0
for txt, qs in dupes.items():
    if count >= 3: break
    print(f"--- Question text: '{txt}' ---")
    for q in qs:
        print(f"  ID: {q['id']}, Answer Index: {q['answerIndex']}, Choices: {q['choices']}")
    count += 1
