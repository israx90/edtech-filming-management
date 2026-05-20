<?php
if ($method === 'GET' && $path === '/assignments') {
    requireAuth();
    echo json_encode(queryAll("
        SELECT fa.*, s.code as subject_code, s.name as subject_name
        FROM filming_assignments fa
        JOIN subjects s ON s.id = fa.subject_id
        JOIN semesters sem ON sem.id = s.semester_id AND sem.is_active = 1
        ORDER BY fa.created_at DESC
    ")); exit;
}

if ($method === 'GET' && preg_match('|^/assignments/(?P<id>\d+)$|', $path, $m)) {
    requireAuth();
    $id = (int)$m['id'];
    $a = queryOne("
        SELECT fa.*, s.code as subject_code, s.name as subject_name
        FROM filming_assignments fa JOIN subjects s ON s.id = fa.subject_id
        WHERE fa.id = ?
    ", [$id]);
    if (!$a) { http_response_code(404); echo json_encode(['error'=>'No encontrada']); exit; }
    $a['sessions'] = queryAll("
        SELECT rs.*, u1.name as staff_1_name, u2.name as staff_2_name 
        FROM recording_sessions rs 
        LEFT JOIN users u1 ON rs.staff_1_id = u1.id 
        LEFT JOIN users u2 ON rs.staff_2_id = u2.id 
        WHERE rs.assignment_id = ? ORDER BY rs.session_date ASC
    ", [$id]);
    echo json_encode($a); exit;
}

if ($method === 'POST' && $path === '/assignments') {
    requireAuth();
    $teacher_name = getBody('teacher_name');
    $phone = getBody('phone');
    $subject_id = getBody('subject_id');
    $drive_link = getBody('drive_link');
    $script_status = getBody('script_status');
    $session = getBody('session');
    
    if (!$teacher_name || !$subject_id) { http_response_code(400); echo json_encode(['error'=>'Docente y materia requeridos']); exit; }

    $sede = getBody('sede', 'La Paz');
    $flight_ticket_path = getBody('flight_ticket_path');

    $aid = execute("INSERT INTO filming_assignments (teacher_name, phone, subject_id, drive_link, script_status, sede, flight_ticket_path) VALUES (?, ?, ?, ?, ?, ?, ?)",
        [$teacher_name, $phone, $subject_id, $drive_link, $script_status ?: 'not_uploaded', $sede, $flight_ticket_path]);

    if ($session && isset($session['session_date'], $session['start_time'], $session['end_time'])) {
        $s1 = getBody('staff_1_id');
        $s2 = getBody('staff_2_id');
        execute("INSERT INTO recording_sessions (assignment_id, session_date, start_time, end_time, hito_reached, notes, staff_1_id, staff_2_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
            [$aid, $session['session_date'], $session['start_time'], $session['end_time'], isset($session['hito_reached'])?$session['hito_reached']:null, isset($session['notes'])?$session['notes']:null, $s1, $s2]);
        if (isset($session['hito_reached']) && $session['hito_reached']) {
            execute('UPDATE filming_assignments SET last_hito_reached = ? WHERE id = ?', [$session['hito_reached'], $aid]);
        }
    }

    $result = queryOne("SELECT fa.*, s.code as subject_code, s.name as subject_name FROM filming_assignments fa JOIN subjects s ON s.id = fa.subject_id WHERE fa.id = ?", [$aid]);
    logAction($user, "Creó filmación: {$result['subject_code']} ({$teacher_name})", 'assignment', $aid, isset($session['session_date']) ? "Fecha: {$session['session_date']}" : null);

    // Notify: if this teacher was from pending_teachers, notify the user who added them
    $pendingTeacherId = getBody('pending_teacher_id');
    if ($pendingTeacherId) {
        $pt = queryOne('SELECT * FROM pending_teachers WHERE id = ?', [$pendingTeacherId]);
        if ($pt && $pt['added_by_user_id'] && $pt['added_by_user_id'] != $user['id']) {
            $sessionDate = isset($session['session_date']) ? $session['session_date'] : 'fecha por definir';
            $msg = "{$user['name']} agendó filmación de {$teacher_name} ({$result['subject_code']}) para el {$sessionDate}";
            execute('INSERT INTO notifications (user_id, from_user_id, from_user_name, type, message, entity_type, entity_id) VALUES (?, ?, ?, ?, ?, ?, ?)',
                [$pt['added_by_user_id'], $user['id'], $user['name'], 'scheduled', $msg, 'assignment', $aid]);
        }
    }

    http_response_code(201); echo json_encode($result); exit;
}

if ($method === 'PUT' && preg_match('|^/assignments/(?P<id>\d+)$|', $path, $m)) {
    requireAuth();
    $id = (int)$m['id'];
    $teacher_name = getBody('teacher_name');
    $phone = getBody('phone');
    $drive_link = getBody('drive_link');
    $script_status = getBody('script_status');
    $status = getBody('status');
    $sede = getBody('sede');
    $flight_ticket_path = getBody('flight_ticket_path');
    $assigned_staff = getBody('assigned_staff');
    
    if ($teacher_name !== null) execute('UPDATE filming_assignments SET teacher_name = ? WHERE id = ?', [$teacher_name, $id]);
    if ($phone !== null) execute('UPDATE filming_assignments SET phone = ? WHERE id = ?', [$phone, $id]);
    if ($drive_link !== null) execute('UPDATE filming_assignments SET drive_link = ? WHERE id = ?', [$drive_link, $id]);
    if ($script_status !== null) execute('UPDATE filming_assignments SET script_status = ? WHERE id = ?', [$script_status, $id]);
    if ($sede !== null) execute('UPDATE filming_assignments SET sede = ? WHERE id = ?', [$sede, $id]);
    if ($flight_ticket_path !== null) execute('UPDATE filming_assignments SET flight_ticket_path = ? WHERE id = ?', [$flight_ticket_path, $id]);
    if ($assigned_staff !== null) execute('UPDATE filming_assignments SET assigned_staff = ? WHERE id = ?', [$assigned_staff, $id]);
    if ($status !== null) {
        execute('UPDATE filming_assignments SET status = ? WHERE id = ?', [$status, $id]);
        if ($status === 'completed') {
            $a = queryOne('SELECT subject_id FROM filming_assignments WHERE id = ?', [$id]);
            if ($a) execute('UPDATE subjects SET completed = 1 WHERE id = ?', [$a['subject_id']]);
        }
    }
    $updated = queryOne("SELECT fa.*, s.code as subject_code, s.name as subject_name FROM filming_assignments fa JOIN subjects s ON s.id = fa.subject_id WHERE fa.id = ?", [$id]);
    if ($status !== null) {
        logAction($user, "Cambió estado de filmación a: $status", 'assignment', $id, "{$updated['subject_code']} ({$updated['teacher_name']})");
    } else {
        logAction($user, "Editó filmación: {$updated['subject_code']}", 'assignment', $id, $updated['teacher_name']);
    }
    echo json_encode($updated); exit;
}

if ($method === 'DELETE' && preg_match('|^/assignments/(?P<id>\d+)$|', $path, $m)) {
    requireAuth();
    $id = (int)$m['id'];
    $fa = queryOne('SELECT fa.*, s.code as subject_code FROM filming_assignments fa JOIN subjects s ON s.id = fa.subject_id WHERE fa.id = ?', [$id]);
    if ($fa) logAction($user, "Eliminó filmación: {$fa['subject_code']} ({$fa['teacher_name']})", 'assignment', $id);
    execute('DELETE FROM filming_assignments WHERE id = ?', [$id]);
    echo json_encode(['success'=>true]); exit;
}
