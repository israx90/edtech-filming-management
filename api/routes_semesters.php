<?php
if ($method === 'GET' && $path === '/semesters') {
    requireAuth();
    echo json_encode(queryAll('SELECT * FROM semesters ORDER BY created_at DESC'));
    exit;
}

if ($method === 'POST' && $path === '/semesters') {
    requireAdmin();
    $name = getBody('name');
    if (!$name) { http_response_code(400); echo json_encode(['error'=>'Nombre requerido']); exit; }
    try {
        execute('UPDATE semesters SET is_active = 0');
        execute('INSERT INTO semesters (name, is_active) VALUES (?, 1)', [$name]);
        $sem = queryOne('SELECT * FROM semesters WHERE name = ?', [$name]);
        logAction($user, "Creó semestre: $name", 'semester', $sem['id']);
        http_response_code(201); echo json_encode($sem); exit;
    } catch (Exception $e) {
        http_response_code(409); echo json_encode(['error'=>'Ya existe']); exit;
    }
}

if ($method === 'PUT' && preg_match('|^/semesters/(?P<id>\d+)/activate$|', $path, $m)) {
    requireAdmin();
    $id = (int)$m['id'];
    execute('UPDATE semesters SET is_active = 0');
    execute('UPDATE semesters SET is_active = 1 WHERE id = ?', [$id]);
    logAction($user, "Activó semestre #$id", 'semester', $id);
    echo json_encode(['success'=>true]); exit;
}

if ($method === 'DELETE' && preg_match('|^/semesters/(?P<id>\d+)$|', $path, $m)) {
    requireAdmin();
    $id = (int)$m['id'];
    $sem = queryOne('SELECT * FROM semesters WHERE id = ?', [$id]);
    if ($sem) logAction($user, "Eliminó semestre: {$sem['name']}", 'semester', $id);
    execute('DELETE FROM subjects WHERE semester_id = ?', [$id]);
    execute('DELETE FROM semesters WHERE id = ?', [$id]);
    echo json_encode(['success'=>true]); exit;
}
