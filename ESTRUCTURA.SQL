-- =============================================
-- Calendario de Filmaciones - MySQL Schema
-- (Estructura en Blanco)
-- =============================================

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
    FOREIGN KEY (semester_id) REFERENCES semesters(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS filming_assignments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    teacher_name VARCHAR(255) NOT NULL,
    phone VARCHAR(50),
    subject_id INT NOT NULL,
    drive_link TEXT,
    script_status ENUM('pending', 'in_progress', 'completed') DEFAULT 'pending',
    status ENUM('in_progress', 'completed', 'cancelled') DEFAULT 'in_progress',
    sede VARCHAR(100) DEFAULT 'La Paz',
    flight_ticket_path VARCHAR(255) NULL,
    last_hito_reached ENUM('pagina_inicio', 'hito_2', 'hito_3', 'hito_4', 'hito_5', 'semanas') NULL,
    assigned_staff TEXT NULL,
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

-- Usuarios por defecto
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
    subject_type VARCHAR(50) DEFAULT 'Teórica',
    phone VARCHAR(50),
    sede VARCHAR(100) NOT NULL DEFAULT 'La Paz',
    flight_ticket_path VARCHAR(255) NULL,
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

-- Horarios por defecto del estudio
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
    subject_type VARCHAR(50) DEFAULT 'Teórica',
    career VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(code, name)
);
