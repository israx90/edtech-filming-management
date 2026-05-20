<?php
require_once 'config.php';

// ── Error handling (catch PHP fatal errors as JSON) ─────────────────────────
register_shutdown_function(function() {
    $e = error_get_last();
    if ($e && in_array($e['type'], [E_ERROR, E_PARSE, E_CORE_ERROR, E_COMPILE_ERROR])) {
        if (!headers_sent()) {
            http_response_code(500);
            header('Content-Type: application/json');
        }
        echo json_encode(['error' => 'PHP: ' . $e['message']]);
    }
});

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') { http_response_code(200); exit; }

$method = $_SERVER['REQUEST_METHOD'];
$path   = isset($_GET['path']) ? $_GET['path'] : '/';
$body   = json_decode(file_get_contents('php://input'), true) ?: [];

function getBody($key, $default = null) {
    global $body;
    return isset($body[$key]) ? $body[$key] : $default;
}

// ── Auth — compatible with InfinityFree FastCGI ────────────────────────────
// InfinityFree strips the Authorization header; .htaccess exposes it via
// $_SERVER['HTTP_AUTHORIZATION']. Fallback to getallheaders() for other hosts.

function getAuthToken() {
    // 1. Set by .htaccess: RewriteRule sets HTTP_AUTHORIZATION
    if (!empty($_SERVER['HTTP_AUTHORIZATION'])) {
        return str_replace('Bearer ', '', $_SERVER['HTTP_AUTHORIZATION']);
    }
    // 2. Standard CGI variable (some hosts)
    if (!empty($_SERVER['REDIRECT_HTTP_AUTHORIZATION'])) {
        return str_replace('Bearer ', '', $_SERVER['REDIRECT_HTTP_AUTHORIZATION']);
    }
    // 3. Fallback: getallheaders() — only if the function exists
    if (function_exists('getallheaders')) {
        $headers = getallheaders();
        if (!empty($headers['Authorization'])) {
            return str_replace('Bearer ', '', $headers['Authorization']);
        }
    }
    // 4. For multipart/form-data uploads where Authorization header is stripped
    if (!empty($_GET['token'])) {
        return $_GET['token'];
    }
    // 5. Also check POST body for token (sent as form field)
    if (!empty($_POST['token'])) {
        return $_POST['token'];
    }
    return '';
}

function getAuthUser() {
    $token = getAuthToken();
    if (!$token) return null;
    $session = queryOne('SELECT * FROM user_sessions WHERE token = ?', [$token]);
    if (!$session) return null;
    return queryOne('SELECT id, username, role, name FROM users WHERE id = ?', [$session['user_id']]);
}

$user = getAuthUser();

function requireAuth() {
    global $user;
    if (!$user) { http_response_code(401); echo json_encode(['error' => 'No autorizado']); exit; }
}

function requireAdmin() {
    global $user;
    requireAuth();
    if ($user['role'] !== 'admin') { http_response_code(403); echo json_encode(['error' => 'Solo administradores']); exit; }
}

// ── Login ──────────────────────────────────────────────────────────────────

if ($method === 'POST' && $path === '/login') {
    $username = getBody('username');
    $password = getBody('password');
    $u = queryOne('SELECT * FROM users WHERE username = ?', [$username]);
    $passwordOk = password_verify($password, $u['password'])        // bcrypt (new users)
               || $u['password'] === $password;                      // plain-text (legacy)
    if (!$u || !$passwordOk) {
        http_response_code(401); echo json_encode(['error' => 'Credenciales inválidas']); exit;
    }
    $token = bin2hex(random_bytes(32));
    execute('INSERT INTO user_sessions (token, user_id) VALUES (?, ?)', [$token, $u['id']]);
    echo json_encode([
        'token' => $token,
        'user'  => ['id' => $u['id'], 'name' => $u['name'], 'username' => $u['username'], 'role' => $u['role']]
    ]);
    exit;
}

// ── Logout ─────────────────────────────────────────────────────────────────

if ($method === 'POST' && $path === '/logout') {
    $token = getAuthToken();
    if ($token) execute('DELETE FROM user_sessions WHERE token = ?', [$token]);
    echo json_encode(['success' => true]); exit;
}

// ── /me — return current authenticated user ────────────────────────────────

if ($method === 'GET' && $path === '/me') {
    if (!$user) { http_response_code(401); echo json_encode(['error' => 'No autorizado']); exit; }
    echo json_encode($user); exit;
}

// ── Route files ────────────────────────────────────────────────────────────

require_once 'routes_semesters.php';
require_once 'routes_subjects.php';
require_once 'routes_assignments.php';
require_once 'routes_sessions.php';
require_once 'routes_teachers.php';
require_once 'routes_comments.php';
require_once 'routes_users.php';
require_once 'routes_dashboard.php';
require_once 'routes_reservations.php';
require_once 'routes_notifications.php';
require_once 'routes_uploads.php';

// ── 404 fallback ───────────────────────────────────────────────────────────
http_response_code(404);
echo json_encode(['error' => 'Route not found']);
