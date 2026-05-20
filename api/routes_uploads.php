<?php
// routes_uploads.php

// Serve uploaded ticket files
if ($method === 'GET' && preg_match('|^/uploads/tickets/(?P<filename>[a-zA-Z0-9_\-\.]+\.pdf)$|', $path, $m)) {
    $filename = $m['filename'];
    $filePath = __DIR__ . '/../uploads/tickets/' . $filename;
    
    if (!file_exists($filePath)) {
        http_response_code(404);
        echo json_encode(['error' => 'Archivo no encontrado']);
        exit;
    }
    
    // Serve the PDF
    header('Content-Type: application/pdf');
    header('Content-Disposition: inline; filename="' . $filename . '"');
    header('Content-Length: ' . filesize($filePath));
    readfile($filePath);
    exit;
}

if ($method === 'POST' && $path === '/uploads/ticket') {
    requireAuth();
    
    if (!isset($_FILES['file'])) {
        http_response_code(400); echo json_encode(['error' => 'No se ha enviado ningún archivo']); exit;
    }
    
    $file = $_FILES['file'];
    
    if ($file['error'] !== UPLOAD_ERR_OK) {
        http_response_code(400); echo json_encode(['error' => 'Error al subir el archivo']); exit;
    }
    
    $ext = strtolower(pathinfo($file['name'], PATHINFO_EXTENSION));
    if ($ext !== 'pdf') {
        http_response_code(400); echo json_encode(['error' => 'Solo se permiten archivos PDF']); exit;
    }
    
    if ($file['size'] > 5 * 1024 * 1024) { // 5MB limit
        http_response_code(400); echo json_encode(['error' => 'El archivo no debe exceder los 5MB']); exit;
    }
    
    $uploadDir = __DIR__ . '/../uploads/tickets/';
    if (!is_dir($uploadDir)) {
        mkdir($uploadDir, 0755, true);
    }
    
    $filename = time() . '_' . bin2hex(random_bytes(8)) . '.pdf';
    $destination = $uploadDir . $filename;
    
    if (move_uploaded_file($file['tmp_name'], $destination)) {
        // Return the path relative to the public directory
        $publicPath = '/uploads/tickets/' . $filename;
        echo json_encode(['success' => true, 'path' => $publicPath]);
    } else {
        http_response_code(500); echo json_encode(['error' => 'No se pudo guardar el archivo en el servidor']);
    }
    exit;
}
