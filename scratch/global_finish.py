import os
import re

# Definiton of replacements
replacements = {
    # 1. REBRANDING
    'CiviQuiz': 'CiviqQuiz',
    'civiquiz.com': 'civiqquiz.com',
    
    # 2. MOJIBAKE / ENCODING RECOVERY
    'â€”': '—',
    'â€“': '–',
    'Å“': 'œ',
    'Ã©': 'é',
    'Ã¨': 'è',
    'Ãª': 'ê',
    'Ã«': 'ë',
    'Ã ': 'à',
    'Ã¢': 'â',
    'Ã®': 'î',
    'Ã¯': 'ï',
    'Ã´': 'ô',
    'Ã¹': 'ù',
    'Ã»': 'û',
    'Ã§': 'ç',
    'Â°': '°',  # Found in screenshot CÂ°ur
    'Ã‰': 'É',
    'Ã€': 'À',
}

def process_file(filepath):
    try:
        with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
        
        original = content
        for search, replace in replacements.items():
            content = content.replace(search, replace)
        
        if content != original:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(content)
            return True
    except Exception as e:
        print(f"Error processing {filepath}: {e}")
    return False

def run_global_cleanup():
    target_dirs = ['lib', 'android', 'ios', 'assets', 'test']
    files_fixed = 0
    
    for target_dir in target_dirs:
        if not os.path.exists(target_dir): continue
        for root, dirs, files in os.walk(target_dir):
            for file in files:
                if file.endswith(('.dart', '.json', '.xml', '.plist', '.yaml', '.txt')):
                    filepath = os.path.join(root, file)
                    if process_file(filepath):
                        print(f"Fixed: {filepath}")
                        files_fixed += 1
    
    print(f"\nCleanup complete. {files_fixed} files updated.")

if __name__ == "__main__":
    run_global_cleanup()
