import json
from collections import defaultdict

with open('assets/data/questions.json', 'r', encoding='utf-8') as f:
    questions = json.load(f)

# matrix[path][theme] = count
matrix = defaultdict(lambda: defaultdict(int))
all_paths = set()
all_themes = set()

for q in questions:
    theme = q.get('theme', 'unknown').lower()
    parcours = q.get('parcours', [])
    all_themes.add(theme)
    if not parcours:
        matrix['NONE'][theme] += 1
    else:
        for p in parcours:
            matrix[p][theme] += 1
            all_paths.add(p)

print("Theme counts per Path:")
sorted_paths = sorted(list(all_paths)) + (['NONE'] if 'NONE' in matrix else [])
sorted_themes = sorted(list(all_themes))

header = "Theme".ljust(20) + "".join([p.center(10) for p in sorted_paths])
print(header)
print("-" * len(header))

for t in sorted_themes:
    line = t.ljust(20)
    for p in sorted_paths:
        line += str(matrix[p][t]).center(10)
    print(line)
