<?php
// Diagnóstico de login
require_once 'config.php';

header('Content-Type: text/html; charset=utf-8');
echo "<h2>Diagnóstico del Sistema</h2>";

// 1. Test DB connection
echo "<h3>1. Conexión a BD</h3>";
try {
    $result = $pdo->query("SELECT 1");
    echo "<p style='color:green;'>✅ Conexión OK</p>";
} catch(Exception $e) {
    echo "<p style='color:red;'>❌ Error: " . $e->getMessage() . "</p>";
}

// 2. Check tables
echo "<h3>2. Tablas</h3>";
try {
    $tables = $pdo->query("SHOW TABLES")->fetchAll(PDO::FETCH_COLUMN);
    echo "<p>Tablas encontradas: " . implode(', ', $tables) . "</p>";
} catch(Exception $e) {
    echo "<p style='color:red;'>❌ " . $e->getMessage() . "</p>";
}

// 3. Check users
echo "<h3>3. Usuarios</h3>";
try {
    $users = $pdo->query("SELECT id, username, password, role, name FROM users")->fetchAll();
    if (count($users) === 0) {
        echo "<p style='color:orange;'>⚠️ No hay usuarios en la tabla</p>";
    } else {
        echo "<table border='1' cellpadding='5'><tr><th>ID</th><th>Username</th><th>Password</th><th>Role</th><th>Name</th></tr>";
        foreach($users as $u) {
            echo "<tr><td>{$u['id']}</td><td>{$u['username']}</td><td>{$u['password']}</td><td>{$u['role']}</td><td>{$u['name']}</td></tr>";
        }
        echo "</table>";
    }
} catch(Exception $e) {
    echo "<p style='color:red;'>❌ " . $e->getMessage() . "</p>";
}

// 4. Check user_sessions table
echo "<h3>4. Tabla user_sessions</h3>";
try {
    $pdo->query("SELECT 1 FROM user_sessions LIMIT 1");
    echo "<p style='color:green;'>✅ Tabla user_sessions existe</p>";
} catch(Exception $e) {
    echo "<p style='color:red;'>❌ " . $e->getMessage() . "</p>";
}

// 5. Test random_bytes
echo "<h3>5. random_bytes()</h3>";
try {
    $token = bin2hex(random_bytes(16));
    echo "<p style='color:green;'>✅ random_bytes funciona: $token</p>";
} catch(Exception $e) {
    echo "<p style='color:red;'>❌ " . $e->getMessage() . "</p>";
}

// 6. Test login manually
echo "<h3>6. Simulación de Login (Israx)</h3>";
try {
    $u = queryOne('SELECT * FROM users WHERE username = ? AND password = ?', ['Israx', 'Poteto2023*']);
    if ($u) {
        echo "<p style='color:green;'>✅ Usuario encontrado: {$u['name']} (role: {$u['role']})</p>";
        $token = bin2hex(random_bytes(16));
        execute('INSERT INTO user_sessions (token, user_id) VALUES (?, ?)', [$token, $u['id']]);
        echo "<p style='color:green;'>✅ Sesión creada con token: $token</p>";
    } else {
        echo "<p style='color:red;'>❌ Usuario NO encontrado</p>";
    }
} catch(Exception $e) {
    echo "<p style='color:red;'>❌ Error: " . $e->getMessage() . "</p>";
}

// 7. PHP version
echo "<h3>7. Info PHP</h3>";
echo "<p>PHP Version: " . phpversion() . "</p>";
echo "<p>getallheaders() disponible: " . (function_exists('getallheaders') ? 'Sí' : 'No') . "</p>";
