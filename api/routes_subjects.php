<?php
if ($method === 'GET' && $path === '/subjects') {
    requireAuth();
    $semId = isset($_GET['semester_id']) ? $_GET['semester_id'] : null;
    if (!$semId) {
        $active = queryOne('SELECT id FROM semesters WHERE is_active = 1');
        if (!$active) { echo json_encode([]); exit; }
        $semId = $active['id'];
    }
    $subjects = queryAll("SELECT s.*, fa.id as assignment_id, fa.status as assignment_status, fa.last_hito_reached, fa.teacher_name, fa.script_status, fa.drive_link FROM subjects s LEFT JOIN filming_assignments fa ON fa.subject_id = s.id AND fa.status != 'cancelled' WHERE s.semester_id = ? ORDER BY s.code ASC", [$semId]);
    echo json_encode($subjects); exit;
}

if ($method === 'POST' && $path === '/subjects') {
    requireAuth();
    $code = getBody('code');
    $name = getBody('name');
    $semester_id = getBody('semester_id');
    $subject_type = getBody('subject_type') ?: 'Teórica';
    if (!$name && $code) { $name = $code; $code = null; }
    if (!$code) {
        $ext = extractCodeAndName($name);
        $code = $ext['code']; $name = $ext['name'];
    }
    if (!$name || !$semester_id) { http_response_code(400); echo json_encode(['error'=>'Campos requeridos']); exit; }
    // Prevent duplicates
    $existing = queryOne('SELECT id FROM subjects WHERE UPPER(code) = UPPER(?) AND UPPER(name) = UPPER(?) AND semester_id = ?', [$code, $name, $semester_id]);
    if ($existing) { http_response_code(409); echo json_encode(['error'=>'Esta materia ya existe en el semestre']); exit; }
    execute('INSERT INTO subjects (code, name, subject_type, semester_id) VALUES (?, ?, ?, ?)', [$code, $name, $subject_type, $semester_id]);
    $sub = queryOne('SELECT * FROM subjects ORDER BY id DESC LIMIT 1');
    http_response_code(201); echo json_encode($sub); exit;
}

if ($method === 'PUT' && preg_match('|^/subjects/(?P<id>\d+)$|', $path, $m)) {
    requireAuth();
    $id = (int)$m['id'];
    $code = getBody('code');
    $name = getBody('name');
    $completed = getBody('completed');
    if ($code !== null) execute('UPDATE subjects SET code = ? WHERE id = ?', [$code, $id]);
    if ($name !== null) execute('UPDATE subjects SET name = ? WHERE id = ?', [$name, $id]);
    if ($completed !== null) execute('UPDATE subjects SET completed = ? WHERE id = ?', [$completed ? 1 : 0, $id]);
    echo json_encode(queryOne('SELECT * FROM subjects WHERE id = ?', [$id])); exit;
}

if ($method === 'DELETE' && preg_match('|^/subjects/(?P<id>\d+)$|', $path, $m)) {
    requireAuth();
    $id = (int)$m['id'];
    // Cascade: delete related filming_assignments and their sessions first
    $assignments = queryAll('SELECT id FROM filming_assignments WHERE subject_id = ?', [$id]);
    foreach ($assignments as $a) {
        execute('DELETE FROM recording_sessions WHERE assignment_id = ?', [$a['id']]);
    }
    execute('DELETE FROM filming_assignments WHERE subject_id = ?', [$id]);
    execute('DELETE FROM subjects WHERE id = ?', [$id]);
    echo json_encode(['success'=>true]); exit;
}

if ($method === 'POST' && $path === '/subjects/bulk') {
    requireAuth();
    $subjects = getBody('subjects');
    $semester_id = getBody('semester_id');
    $replace = getBody('replace'); // If true, delete all existing first
    if (!$subjects || !$semester_id) { http_response_code(400); echo json_encode(['error'=>'Datos requeridos']); exit; }

    // ATOMIC: Delete all existing subjects first if replace mode
    $deleted = 0;
    if ($replace) {
        $countResult = queryOne('SELECT COUNT(*) as c FROM subjects WHERE semester_id = ?', [$semester_id]);
        $deleted = (int)$countResult['c'];
        execute('DELETE FROM subjects WHERE semester_id = ?', [$semester_id]);
    }

    $results = [];
    foreach ($subjects as $item) {
        try {
            $code = isset($item['code']) ? trim($item['code']) : null;
            $name = isset($item['name']) ? trim($item['name']) : null;
            $subject_type = isset($item['subject_type']) ? trim($item['subject_type']) : 'Teórica';
            if (!$code) {
                $ext = extractCodeAndName($name);
                $code = $ext['code']; $name = $ext['name'];
            }
            // Skip if already exists in this semester
            $existing = queryOne('SELECT id FROM subjects WHERE UPPER(code) = UPPER(?) AND UPPER(name) = UPPER(?) AND semester_id = ?', [$code, $name, $semester_id]);
            if ($existing) {
                $item['skipped'] = true;
                $results[] = $item;
                continue;
            }
            execute('INSERT INTO subjects (code, name, subject_type, semester_id) VALUES (?, ?, ?, ?)', [$code, $name, $subject_type, $semester_id]);
            $item['success'] = true;
            $results[] = $item;
        } catch (Exception $e) {
            $item['error'] = $e->getMessage();
            $results[] = $item;
        }
    }
    http_response_code(201); echo json_encode(['results'=>$results, 'deleted'=>$deleted]); exit;
}

if ($method === 'POST' && $path === '/subjects/bulk-delete') {
    requireAuth();
    $semester_id = getBody('semester_id');
    if (!$semester_id) { http_response_code(400); echo json_encode(['error'=>'semester_id requerido']); exit; }
    $semester_id = (int)$semester_id;
    $count = queryOne('SELECT COUNT(*) as c FROM subjects WHERE semester_id = ?', [$semester_id]);
    execute('DELETE FROM subjects WHERE semester_id = ?', [$semester_id]);
    logAction($user, "Eliminó todas las materias del semestre #$semester_id ({$count['c']} materias)", 'subject');
    echo json_encode(['success'=>true, 'deleted'=>$count['c']]); exit;
}
