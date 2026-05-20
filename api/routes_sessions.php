<?php
if ($method === 'GET' && $path === '/sessions') {
    requireAuth();
    $month = isset($_GET['month']) ? $_GET['month'] : null;
    $year = isset($_GET['year']) ? $_GET['year'] : null;
    $q = "SELECT rs.*, fa.teacher_name, fa.phone, fa.subject_id, fa.drive_link, fa.script_status, fa.status as assignment_status, fa.id as assignment_id,
             s.code as subject_code, s.name as subject_name,
             u1.name as staff_1_name, u2.name as staff_2_name
             FROM recording_sessions rs
             JOIN filming_assignments fa ON fa.id = rs.assignment_id
             JOIN subjects s ON s.id = fa.subject_id
             JOIN semesters sem ON sem.id = s.semester_id AND sem.is_active = 1
             LEFT JOIN users u1 ON rs.staff_1_id = u1.id
             LEFT JOIN users u2 ON rs.staff_2_id = u2.id";
    $params = [];
    if ($month && $year) {
        $m = str_pad($month, 2, '0', STR_PAD_LEFT);
        $q .= " WHERE rs.session_date LIKE ?";
        $params[] = "$year-$m-%";
    }
    $q .= " ORDER BY rs.session_date ASC, rs.start_time ASC";
    echo json_encode(queryAll($q, $params)); exit;
}

if ($method === 'POST' && $path === '/sessions') {
    requireAuth();
    $assignment_id = getBody('assignment_id');
    $session_date = getBody('session_date');
    $start_time = getBody('start_time');
    $end_time = getBody('end_time');
    $hito_reached = getBody('hito_reached');
    $notes = getBody('notes');
    $staff_1_id = getBody('staff_1_id');
    $staff_2_id = getBody('staff_2_id');

    if (!$assignment_id || !$session_date || !$start_time || !$end_time) {
        http_response_code(400); echo json_encode(['error'=>'Campos requeridos']); exit;
    }

    // F3.2: Check for time conflicts on the same date
    $conflict = queryOne("SELECT rs.id, fa.teacher_name, s.code as subject_code 
        FROM recording_sessions rs 
        JOIN filming_assignments fa ON fa.id = rs.assignment_id 
        JOIN subjects s ON s.id = fa.subject_id 
        WHERE rs.session_date = ? AND (
            (? >= rs.start_time AND ? < rs.end_time) OR 
            (? > rs.start_time AND ? <= rs.end_time) OR 
            (? <= rs.start_time AND ? >= rs.end_time)
        )", [$session_date, $start_time, $start_time, $end_time, $end_time, $start_time, $end_time]);
    
    if ($conflict) {
        http_response_code(409); 
        echo json_encode(['error' => "Conflicto de horario con {$conflict['subject_code']} ({$conflict['teacher_name']}) en ese horario"]); 
        exit;
    }

    $sid = execute("INSERT INTO recording_sessions (assignment_id, session_date, start_time, end_time, hito_reached, notes, staff_1_id, staff_2_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
        [$assignment_id, $session_date, $start_time, $end_time, $hito_reached, $notes, $staff_1_id, $staff_2_id]);

    if ($hito_reached) {
        execute('UPDATE filming_assignments SET last_hito_reached = ? WHERE id = ?', [$hito_reached, $assignment_id]);
        if ($hito_reached === 'semanas') {
            execute("UPDATE filming_assignments SET status = 'completed' WHERE id = ?", [$assignment_id]);
            $a = queryOne('SELECT subject_id FROM filming_assignments WHERE id = ?', [$assignment_id]);
            if ($a) execute('UPDATE subjects SET completed = 1 WHERE id = ?', [$a['subject_id']]);
        }
    }

    $fa = queryOne('SELECT fa.teacher_name, s.code FROM filming_assignments fa JOIN subjects s ON s.id = fa.subject_id WHERE fa.id = ?', [$assignment_id]);
    logAction($user, "Creó sesión: {$fa['code']} ({$fa['teacher_name']}) el $session_date", 'session', $sid);

    $session = queryOne('SELECT * FROM recording_sessions WHERE id = ?', [$sid]);
    http_response_code(201); echo json_encode($session); exit;
}

if ($method === 'PUT' && preg_match('|^/sessions/(?P<id>\d+)$|', $path, $m)) {
    requireAuth();
    $id = (int)$m['id'];
    $session_date = getBody('session_date');
    $start_time = getBody('start_time');
    $end_time = getBody('end_time');
    $hito_reached = getBody('hito_reached');
    $notes = getBody('notes');
    $staff_1_id = getBody('staff_1_id');
    $staff_2_id = getBody('staff_2_id');

    if ($session_date !== null) execute('UPDATE recording_sessions SET session_date = ? WHERE id = ?', [$session_date, $id]);
    if ($start_time !== null) execute('UPDATE recording_sessions SET start_time = ? WHERE id = ?', [$start_time, $id]);
    if ($end_time !== null) execute('UPDATE recording_sessions SET end_time = ? WHERE id = ?', [$end_time, $id]);
    if ($hito_reached !== null) execute('UPDATE recording_sessions SET hito_reached = ? WHERE id = ?', [$hito_reached, $id]);
    if ($notes !== null) execute('UPDATE recording_sessions SET notes = ? WHERE id = ?', [$notes, $id]);
    if (array_key_exists('staff_1_id', $body)) execute('UPDATE recording_sessions SET staff_1_id = ? WHERE id = ?', [$staff_1_id, $id]);
    if (array_key_exists('staff_2_id', $body)) execute('UPDATE recording_sessions SET staff_2_id = ? WHERE id = ?', [$staff_2_id, $id]);

    if ($hito_reached) {
        $s = queryOne('SELECT assignment_id FROM recording_sessions WHERE id = ?', [$id]);
        if ($s) execute('UPDATE filming_assignments SET last_hito_reached = ? WHERE id = ?', [$hito_reached, $s['assignment_id']]);
    }
    echo json_encode(queryOne('SELECT * FROM recording_sessions WHERE id = ?', [$id])); exit;
}

if ($method === 'DELETE' && preg_match('|^/sessions/(?P<id>\d+)$|', $path, $m)) {
    requireAuth();
    $id = (int)$m['id'];
    $s = queryOne('SELECT rs.*, fa.teacher_name, sub.code FROM recording_sessions rs JOIN filming_assignments fa ON fa.id = rs.assignment_id JOIN subjects sub ON sub.id = fa.subject_id WHERE rs.id = ?', [$id]);
    if ($s) logAction($user, "Eliminó sesión: {$s['code']} ({$s['teacher_name']}) del {$s['session_date']}", 'session', $id);
    execute('DELETE FROM recording_sessions WHERE id = ?', [$id]);
    echo json_encode(['success'=>true]); exit;
}
