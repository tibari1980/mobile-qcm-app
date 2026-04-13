import json
from collections import defaultdict

try:
    with open('assets/data/questions.json', 'r', encoding='utf-8') as f:
        questions = json.load(f)
    print(f"Total questions loaded: {len(questions)}")
    
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
    
    # Print results in a stable format
    paths = sorted(list(all_paths))
    themes = sorted(list(all_themes))
    
    print("--- ANALYSIS START ---")
    header = "Theme," + ",".join(paths)
    print(header)
    for t in themes:
        row = [t]
        for p in paths:
            row.append(str(matrix[p][t]))
        print(",".join(row))
    print("--- ANALYSIS END ---")
except Exception as e:
    print(f"ERROR: {e}")
