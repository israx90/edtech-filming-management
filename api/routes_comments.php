<?php
// routes_comments.php — Hilo de comentarios sobre docentes pendientes

// GET /pending-teachers/:id/comments — Listar comentarios del hilo
if ($method === 'GET' && preg_match('|^/pending-teachers/(?P<id>\d+)/comments$|', $path, $m)) {
    requireAuth();
    $teacher_id = (int)$m['id'];
    $comments = queryAll(
        "SELECT tc.*, u.name as author_name, u.role as author_role 
         FROM teacher_comments tc 
         JOIN users u ON u.id = tc.user_id 
         WHERE tc.pending_teacher_id = ? 
         ORDER BY tc.created_at ASC",
        [$teacher_id]
    );
    echo json_encode($comments);
    exit;
}

// POST /pending-teachers/:id/comments — Post-Productor abre o responde hilo
if ($method === 'POST' && preg_match('|^/pending-teachers/(?P<id>\d+)/comments$|', $path, $m)) {
    requireAuth();
    $teacher_id = (int)$m['id'];
    $message    = getBody('message');
    $parent_id  = getBody('parent_id'); // null = nuevo hilo raíz

    if (!$message) {
        http_response_code(400);
        echo json_encode(['error' => 'El mensaje es requerido']);
        exit;
    }

    // Insertar comentario
    $cid = execute(
        'INSERT INTO teacher_comments (pending_teacher_id, user_id, parent_id, message) VALUES (?, ?, ?, ?)',
        [$teacher_id, $user['id'], $parent_id ?: null, $message]
    );

    $teacher = queryOne('SELECT pt.*, u.name as added_by_name FROM pending_teachers pt LEFT JOIN users u ON u.id = pt.added_by_user_id WHERE pt.id = ?', [$teacher_id]);

    // ---- NOTIFICACIONES ----
    $notifyTargets = []; // [user_id => message]

    if (!$parent_id) {
        // Es un comentario raíz del Post-Productor → notificar a quién agregó al docente
        if ($teacher && $teacher['added_by_user_id'] && $teacher['added_by_user_id'] != $user['id']) {
            $notifyTargets[$teacher['added_by_user_id']] =
                "💬 {$user['name']} dejó un comentario sobre {$teacher['name']} ({$teacher['subject']}): \"{$message}\"";
        }
    } else {
        // Es una respuesta → notificar al autor del comentario padre
        $parent = queryOne('SELECT * FROM teacher_comments WHERE id = ?', [$parent_id]);
        if ($parent && $parent['user_id'] != $user['id']) {
            $notifyTargets[$parent['user_id']] =
                "↩ {$user['name']} respondió tu comentario sobre {$teacher['name']}: \"{$message}\"";
        }
        // También notificar al post-productor que abrió el hilo raíz (si es diferente)
        $root = queryOne('SELECT * FROM teacher_comments WHERE pending_teacher_id = ? AND parent_id IS NULL ORDER BY created_at ASC LIMIT 1', [$teacher_id]);
        if ($root && $root['user_id'] != $user['id'] && !isset($notifyTargets[$root['user_id']])) {
            $notifyTargets[$root['user_id']] =
                "↩ {$user['name']} respondió en el hilo de {$teacher['name']}: \"{$message}\"";
        }
    }

    foreach ($notifyTargets as $uid => $msg) {
        execute(
            'INSERT INTO notifications (user_id, from_user_id, from_user_name, type, message, entity_type, entity_id) VALUES (?, ?, ?, ?, ?, ?, ?)',
            [$uid, $user['id'], $user['name'], 'comment', $msg, 'pending_teacher', $teacher_id]
        );
    }

    logAction($user, "Comentó sobre docente: {$teacher['name']}", 'pending_teacher', $teacher_id, $message);

    $comment = queryOne(
        "SELECT tc.*, u.name as author_name, u.role as author_role FROM teacher_comments tc JOIN users u ON u.id = tc.user_id WHERE tc.id = ?",
        [$cid]
    );
    http_response_code(201);
    echo json_encode($comment);
    exit;
}

// DELETE /comments/:id — Eliminar un comentario (solo el autor o admin)
if ($method === 'DELETE' && preg_match('|^/comments/(?P<id>\d+)$|', $path, $m)) {
    requireAuth();
    $id = (int)$m['id'];
    $c = queryOne('SELECT * FROM teacher_comments WHERE id = ?', [$id]);
    if (!$c) { http_response_code(404); echo json_encode(['error' => 'No encontrado']); exit; }
    if ($c['user_id'] != $user['id'] && $user['role'] !== 'admin') {
        http_response_code(403); echo json_encode(['error' => 'Sin permiso']); exit;
    }
    execute('DELETE FROM teacher_comments WHERE id = ?', [$id]);
    echo json_encode(['success' => true]);
    exit;
}
