<?php
// routes_reservations.php
if ($method === 'GET' && $path === '/reservations') {
    requireAuth();
    $month = isset($_GET['month']) ? $_GET['month'] : null;
    $year = isset($_GET['year']) ? $_GET['year'] : null;
    $q = "SELECT r.*, u.name as user_name FROM reservations r JOIN users u ON u.id = r.user_id";
    $params = [];
    if ($month && $year) {
        $m = str_pad($month, 2, '0', STR_PAD_LEFT);
        $q .= " WHERE r.date LIKE ?";
        $params[] = "$year-$m-%";
    }
    $q .= " ORDER BY r.date ASC, r.start_time ASC";
    echo json_encode(queryAll($q, $params));
    exit;
}

if ($method === 'POST' && $path === '/reservations') {
    requireAuth();
    $start_date = getBody('start_date');
    $end_date = getBody('end_date');
    $start_time = getBody('start_time');
    $end_time = getBody('end_time');
    $reason = getBody('reason', 'Reserva');
    
    if (!$start_date || !$end_date || !$start_time || !$end_time) {
        http_response_code(400); echo json_encode(['error' => 'Campos requeridos']); exit;
    }
    
    $current = strtotime($start_date);
    $last = strtotime($end_date);
    
    if ($current > $last) {
        http_response_code(400); echo json_encode(['error' => 'Rango inválido']); exit;
    }
    
    while ($current <= $last) {
        $dStr = date('Y-m-d', $current);
        
        // Prevent double inserts from double-clicks
        $exists = queryOne("SELECT id FROM reservations WHERE user_id = ? AND date = ? AND start_time = ? AND end_time = ?", 
            [$user['id'], $dStr, $start_time, $end_time]);
            
        if (!$exists) {
            execute("INSERT INTO reservations (user_id, date, start_time, end_time, reason) VALUES (?, ?, ?, ?, ?)",
                [$user['id'], $dStr, $start_time, $end_time, $reason]);
        }
        $current = strtotime('+1 day', $current);
    }
    
    logAction($user, "Reservó fechas: $start_date a $end_date", 'reservation', null, $reason);
    http_response_code(201);
    echo json_encode(['success' => true]);
    exit;
}

if ($method === 'PUT' && preg_match('|^/reservations/(?P<id>\d+)$|', $path, $m)) {
    requireAuth();
    $id = (int)$m['id'];
    
    $start_date = getBody('start_date');
    $start_time = getBody('start_time');
    $end_time = getBody('end_time');
    $reason = getBody('reason');
    
    $resv = queryOne('SELECT * FROM reservations WHERE id = ?', [$id]);
    if (!$resv) { http_response_code(404); echo json_encode(['error' => 'No encontrada']); exit; }
    if ($user['role'] !== 'admin' && $user['role'] !== 'post_productor' && $resv['user_id'] !== $user['id']) {
        http_response_code(403); echo json_encode(['error' => 'Sin permiso']); exit;
    }
    
    if ($start_date !== null) execute('UPDATE reservations SET date = ? WHERE id = ?', [$start_date, $id]);
    if ($start_time !== null) execute('UPDATE reservations SET start_time = ? WHERE id = ?', [$start_time, $id]);
    if ($end_time !== null) execute('UPDATE reservations SET end_time = ? WHERE id = ?', [$end_time, $id]);
    if ($reason !== null) execute('UPDATE reservations SET reason = ? WHERE id = ?', [$reason, $id]);
    
    logAction($user, "Editó reserva del {$resv['date']}", 'reservation', $id, $reason);
    echo json_encode(['success' => true]);
    exit;
}

if ($method === 'DELETE' && preg_match('|^/reservations/(?P<id>\d+)$|', $path, $m)) {
    requireAuth();
    $id = (int)$m['id'];
    $resv = queryOne('SELECT * FROM reservations WHERE id = ?', [$id]);
    if (!$resv) { http_response_code(404); echo json_encode(['error' => 'No encontrada']); exit; }
    if ($user['role'] !== 'admin' && $user['role'] !== 'post_productor' && $resv['user_id'] !== $user['id']) {
        http_response_code(403); echo json_encode(['error' => 'Sin permiso']); exit;
    }
    logAction($user, "Eliminó reserva del {$resv['date']}", 'reservation', $id, $resv['reason']);
    execute('DELETE FROM reservations WHERE id = ?', [$id]);
    echo json_encode(['success' => true]);
    exit;
}
