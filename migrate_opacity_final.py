import os
import re

def migrate_file(filepath):
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
    except UnicodeDecodeError:
        # Fallback for weird encodings if any survived
        with open(filepath, 'r', encoding='latin-1') as f:
            content = f.read()
    
    # Simple replacement: .withOpacity( -> .withValues(alpha: 
    # Handles .withOpacity(0.5) -> .withValues(alpha: 0.5)
    # Handles .withOpacity(isDark ? 0.4 : 0.1) -> .withValues(alpha: isDark ? 0.4 : 0.1)
    
    new_content = re.sub(r'\.withOpacity\(', r'.withValues(alpha: ', content)
    
    if content != new_content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        return True
    return False

def main():
    lib_path = 'lib'
    migrated_count = 0
    for root, dirs, files in os.walk(lib_path):
        for file in files:
            if file.endswith('.dart'):
                if migrate_file(os.path.join(root, file)):
                    migrated_count += 1
                    print(f'Migrated: {os.path.join(root, file)}')
    print(f'\nTotal files migrated: {migrated_count}')

if __name__ == '__main__':
    main()
