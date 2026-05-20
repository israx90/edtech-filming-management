<?php
// api/config.php
$db_host = 'sql301.infinityfree.com';
$db_user = 'if0_41857535';
$db_pass = 'Jm3cN2fzLc';
$db_name = 'if0_41857535_edtech';
$db_port = '3306';

try {
    $pdo = new PDO("mysql:host=$db_host;port=$db_port;dbname=$db_name;charset=utf8mb4", $db_user, $db_pass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
} catch (PDOException $e) {
    header('Content-Type: application/json');
    http_response_code(500);
    echo json_encode(['error' => 'Database connection failed: ' . $e->getMessage()]);
    exit;
}

// Helpers
function queryAll($sql, $params = []) {
    global $pdo;
    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    return $stmt->fetchAll();
}

function queryOne($sql, $params = []) {
    global $pdo;
    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    $result = $stmt->fetch();
    return $result ?: null;
}

function execute($sql, $params = []) {
    global $pdo;
    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    return $pdo->lastInsertId();
}

function logAction($user, $action, $entity_type = null, $entity_id = null, $details = null) {
    if (!$user) return;
    execute('INSERT INTO activity_log (user_id, user_name, action, entity_type, entity_id, details) VALUES (?, ?, ?, ?, ?, ?)', 
        [$user['id'], $user['name'], $action, $entity_type, $entity_id, $details]);
}

function extractCodeAndName($str) {
    if (!$str) return ['code' => 'EXT', 'name' => ''];
    $parts = explode('-', $str);
    if (count($parts) >= 2) {
        $code = trim($parts[0] . '-' . explode(' ', trim($parts[1]))[0]);
        $name = trim(str_replace($code, '', $str));
        return ['code' => $code, 'name' => $name ?: trim($parts[1])];
    }
    return ['code' => 'EXT', 'name' => trim($str)];
}
