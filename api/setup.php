<?php
// api/setup.php
require_once 'config.php';

header('Content-Type: text/html; charset=utf-8');

echo "<h2>Instalación de Base de Datos - Calendario de Filmaciones</h2>";

try {
    $sql = "
    CREATE TABLE IF NOT EXISTS semesters (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255) NOT NULL UNIQUE,
        is_active BOOLEAN DEFAULT 0,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    );

    CREATE TABLE IF NOT EXISTS subjects (
        id INT AUTO_INCREMENT PRIMARY KEY,
        code VARCHAR(50) NOT NULL DEFAULT 'EXT',
        name VARCHAR(255) NOT NULL,
        subject_type VARCHAR(50) DEFAULT 'Teórica',
        semester_id INT NOT NULL,
        completed BOOLEAN DEFAULT 0,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        UNIQUE KEY unique_subject (code, name, semester_id),
        FOREIGN KEY (semester_id) REFERENCES semesters(id) ON DELETE CASCADE
    );

    CREATE TABLE IF NOT EXISTS filming_assignments (
        id INT AUTO_INCREMENT PRIMARY KEY,
        teacher_name VARCHAR(255) NOT NULL,
        phone VARCHAR(50),
        subject_id INT NOT NULL,
        drive_link TEXT,
        script_status VARCHAR(30) DEFAULT 'not_uploaded',
        status ENUM('in_progress', 'completed', 'cancelled') DEFAULT 'in_progress',
        last_hito_reached ENUM('pagina_inicio', 'hito_2', 'hito_3', 'hito_4', 'hito_5', 'semanas') NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE
    );

    CREATE TABLE IF NOT EXISTS users (
        id INT AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(100) NOT NULL UNIQUE,
        password VARCHAR(255) NOT NULL,
        role ENUM('admin', 'post_productor', 'academica') NOT NULL DEFAULT 'academica',
        name VARCHAR(255) NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    );

    INSERT IGNORE INTO users (username, password, role, name) VALUES ('admin', 'admin', 'admin', 'Administrador');
    INSERT IGNORE INTO users (username, password, role, name) VALUES ('Israx', 'Poteto2023*', 'admin', 'Israx');

    CREATE TABLE IF NOT EXISTS recording_sessions (
        id INT AUTO_INCREMENT PRIMARY KEY,
        assignment_id INT NOT NULL,
        session_date DATE NOT NULL,
        start_time TIME NOT NULL,
        end_time TIME NOT NULL,
        hito_reached ENUM('pagina_inicio', 'hito_2', 'hito_3', 'hito_4', 'hito_5', 'semanas') NULL,
        notes TEXT,
        staff_1_id INT,
        staff_2_id INT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (assignment_id) REFERENCES filming_assignments(id) ON DELETE CASCADE,
        FOREIGN KEY (staff_1_id) REFERENCES users(id) ON DELETE SET NULL,
        FOREIGN KEY (staff_2_id) REFERENCES users(id) ON DELETE SET NULL
    );

    CREATE TABLE IF NOT EXISTS closed_weeks (
        id INT AUTO_INCREMENT PRIMARY KEY,
        week_start DATE NOT NULL UNIQUE,
        reason VARCHAR(255) DEFAULT 'Estudio cerrado',
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    );

    CREATE TABLE IF NOT EXISTS reservations (
        id INT AUTO_INCREMENT PRIMARY KEY,
        user_id INT NOT NULL,
        date DATE NOT NULL,
        start_time TIME NOT NULL,
        end_time TIME NOT NULL,
        reason VARCHAR(255) DEFAULT 'Reserva',
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
    );

    CREATE TABLE IF NOT EXISTS pending_teachers (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        subject_code VARCHAR(50),
        subject VARCHAR(255) NOT NULL,
        subject_type VARCHAR(50) DEFAULT 'teorica',
        phone VARCHAR(50),
        sede VARCHAR(100) NOT NULL DEFAULT 'La Paz',
        is_external BOOLEAN DEFAULT 0,
        notes TEXT,
        resolved BOOLEAN DEFAULT 0,
        added_by_user_id INT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (added_by_user_id) REFERENCES users(id) ON DELETE SET NULL
    );

    CREATE TABLE IF NOT EXISTS settings (
        `key` VARCHAR(100) PRIMARY KEY,
        value VARCHAR(255) NOT NULL
    );

    INSERT IGNORE INTO settings (`key`, value) VALUES ('studio_start_time', '08:00');
    INSERT IGNORE INTO settings (`key`, value) VALUES ('studio_end_time', '18:00');
    INSERT IGNORE INTO settings (`key`, value) VALUES ('studio_days', '1,2,3,4,5');

    CREATE TABLE IF NOT EXISTS user_sessions (
        token VARCHAR(255) PRIMARY KEY,
        user_id INT NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
    );

    CREATE TABLE IF NOT EXISTS activity_log (
        id INT AUTO_INCREMENT PRIMARY KEY,
        user_id INT,
        user_name VARCHAR(255) NOT NULL,
        action VARCHAR(255) NOT NULL,
        entity_type VARCHAR(100),
        entity_id INT,
        details TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
    );

    CREATE TABLE IF NOT EXISTS global_subjects (
        id INT AUTO_INCREMENT PRIMARY KEY,
        code VARCHAR(50),
        name VARCHAR(255) NOT NULL,
        career VARCHAR(255),
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        UNIQUE(code, name)
    );

    CREATE TABLE IF NOT EXISTS notifications (
        id INT AUTO_INCREMENT PRIMARY KEY,
        user_id INT NOT NULL,
        from_user_id INT,
        from_user_name VARCHAR(255),
        type VARCHAR(50) DEFAULT 'info',
        message TEXT NOT NULL,
        entity_type VARCHAR(100),
        entity_id INT,
        is_read BOOLEAN DEFAULT 0,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (from_user_id) REFERENCES users(id) ON DELETE SET NULL
    );

    CREATE TABLE IF NOT EXISTS teacher_comments (
        id INT AUTO_INCREMENT PRIMARY KEY,
        pending_teacher_id INT NOT NULL,
        user_id INT NOT NULL,
        parent_id INT DEFAULT NULL,
        message TEXT NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (pending_teacher_id) REFERENCES pending_teachers(id) ON DELETE CASCADE,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (parent_id) REFERENCES teacher_comments(id) ON DELETE CASCADE
    );
    ";

    // En PDO es mejor ejecutar query a query o todo en un multi-query (si está activado).
    // Para asegurar, lo hacemos directo:
    $pdo->exec($sql);

    // Add columns if they don't exist
    try {
        $pdo->exec("ALTER TABLE pending_teachers ADD COLUMN subject_type VARCHAR(50) DEFAULT 'teorica'");
    } catch (PDOException $e) {
        // Ignorar si la columna ya existe
    }
    try {
        $pdo->exec("ALTER TABLE pending_teachers ADD COLUMN status VARCHAR(30) DEFAULT 'pending'");
    } catch (PDOException $e) {
        // Ignorar si la columna ya existe
    }
    try {
        $pdo->exec("ALTER TABLE subjects ADD COLUMN subject_type VARCHAR(50) DEFAULT 'Teórica'");
    } catch (PDOException $e) {
        // Ignorar si la columna ya existe
    }
    try {
        $pdo->exec("ALTER TABLE filming_assignments MODIFY COLUMN script_status VARCHAR(30) DEFAULT 'not_uploaded'");
    } catch (PDOException $e) {
        // Ignorar si ya es VARCHAR
    }
    try {
        $pdo->exec("ALTER TABLE subjects ADD UNIQUE INDEX unique_subject_idx (code, name, semester_id)");
    } catch (PDOException $e) {
        // Ignorar si el índice ya existe
    }
    // Extend script_status to include guion_revisado and guion_pendiente
    try {
        $pdo->exec("ALTER TABLE filming_assignments MODIFY COLUMN script_status VARCHAR(50) DEFAULT 'not_uploaded'");
    } catch (PDOException $e) {}
    // Ensure teacher_comments table exists on older installs
    try {
        $pdo->exec("
            CREATE TABLE IF NOT EXISTS teacher_comments (
                id INT AUTO_INCREMENT PRIMARY KEY,
                pending_teacher_id INT NOT NULL,
                user_id INT NOT NULL,
                parent_id INT DEFAULT NULL,
                message TEXT NOT NULL,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (pending_teacher_id) REFERENCES pending_teachers(id) ON DELETE CASCADE,
                FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                FOREIGN KEY (parent_id) REFERENCES teacher_comments(id) ON DELETE CASCADE
            )
        ");
    } catch (PDOException $e) {}

    // Add drive_link column to pending_teachers if not exists
    try {
        $pdo->exec("ALTER TABLE pending_teachers ADD COLUMN drive_link TEXT DEFAULT NULL");
    } catch (PDOException $e) {}

    echo "<p style='color:green;'>✅ ¡Tablas creadas y usuarios inyectados correctamente!</p>";
    echo "<p>Usuarios actuales por defecto:</p>";
    echo "<ul><li><b>admin</b> / admin</li><li><b>Israx</b> / Poteto2023*</li></ul>";
    echo "<p><a href='/'>Ir al Calendario</a></p>";

} catch (PDOException $e) {
    echo "<p style='color:red;'>❌ Error al configurar la Base de Datos: " . $e->getMessage() . "</p>";
    echo "<p>Asegúrate de haber configurado correctamente <b>api/config.php</b> con tu nombre de base de datos.</p>";
}
