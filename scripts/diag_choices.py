import pandas as pd
import re

df = pd.read_excel('data/questions_qcm_2026-03-02.xlsx')
print(f"Total rows: {len(df)}")
print(f"Question non-null: {df['Question'].count()}")
print(f"Réponses non-null: {df['Réponses'].count()}")

for i in range(20):
    val = df['Réponses'].iloc[i]
    print(f"[{i}]: {val}")

def parse_choices(choices_str):
    if not isinstance(choices_str, str): return []
    parts = re.split(r'[A-D]:\s*', choices_str)
    choices = [p.strip() for p in parts if p.strip()]
    return choices

parsed = df['Réponses'].apply(parse_choices)
print(f"Successfully parsed (count > 1): {sum(parsed.apply(len) > 1)}")
