import os
import re

def replace_in_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Replace .withOpacity( with .withValues(alpha: 
    new_content = content.replace('.withOpacity(', '.withValues(alpha: ')
    
    if new_content != content:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(new_content)
        return True
    return False

def main():
    base_dir = 'lib'
    count = 0
    for root, dirs, files in os.walk(base_dir):
        for file in files:
            if file.endswith('.dart'):
                file_path = os.path.join(root, file)
                if replace_in_file(file_path):
                    print(f'Updated: {file_path}')
                    count += 1
    print(f'Done. Updated {count} files.')

if __name__ == '__main__':
    main()
