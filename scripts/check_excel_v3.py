import pandas as pd
import os

output_path = 'd:/Antigravity-project/Mobile-application-QCM-Sans-Base/check_excel_output.txt'

def check_file(path):
    with open(output_path, 'a') as f:
        f.write(f"\n--- Checking {path} ---\n")
        abs_path = os.path.abspath(path)
        f.write(f"Absolute Path: {abs_path}\n")
        if not os.path.exists(path):
            f.write(f"File {path} does not exist.\n")
            return
        try:
            df = pd.read_excel(path)
            f.write(f"Columns: {df.columns.tolist()}\n")
            f.write(f"Shape: {df.shape}\n")
            f.write(f"Sample Data:\n{df.head(2).to_string()}\n")
        except Exception as e:
            f.write(f"Error checking {path}: {e}\n")

if os.path.exists(output_path):
    os.remove(output_path)

check_file('data/questions_vrai.xlsx')
check_file('data/questions_qcm_2026-03-02.xlsx')
