import re

def refactor_api():
    with open('routes/api.js', 'r') as f:
        content = f.read()

    # Make route handlers async
    content = re.sub(r'(\(req, res, next\) => \{)', r'async \1', content)
    content = re.sub(r'(\(req, res\) => \{)', r'async \1', content)
    content = re.sub(r'isAdmin,\s*\(req, res\) =>', r'isAdmin, async (req, res) =>', content)

    # Make logAction async
    content = re.sub(r'function logAction', r'async function logAction', content)

    # Await db calls
    content = re.sub(r'(?<!await\s)(queryAll\()', r'await \1', content)
    content = re.sub(r'(?<!await\s)(queryOne\()', r'await \1', content)
    content = re.sub(r'(?<!await\s)(execute\()', r'await \1', content)

    # Await logAction
    content = re.sub(r'(?<!await\s)(logAction\()', r'await \1', content)

    with open('routes/api.js', 'w') as f:
        f.write(content)

if __name__ == '__main__':
    refactor_api()
