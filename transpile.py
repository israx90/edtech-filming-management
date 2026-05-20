import re

def transpile():
    with open('routes/api.js', 'r') as f:
        js = f.read()
    
    php = "<?php\nrequire_once 'config.php';\n\n"
    php += "header('Content-Type: application/json');\n"
    php += "session_start();\n\n"
    php += "$method = $_SERVER['REQUEST_METHOD'];\n"
    php += "$path = isset($_GET['path']) ? $_GET['path'] : '';\n"
    php += "$body = json_decode(file_get_contents('php://input'), true) ?: [];\n\n"
    
    # Auth middleware handling
    php += """
function getAuthUser() {
    $headers = getallheaders();
    $auth = isset($headers['Authorization']) ? $headers['Authorization'] : '';
    $token = str_replace('Bearer ', '', $auth);
    if (!$token) return null;
    $session = queryOne('SELECT * FROM user_sessions WHERE token = ?', [$token]);
    if (!$session) return null;
    return queryOne('SELECT id, username, role, name FROM users WHERE id = ?', [$session['user_id']]);
}

$user = getAuthUser();
function requireAuth() {
    global $user;
    if (!$user) {
        http_response_code(401);
        echo json_encode(['error' => 'No autorizado']);
        exit;
    }
}

function requireAdmin() {
    global $user;
    requireAuth();
    if ($user['role'] !== 'admin') {
        http_response_code(403);
        echo json_encode(['error' => 'Solo administradores']);
        exit;
    }
}
"""
    
    php += "\n// Routes\n"

    # Extract all routes
    route_pattern = r"router\.(get|post|put|delete)\('([^']+)',\s*(?:isAdmin,\s*)?async \((req,\s*res)\)\s*=>\s*\{([\s\S]*?)\n\}\);"
    routes = re.finditer(route_pattern, js)
    
    for match in routes:
        method = match.group(1).upper()
        route_path = match.group(2)
        body = match.group(4)
        is_admin = 'isAdmin' in match.group(0)
        
        # Convert route parameters e.g., /reservations/:id to regex
        route_regex = re.sub(r':([a-zA-Z0-9_]+)', r'(?P<\1>[^/]+)', route_path)
        route_regex = f"|^{route_regex}$|"
        
        php += f"\nif ($method === '{method}' && preg_match('{route_regex}', $path, $matches)) {{\n"
        
        if route_path not in ['/login', '/logout']:
            php += "    requireAuth();\n"
        if is_admin:
            php += "    requireAdmin();\n"
            
        # Extract params
        param_names = re.findall(r':([a-zA-Z0-9_]+)', route_path)
        for p in param_names:
            php += f"    ${p} = $matches['{p}'];\n"
            
        # Transpile body
        body = re.sub(r'const\s+\{\s*([^}]+)\s*\}\s*=\s*req\.(body|query);', lambda m: "\n".join([f"    ${k.strip()} = isset(${( '$_GET' if m.group(2) == 'query' else '$body' )}['{k.strip()}']) ? ${( '$_GET' if m.group(2) == 'query' else '$body' )}['{k.strip()}'] : null;" for k in m.group(1).split(',')]), body)
        
        body = body.replace('req.user.id', '$user[\'id\']')
        body = body.replace('req.user.role', '$user[\'role\']')
        body = body.replace('req.user', '$user')
        body = body.replace('req.params.', '$')
        body = body.replace('res.status(401).json', 'http_response_code(401); echo json_encode')
        body = body.replace('res.status(403).json', 'http_response_code(403); echo json_encode')
        body = body.replace('res.status(404).json', 'http_response_code(404); echo json_encode')
        body = body.replace('res.status(400).json', 'http_response_code(400); echo json_encode')
        body = body.replace('res.status(201).json', 'http_response_code(201); echo json_encode')
        body = body.replace('return res.json', 'echo json_encode')
        body = body.replace('res.json', 'echo json_encode')
        
        body = re.sub(r'const\s+([a-zA-Z0-9_]+)\s*=', r'$\1 =', body)
        body = re.sub(r'let\s+([a-zA-Z0-9_]+)\s*=', r'$\1 =', body)
        body = body.replace('await queryOne', 'queryOne')
        body = body.replace('await queryAll', 'queryAll')
        body = body.replace('await execute', 'execute')
        body = body.replace('await logAction', 'logAction')
        
        # Replace arrays
        body = re.sub(r'\[([^\]]+)\]', r'[\1]', body) # keep arrays for PDO params
        
        # Add exit after echo json_encode
        body = re.sub(r'(echo json_encode[^;]+;)', r'\1 exit;', body)
        
        php += body + "\n    exit;\n}\n"

    php += "\nhttp_response_code(404);\necho json_encode(['error' => 'Route not found']);\n"

    with open('api/index_transpiled.php', 'w') as f:
        f.write(php)
    print("✅ Transpiled to api/index_transpiled.php (index.php is protected)")

if __name__ == '__main__':
    transpile()
