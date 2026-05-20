import re

with open('api/index.php', 'r') as f:
    content = f.read()

# Replace let/const
content = re.sub(r'\b(let|const|var)\b', '', content)
# Replace {} with [] for json_encode
content = re.sub(r'echo json_encode\(\{\s*(.*?)\s*\}\);', r"echo json_encode([\1]);", content)
# Replace object properties (e.g. user.id -> $user['id'])
content = re.sub(r'([a-zA-Z_0-9]+)\.([a-zA-Z_0-9]+)', r"$\1['\2']", content)
# Replace javascript arrays methods (e.g. includes, push) -> wait, there's only a few.
content = content.replace('.includes', ' //includes')
content = content.replace('req.query.', '$_GET[\'')
# Add $ to variables that don't have it (this is hard via regex)

with open('api/index.php', 'w') as f:
    f.write(content)
