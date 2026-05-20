-- =============================================
-- Calendario de Filmaciones - Database Schema
-- Versión canónica — refleja todo lo trabajado
-- =============================================

-- Semesters
CREATE TABLE IF NOT EXISTS semesters (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    is_active INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Subjects (Materias por semestre)
-- 'code' se puede auto-extraer del campo name si el usuario lo escribe junto (ej: "AHT-511 Historia del Arte")
CREATE TABLE IF NOT EXISTS subjects (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    code TEXT NOT NULL DEFAULT 'EXT',
    name TEXT NOT NULL,
    semester_id INTEGER NOT NULL,
    completed INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (semester_id) REFERENCES semesters(id) ON DELETE CASCADE
);

-- Filming assignments: un docente asignado a una materia
CREATE TABLE IF NOT EXISTS filming_assignments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    teacher_name TEXT NOT NULL,
    phone TEXT,
    subject_id INTEGER NOT NULL,
    drive_link TEXT,
    script_status TEXT DEFAULT 'pending' CHECK(script_status IN ('pending', 'in_progress', 'completed')),
    status TEXT DEFAULT 'in_progress' CHECK(status IN ('in_progress', 'completed', 'cancelled')),
    last_hito_reached TEXT CHECK(last_hito_reached IN ('pagina_inicio','hito_2','hito_3','hito_4','hito_5','semanas')),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE
);

-- Sesiones individuales de grabación (cada día que graban)
CREATE TABLE IF NOT EXISTS recording_sessions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    assignment_id INTEGER NOT NULL,
    session_date TEXT NOT NULL,
    start_time TEXT NOT NULL,
    end_time TEXT NOT NULL,
    hito_reached TEXT CHECK(hito_reached IN ('pagina_inicio', 'hito_2', 'hito_3', 'hito_4', 'hito_5', 'semanas')),
    notes TEXT,
    staff_1_id INTEGER,
    staff_2_id INTEGER,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (assignment_id) REFERENCES filming_assignments(id) ON DELETE CASCADE,
    FOREIGN KEY (staff_1_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (staff_2_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Semanas cerradas (estudio cerrado ese rango)
CREATE TABLE IF NOT EXISTS closed_weeks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    week_start TEXT NOT NULL UNIQUE,
    reason TEXT DEFAULT 'Estudio cerrado',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Reservas de fechas (bloques de días)
-- Pueden ser multi-día; se almacena un registro por día con el mismo reason+start_time para agruparlas visualmente
CREATE TABLE IF NOT EXISTS reservations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    date TEXT NOT NULL,          -- formato YYYY-MM-DD
    start_time TEXT NOT NULL,    -- formato HH:MM
    end_time TEXT NOT NULL,
    reason TEXT DEFAULT 'Reserva',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Docentes pendientes (agenda de docentes por confirmar)
-- added_by_user_id: quien lo añadió (usado para permisos de edición del rol 'academica')
-- subject_code: se puede auto-extraer del campo subject
CREATE TABLE IF NOT EXISTS pending_teachers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    subject_code TEXT,
    subject TEXT NOT NULL,
    phone TEXT,
    sede TEXT NOT NULL DEFAULT 'La Paz',
    is_external INTEGER DEFAULT 0,
    notes TEXT,
    resolved INTEGER DEFAULT 0,
    added_by_user_id INTEGER,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (added_by_user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Configuración del estudio
CREATE TABLE IF NOT EXISTS settings (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL
);

INSERT OR IGNORE INTO settings (key, value) VALUES ('studio_start_time', '08:00');
INSERT OR IGNORE INTO settings (key, value) VALUES ('studio_end_time', '18:00');
INSERT OR IGNORE INTO settings (key, value) VALUES ('studio_days', '1,2,3,4,5');

-- Usuarios del sistema
-- Roles:
--   admin         → acceso total, gestión de usuarios y configuración global
--   post_productor → edita filmaciones, añade sesiones, reserva fechas, marca metas completadas
--   academica     → solo calendario (lectura) + agenda pendientes (puede añadir/editar los suyos)
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    role TEXT NOT NULL DEFAULT 'academica' CHECK(role IN ('admin', 'post_productor', 'academica')),
    name TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Usuario admin por defecto
INSERT OR IGNORE INTO users (username, password, role, name) VALUES ('admin', 'admin', 'admin', 'Administrador');

-- Sesiones de autenticación
CREATE TABLE IF NOT EXISTS user_sessions (
    token TEXT PRIMARY KEY,
    user_id INTEGER NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Log de actividad (auditoría)
CREATE TABLE IF NOT EXISTS activity_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    user_name TEXT NOT NULL,
    action TEXT NOT NULL,
    entity_type TEXT,
    entity_id INTEGER,
    details TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Materias globales (catálogo master gestionado por admin)
CREATE TABLE IF NOT EXISTS global_subjects (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    code TEXT,
    name TEXT NOT NULL,
    career TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(code, name)
);

-- Notificaciones per-user
CREATE TABLE IF NOT EXISTS notifications (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    from_user_id INTEGER,
    from_user_name TEXT,
    type TEXT DEFAULT 'info',
    message TEXT NOT NULL,
    entity_type TEXT,
    entity_id INTEGER,
    is_read INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (from_user_id) REFERENCES users(id) ON DELETE SET NULL
);
