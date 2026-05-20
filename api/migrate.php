<?php
// api/migrate.php — Migración v2.0: teacher_comments + script_status ampliado
require_once 'config.php';

header('Content-Type: text/html; charset=utf-8');

// ── SQL embebido (auto-contenido, no depende de update.sql) ──────────────────
$statements = [
    "ALTER TABLE filming_assignments MODIFY COLUMN script_status VARCHAR(50) DEFAULT 'not_uploaded'",

    "CREATE TABLE IF NOT EXISTS teacher_comments (
        id INT AUTO_INCREMENT PRIMARY KEY,
        pending_teacher_id INT NOT NULL,
        user_id INT NOT NULL,
        parent_id INT DEFAULT NULL,
        message TEXT NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (pending_teacher_id) REFERENCES pending_teachers(id) ON DELETE CASCADE,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (parent_id) REFERENCES teacher_comments(id) ON DELETE CASCADE
    )",
    
    "ALTER TABLE filming_assignments ADD COLUMN sede VARCHAR(100) DEFAULT 'La Paz'",
    "ALTER TABLE filming_assignments ADD COLUMN flight_ticket_path VARCHAR(255) NULL",
    "ALTER TABLE pending_teachers ADD COLUMN flight_ticket_path VARCHAR(255) NULL",
    "ALTER TABLE filming_assignments ADD COLUMN assigned_staff TEXT NULL"
];
?>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Migración DB — EDTECH Studio</title>
<style>
    body  { font-family: monospace; background:#0d1117; color:#c9d1d9; padding:30px; max-width:860px; margin:0 auto; }
    h2   { color:#58a6ff; border-bottom:1px solid #21262d; padding-bottom:10px; }
    .ok  { color:#3fb950; }
    .err { color:#f85149; }
    .warn{ color:#d29922; }
    .info{ color:#8b949e; font-size:13px; }
    pre  { background:#161b22; border:1px solid #21262d; border-radius:6px; padding:14px; overflow-x:auto; font-size:12px; line-height:1.6; }
    .block{ background:#161b22; border:1px solid #21262d; border-radius:6px; padding:16px 20px; margin-bottom:10px; }
    .tag { display:inline-block; padding:2px 8px; border-radius:4px; font-size:11px; font-weight:700; margin-right:6px; }
    .tag-ok  { background:rgba(63,185,80,.2);  color:#3fb950; }
    .tag-err { background:rgba(248,81,73,.2);  color:#f85149; }
    .tag-skip{ background:rgba(139,148,158,.15); color:#8b949e; }
    a { color:#58a6ff; }
</style>
</head>
<body>
<h2>🛠 Migración de Base de Datos — EDTECH Studio</h2>

<?php

$ok = 0; $errs = 0; $skipped = 0;

echo "<p class='info'>" . count($statements) . " sentencia(s) a ejecutar</p>";

foreach ($statements as $sql) {
    $preview = mb_strlen($sql) > 160 ? mb_substr($sql, 0, 160) . '…' : $sql;
    try {
        $pdo->exec($sql);
        echo "<div class='block'>"
           . "<span class='tag tag-ok'>OK</span>"
           . "<code>" . htmlspecialchars($preview) . "</code>"
           . "</div>";
        $ok++;
    } catch (PDOException $e) {
        $msg = $e->getMessage();
        $benign = (
            stripos($msg, 'Duplicate column') !== false ||
            stripos($msg, 'already exists')   !== false ||
            stripos($msg, 'Duplicate key')    !== false
        );
        if ($benign) {
            echo "<div class='block'>"
               . "<span class='tag tag-skip'>OMITIDA</span>"
               . "<code>" . htmlspecialchars($preview) . "</code>"
               . "<br><span class='info'>↳ " . htmlspecialchars($msg) . "</span>"
               . "</div>";
            $skipped++;
        } else {
            echo "<div class='block'>"
               . "<span class='tag tag-err'>ERROR</span>"
               . "<code>" . htmlspecialchars($preview) . "</code>"
               . "<br><pre class='err'>" . htmlspecialchars($msg) . "</pre>"
               . "</div>";
            $errs++;
        }
    }
}

echo "<hr style='border-color:#21262d;margin:20px 0;'>";
echo "<div class='block'><h3 style='margin:0 0 10px;'>Resumen</h3>";
echo "<p><span class='ok'>✅ $ok ejecutadas correctamente</span></p>";
if ($skipped) echo "<p><span class='warn'>⏭ $skipped omitidas (ya existían)</span></p>";
if ($errs)    echo "<p><span class='err'>❌ $errs con errores</span></p>";
echo "</div>";

echo "<p><a href='/'>← Volver al Calendario</a></p>";
?>
</body>
</html>
