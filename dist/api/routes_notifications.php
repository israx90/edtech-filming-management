<?php
// routes_notifications.php

// Get notifications for the current user (unread + recent)
if ($method === 'GET' && $path === '/notifications') {
    requireAuth();
    try {
        $limit = isset($_GET['limit']) ? (int)$_GET['limit'] : 20;
        $notifications = queryAll(
            'SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC LIMIT ?',
            [$user['id'], $limit]
        );
        $row = queryOne('SELECT COUNT(*) as c FROM notifications WHERE user_id = ? AND is_read = 0', [$user['id']]);
        $unreadCount = $row ? (int)$row['c'] : 0;
        echo json_encode(['notifications' => $notifications, 'unread_count' => $unreadCount]);
    } catch (Exception $e) {
        // Table may not exist yet — return empty list silently
        echo json_encode(['notifications' => [], 'unread_count' => 0]);
    }
    exit;
}

// Mark a notification as read
if ($method === 'PUT' && preg_match('|^/notifications/(?P<id>\d+)/read$|', $path, $m)) {
    requireAuth();
    $id = (int)$m['id'];
    execute('UPDATE notifications SET is_read = 1 WHERE id = ? AND user_id = ?', [$id, $user['id']]);
    echo json_encode(['success' => true]);
    exit;
}

// Mark all notifications as read
if ($method === 'PUT' && $path === '/notifications/read-all') {
    requireAuth();
    execute('UPDATE notifications SET is_read = 1 WHERE user_id = ?', [$user['id']]);
    echo json_encode(['success' => true]);
    exit;
}
