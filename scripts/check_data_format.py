import pandas as pd
import os

QCM_PATH = 'data/questions_qcm_2026-03-02.xlsx'

df = pd.read_excel(QCM_PATH)
print("Réponses Sample:")
for i in range(10):
    val = df['Réponses'].iloc[i]
    print(f"[{i}] Type: {type(val)} | Value: {val}")

# Also check Thème distribution in raw data
print("\nRaw Thème counts:")
print(df['Thème'].value_counts())
