<?php
if ($method === 'GET' && $path === '/staff') {
    requireAuth();
    echo json_encode(queryAll("SELECT id, name, role FROM users WHERE role IN ('post_productor', 'admin') ORDER BY name ASC")); exit;
}

if ($method === 'GET' && $path === '/users') {
    requireAdmin();
    echo json_encode(queryAll('SELECT id, username, role, name, created_at FROM users ORDER BY created_at ASC')); exit;
}

if ($method === 'POST' && $path === '/users') {
    requireAdmin();
    $username = getBody('username');
    $password = getBody('password');
    $role = getBody('role');
    $name = getBody('name');
    if (!$username || !$password || !$role || !$name) { http_response_code(400); echo json_encode(['error'=>'Todos los campos son requeridos']); exit; }
    if (!in_array($role, ['admin', 'post_productor', 'academica'])) { http_response_code(400); echo json_encode(['error'=>'Rol inválido']); exit; }
    try {
        $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
        $id = execute('INSERT INTO users (username, password, role, name) VALUES (?, ?, ?, ?)', [$username, $hashedPassword, $role, $name]);
        $u = queryOne('SELECT id, username, role, name, created_at FROM users WHERE id = ?', [$id]);
        logAction($user, "Creó usuario: $name ($role)", 'user', $id);
        http_response_code(201); echo json_encode($u); exit;
    } catch(Exception $e) {
        http_response_code(409); echo json_encode(['error'=>'El nombre de usuario ya existe']); exit;
    }
}

if ($method === 'PUT' && preg_match('|^/users/(?P<id>\d+)$|', $path, $m)) {
    requireAdmin();
    $id = (int)$m['id'];
    $username = getBody('username');
    $password = getBody('password');
    $role = getBody('role');
    $name = getBody('name');
    if ($username !== null) execute('UPDATE users SET username = ? WHERE id = ?', [$username, $id]);
    if ($password !== null && $password !== '') execute('UPDATE users SET password = ? WHERE id = ?', [password_hash($password, PASSWORD_DEFAULT), $id]);
    if ($role !== null) execute('UPDATE users SET role = ? WHERE id = ?', [$role, $id]);
    if ($name !== null) execute('UPDATE users SET name = ? WHERE id = ?', [$name, $id]);
    logAction($user, "Editó usuario #$id", 'user', $id);
    echo json_encode(queryOne('SELECT id, username, role, name, created_at FROM users WHERE id = ?', [$id])); exit;
}

if ($method === 'DELETE' && preg_match('|^/users/(?P<id>\d+)$|', $path, $m)) {
    requireAdmin();
    $id = (int)$m['id'];
    if ($id === $user['id']) { http_response_code(400); echo json_encode(['error'=>'No puedes eliminarte a ti mismo']); exit; }
    $u = queryOne('SELECT * FROM users WHERE id = ?', [$id]);
    if ($u) logAction($user, "Eliminó usuario: {$u['name']}", 'user', $id);
    execute('DELETE FROM users WHERE id = ?', [$id]);
    echo json_encode(['success'=>true]); exit;
}

if ($method === 'GET' && $path === '/activity-log') {
    requireAdmin();
    $limit = isset($_GET['limit']) ? (int)$_GET['limit'] : 50;
    echo json_encode(queryAll('SELECT * FROM activity_log ORDER BY created_at DESC LIMIT ?', [$limit])); exit;
}

if ($method === 'GET' && $path === '/global-subjects') {
    requireAuth();
    $q = isset($_GET['q']) ? $_GET['q'] : null;
    if ($q) {
        $q = "%$q%";
        echo json_encode(queryAll('SELECT * FROM global_subjects WHERE code LIKE ? OR name LIKE ? ORDER BY code ASC LIMIT 50', [$q, $q])); exit;
    }
    echo json_encode(queryAll('SELECT * FROM global_subjects ORDER BY code ASC')); exit;
}

if ($method === 'POST' && $path === '/global-subjects') {
    requireAdmin();
    $code = getBody('code');
    $name = getBody('name');
    $career = getBody('career');
    if (!$code || !$name) { http_response_code(400); echo json_encode(['error'=>'Código y nombre requeridos']); exit; }
    try {
        $id = execute('INSERT INTO global_subjects (code, name, career) VALUES (?, ?, ?)', [$code, $name, $career]);
        $gs = queryOne('SELECT * FROM global_subjects WHERE id = ?', [$id]);
        logAction($user, "Agregó materia global: $code - $name", 'global_subject', $id);
        http_response_code(201); echo json_encode($gs); exit;
    } catch(Exception $e) {
        http_response_code(409); echo json_encode(['error'=>'Esa materia ya existe']); exit;
    }
}

if ($method === 'POST' && $path === '/global-subjects/bulk') {
    requireAdmin();
    $subjects = getBody('subjects');
    if (!$subjects || !is_array($subjects)) { http_response_code(400); echo json_encode(['error'=>'Lista requerida']); exit; }
    $inserted = 0; $skipped = 0;
    foreach ($subjects as $s) {
        try {
            $code = isset($s['code']) ? $s['code'] : null;
            $name = isset($s['name']) ? $s['name'] : null;
            $career = isset($s['career']) ? $s['career'] : null;
            execute('INSERT IGNORE INTO global_subjects (code, name, career) VALUES (?, ?, ?)', [$code, $name, $career]);
            $inserted++;
        } catch(Exception $e) { $skipped++; }
    }
    logAction($user, "Importó $inserted materias globales", 'global_subject');
    echo json_encode(['inserted' => $inserted, 'skipped' => $skipped]); exit;
}

if ($method === 'DELETE' && preg_match('|^/global-subjects/(?P<id>\d+)$|', $path, $m)) {
    requireAdmin();
    execute('DELETE FROM global_subjects WHERE id = ?', [(int)$m['id']]);
    echo json_encode(['success'=>true]); exit;
}
