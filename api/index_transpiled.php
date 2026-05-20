<?php
require_once 'config.php';

header('Content-Type: application/json');
session_start();

$method = $_SERVER['REQUEST_METHOD'];
$path = isset($_GET['path']) ? $_GET['path'] : '';
$body = json_decode(file_get_contents('php://input'), true) ?: [];


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

// Routes

http_response_code(404);
echo json_encode(['error' => 'Route not found']);
