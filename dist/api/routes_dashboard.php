<?php
if ($method === 'GET' && $path === '/closed-weeks') {
    requireAuth();
    echo json_encode(queryAll('SELECT * FROM closed_weeks ORDER BY week_start DESC')); exit;
}

if ($method === 'POST' && $path === '/closed-weeks') {
    requireAuth();
    $week_start = getBody('week_start');
    $reason = getBody('reason', 'Estudio cerrado');
    if (!$week_start) { http_response_code(400); echo json_encode(['error'=>'Fecha requerida']); exit; }
    try {
        execute('INSERT INTO closed_weeks (week_start, reason) VALUES (?, ?)', [$week_start, $reason]);
        http_response_code(201); echo json_encode(queryOne('SELECT * FROM closed_weeks ORDER BY id DESC LIMIT 1')); exit;
    } catch(Exception $e) {
        http_response_code(409); echo json_encode(['error'=>'Semana ya cerrada']); exit;
    }
}

if ($method === 'DELETE' && preg_match('|^/closed-weeks/(?P<id>\d+)$|', $path, $m)) {
    requireAuth();
    execute('DELETE FROM closed_weeks WHERE id = ?', [(int)$m['id']]);
    echo json_encode(['success'=>true]); exit;
}

if ($method === 'GET' && $path === '/dashboard') {
    requireAuth();
    $sem = queryOne('SELECT * FROM semesters WHERE is_active = 1');
    if (!$sem) {
        echo json_encode(['semester'=>null, 'totalSubjects'=>0, 'completedSubjects'=>0, 'pendingSubjects'=>0, 'inProgressSubjects'=>0, 'nextSession'=>null, 'recentSessions'=>[], 'inProgressList'=>[]]);
        exit;
    }
    
    $total = (int)queryOne('SELECT COUNT(*) as c FROM subjects WHERE semester_id = ?', [$sem['id']])['c'];
    $completed = (int)queryOne('SELECT COUNT(*) as c FROM subjects WHERE semester_id = ? AND completed = 1', [$sem['id']])['c'];
    $inProg = (int)queryOne("SELECT COUNT(DISTINCT fa.subject_id) as c FROM filming_assignments fa JOIN subjects s ON s.id = fa.subject_id WHERE s.semester_id = ? AND fa.status = 'in_progress'", [$sem['id']])['c'];
    $pending = max(0, $total - $completed - $inProg);

    $today = date('Y-m-d');
    $nextSession = queryOne("SELECT rs.*, fa.teacher_name, fa.phone, s.code as subject_code, s.name as subject_name
        FROM recording_sessions rs JOIN filming_assignments fa ON fa.id = rs.assignment_id JOIN subjects s ON s.id = fa.subject_id
        WHERE rs.session_date >= ? AND fa.status != 'cancelled' ORDER BY rs.session_date ASC, rs.start_time ASC LIMIT 1", [$today]);

    $recentSessions = queryAll("SELECT rs.*, fa.teacher_name, s.code as subject_code, s.name as subject_name, fa.status as assignment_status
        FROM recording_sessions rs JOIN filming_assignments fa ON fa.id = rs.assignment_id JOIN subjects s ON s.id = fa.subject_id
        JOIN semesters sem ON sem.id = s.semester_id AND sem.is_active = 1 ORDER BY rs.session_date DESC LIMIT 5");

    $inProgressList = queryAll("SELECT fa.*, s.code as subject_code, s.name as subject_name
        FROM filming_assignments fa JOIN subjects s ON s.id = fa.subject_id WHERE s.semester_id = ? AND fa.status = 'in_progress' ORDER BY fa.created_at DESC", [$sem['id']]);

    echo json_encode([
        'semester' => $sem,
        'totalSubjects' => $total,
        'completedSubjects' => $completed,
        'pendingSubjects' => $pending,
        'inProgressSubjects' => $inProg,
        'inProgressList' => $inProgressList,
        'nextSession' => $nextSession,
        'recentSessions' => $recentSessions
    ]);
    exit;
}

if ($method === 'GET' && preg_match('|^/availability/(?P<date>[^/]+)$|', $path, $m)) {
    requireAuth();
    $date = $m['date'];
    
    // Find Monday of that week
    $timestamp = strtotime($date . ' 12:00:00');
    $dow = date('w', $timestamp);
    $monOff = $dow == 0 ? -6 : 1 - $dow;
    $monStr = date('Y-m-d', strtotime("$monOff days", $timestamp));

    $closed = queryOne('SELECT * FROM closed_weeks WHERE week_start = ?', [$monStr]);
    if ($closed) {
        echo json_encode(['closed'=>true, 'reason'=>$closed['reason'], 'slots'=>[]]); exit;
    }

    $st = queryOne("SELECT value FROM settings WHERE `key` = 'studio_start_time'");
    $et = queryOne("SELECT value FROM settings WHERE `key` = 'studio_end_time'");
    $startH = $st ? (int)explode(':', $st['value'])[0] : 8;
    $endH = $et ? (int)explode(':', $et['value'])[0] : 18;

    $existing = queryAll("SELECT rs.start_time, rs.end_time, fa.teacher_name, s.code as subject_code
        FROM recording_sessions rs JOIN filming_assignments fa ON fa.id = rs.assignment_id JOIN subjects s ON s.id = fa.subject_id
        WHERE rs.session_date = ? ORDER BY rs.start_time ASC", [$date]);

    $slots = [];
    for ($h = $startH; $h < $endH; $h++) {
        $ss = str_pad($h, 2, '0', STR_PAD_LEFT) . ':00';
        $se = str_pad($h+1, 2, '0', STR_PAD_LEFT) . ':00';
        $occ = null;
        foreach ($existing as $s) {
            if (($ss >= $s['start_time'] && $ss < $s['end_time']) || ($se > $s['start_time'] && $se <= $s['end_time'])) {
                $occ = $s; break;
            }
        }
        $slots[] = ['start'=>$ss, 'end'=>$se, 'available'=>!$occ, 'session'=>$occ];
    }
    echo json_encode(['closed'=>false, 'slots'=>$slots, 'existingSessions'=>$existing]); exit;
}
