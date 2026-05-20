<?php
if ($method === 'GET' && $path === '/pending-teachers') {
    requireAuth();
    // Always return all teachers — the frontend filters by status
    echo json_encode(queryAll("SELECT pt.*, u.name as added_by_name FROM pending_teachers pt LEFT JOIN users u ON u.id = pt.added_by_user_id ORDER BY CASE COALESCE(pt.status,'pending') WHEN 'guion_revisado' THEN 1 WHEN 'pending' THEN 2 WHEN 'guion_incompleto' THEN 3 WHEN 'contacted' THEN 4 WHEN 'scheduled' THEN 5 WHEN 'unavailable' THEN 6 ELSE 7 END, pt.created_at ASC")); exit;
// Note: drive_link column is included via pt.*
}

if ($method === 'POST' && $path === '/pending-teachers') {
    requireAuth();
    $name = getBody('name');
    $subject_code = getBody('subject_code');
    $subject = getBody('subject');
    $subject_type = getBody('subject_type', 'Teórica');
    $phone = getBody('phone');
    $sede = getBody('sede', 'La Paz');
    $is_external = getBody('is_external', false);
    $notes = getBody('notes');
    $drive_link = getBody('drive_link');
    $flight_ticket_path = getBody('flight_ticket_path');

    if (!$name || !$subject) { http_response_code(400); echo json_encode(['error'=>'Nombre y materia son requeridos']); exit; }
    
    if (!$subject_code) {
        $ext = extractCodeAndName($subject);
        $subject_code = $ext['code']; $subject = $ext['name'];
    }

    $id = execute(
        'INSERT INTO pending_teachers (name, subject_code, subject, subject_type, phone, sede, is_external, notes, drive_link, flight_ticket_path, added_by_user_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [$name, $subject_code, $subject, $subject_type, $phone, $sede, $is_external ? 1 : 0, $notes, $drive_link, $flight_ticket_path, $user['id']]
    );
    $teacher = queryOne("SELECT pt.*, u.name as added_by_name FROM pending_teachers pt LEFT JOIN users u ON u.id = pt.added_by_user_id WHERE pt.id = ?", [$id]);
    logAction($user, "Agregó docente pendiente: $name", 'pending_teacher', $id, "$subject_code $subject");
    http_response_code(201); echo json_encode($teacher); exit;
}

if ($method === 'PUT' && preg_match('|^/pending-teachers/(?P<id>\d+)$|', $path, $m)) {
    requireAuth();
    $id = (int)$m['id'];
    $name = getBody('name');
    $subject_code = getBody('subject_code');
    $subject = getBody('subject');
    $subject_type = getBody('subject_type');
    $phone = getBody('phone');
    $sede = getBody('sede');
    $is_external = getBody('is_external');
    $notes = getBody('notes');
    $drive_link = getBody('drive_link');
    $flight_ticket_path = getBody('flight_ticket_path');
    $resolved = getBody('resolved');
    $status = getBody('status');
    
    if ($subject !== null && $subject_code === null) {
        $ext = extractCodeAndName($subject);
        $subject_code = $ext['code']; $subject = $ext['name'];
    }
    
    if ($name !== null) execute('UPDATE pending_teachers SET name = ? WHERE id = ?', [$name, $id]);
    if ($subject_code !== null) execute('UPDATE pending_teachers SET subject_code = ? WHERE id = ?', [$subject_code, $id]);
    if ($subject !== null) execute('UPDATE pending_teachers SET subject = ? WHERE id = ?', [$subject, $id]);
    if ($subject_type !== null) execute('UPDATE pending_teachers SET subject_type = ? WHERE id = ?', [$subject_type, $id]);
    if ($phone !== null) execute('UPDATE pending_teachers SET phone = ? WHERE id = ?', [$phone, $id]);
    if ($sede !== null) execute('UPDATE pending_teachers SET sede = ? WHERE id = ?', [$sede, $id]);
    if ($is_external !== null) execute('UPDATE pending_teachers SET is_external = ? WHERE id = ?', [$is_external ? 1 : 0, $id]);
    if ($notes !== null) execute('UPDATE pending_teachers SET notes = ? WHERE id = ?', [$notes, $id]);
    if ($drive_link !== null) execute('UPDATE pending_teachers SET drive_link = ? WHERE id = ?', [$drive_link, $id]);
    if ($flight_ticket_path !== null) execute('UPDATE pending_teachers SET flight_ticket_path = ? WHERE id = ?', [$flight_ticket_path, $id]);
    if ($resolved !== null) {
        execute('UPDATE pending_teachers SET resolved = ? WHERE id = ?', [$resolved ? 1 : 0, $id]);
    }
    if ($status !== null) {
        execute('UPDATE pending_teachers SET status = ? WHERE id = ?', [$status, $id]);
        logAction($user, "Cambió estado docente a: $status", 'pending_teacher', $id);
        
        // Notify: if status changed to 'scheduled' or 'contacted', notify the user who added this teacher
        if (($status === 'scheduled' || $status === 'contacted') && $user) {
            $pt = queryOne('SELECT * FROM pending_teachers WHERE id = ?', [$id]);
            if ($pt && $pt['added_by_user_id'] && $pt['added_by_user_id'] != $user['id']) {
                $statusLabel = $status === 'scheduled' ? 'agendó fecha para' : 'contactó a';
                $msg = "{$user['name']} {$statusLabel} tu docente {$pt['name']} ({$pt['subject']})";
                execute('INSERT INTO notifications (user_id, from_user_id, from_user_name, type, message, entity_type, entity_id) VALUES (?, ?, ?, ?, ?, ?, ?)',
                    [$pt['added_by_user_id'], $user['id'], $user['name'], $status, $msg, 'pending_teacher', $id]);
            }
        }
    } else if ($resolved !== null) {
        logAction($user, $resolved ? "Marcó docente como resuelto" : "Reabrió docente", 'pending_teacher', $id);
    } else {
        logAction($user, "Editó docente pendiente", 'pending_teacher', $id, $name);
    }
    echo json_encode(queryOne('SELECT pt.*, u.name as added_by_name FROM pending_teachers pt LEFT JOIN users u ON u.id = pt.added_by_user_id WHERE pt.id = ?', [$id])); exit;
}

if ($method === 'DELETE' && preg_match('|^/pending-teachers/(?P<id>\d+)$|', $path, $m)) {
    requireAuth();
    $id = (int)$m['id'];
    $t = queryOne('SELECT * FROM pending_teachers WHERE id = ?', [$id]);
    if ($t) logAction($user, "Eliminó docente pendiente: {$t['name']}", 'pending_teacher', $t['id']);
    execute('DELETE FROM pending_teachers WHERE id = ?', [$id]);
    echo json_encode(['success'=>true]); exit;
}
