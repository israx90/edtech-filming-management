PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE semesters (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    is_active INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO semesters VALUES(1,'2026-1',1,'2026-05-06 15:05:57');
CREATE TABLE subjects (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    code TEXT NOT NULL,
    name TEXT NOT NULL,
    semester_id INTEGER NOT NULL,
    completed INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (semester_id) REFERENCES semesters(id) ON DELETE CASCADE
);
INSERT INTO subjects VALUES(1,'TH-611','Administracion del Talento Humano',1,0,'2026-05-06 15:09:00');
INSERT INTO subjects VALUES(2,'MKT-501','Marketing Digital',1,0,'2026-05-06 15:09:00');
INSERT INTO subjects VALUES(3,'FIN-320','Finanzas Corporativas',1,0,'2026-05-06 15:09:00');
INSERT INTO subjects VALUES(4,'DER-410','Derecho Comercial',1,0,'2026-05-06 15:09:00');
INSERT INTO subjects VALUES(5,'PSI-220','Psicologia OrganizacionalATH-611 Administraci',1,0,'2026-05-06 15:09:00');
CREATE TABLE filming_assignments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    teacher_name TEXT NOT NULL,
    phone TEXT,
    subject_id INTEGER NOT NULL,
    drive_link TEXT,
    script_status TEXT DEFAULT 'pending' CHECK(script_status IN ('pending', 'in_progress', 'completed')),
    status TEXT DEFAULT 'in_progress' CHECK(status IN ('in_progress', 'completed', 'cancelled')),
    last_hito_reached TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE
);
INSERT INTO filming_assignments VALUES(1,'Lic. Garcia','+591 71234567',5,NULL,'pending','in_progress','hito_5','2026-05-06 15:12:16');
INSERT INTO filming_assignments VALUES(2,'Lic. Garcia','+591 71234567',4,NULL,'pending','in_progress',NULL,'2026-05-06 15:15:09');
CREATE TABLE recording_sessions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    assignment_id INTEGER NOT NULL,
    session_date TEXT NOT NULL,
    start_time TEXT NOT NULL,
    end_time TEXT NOT NULL,
    hito_reached TEXT CHECK(hito_reached IN ('pagina_inicio', 'hito_2', 'hito_3', 'hito_4', 'hito_5', 'semanas')),
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, staff_1_id INTEGER, staff_2_id INTEGER,
    FOREIGN KEY (assignment_id) REFERENCES filming_assignments(id) ON DELETE CASCADE
);
INSERT INTO recording_sessions VALUES(1,1,'2026-05-06','08:00','10:00','hito_5',NULL,'2026-05-06 15:12:16',NULL,NULL);
INSERT INTO recording_sessions VALUES(3,2,'2026-05-08','08:00','10:00',NULL,NULL,'2026-05-07 17:17:24',NULL,NULL);
CREATE TABLE closed_weeks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    week_start TEXT NOT NULL UNIQUE,
    reason TEXT DEFAULT 'Estudio cerrado',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE settings (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL
);
INSERT INTO settings VALUES('studio_start_time','08:00');
INSERT INTO settings VALUES('studio_end_time','18:00');
INSERT INTO settings VALUES('studio_days','1,2,3,4,5');
CREATE TABLE pending_teachers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    subject TEXT NOT NULL,
    phone TEXT,
    sede TEXT NOT NULL DEFAULT 'La Paz',
    is_external INTEGER DEFAULT 0,
    notes TEXT,
    resolved INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
, subject_code TEXT, added_by_user_id INTEGER);
INSERT INTO pending_teachers VALUES(1,'Marketing Digital','+591 71234567',NULL,'La Paz',0,NULL,0,'2026-05-07 15:01:25',NULL,NULL);
INSERT INTO pending_teachers VALUES(2,'Lic. Rodriguez','Marketing Digital','+591 71234567','La Paz',0,NULL,1,'2026-05-07 15:02:06',NULL,NULL);
INSERT INTO pending_teachers VALUES(3,'Dr. Fernandez','Inteligencia Artificial','+591 76543210','Santa Cruz',1,NULL,0,'2026-05-07 15:04:20',NULL,NULL);
INSERT INTO pending_teachers VALUES(4,'Ricardo','Turismo','74573450','Tarija',1,NULL,0,'2026-05-07 18:07:33','EHT-511',5);
CREATE TABLE user_sessions (
    token TEXT PRIMARY KEY,
    user_id INTEGER NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES "users_old"(id) ON DELETE CASCADE
);
INSERT INTO user_sessions VALUES('ehnmjg0icyfmovniqd2',1,'2026-05-07 15:39:02');
INSERT INTO user_sessions VALUES('vqx2fxvg03lmovsjhvl',5,'2026-05-07 17:59:36');
INSERT INTO user_sessions VALUES('lzgrqpli33omovsjhvo',5,'2026-05-07 17:59:36');
INSERT INTO user_sessions VALUES('hs148gxa9phmovso8by',9,'2026-05-07 18:03:17');
INSERT INTO user_sessions VALUES('9qakhadc5lsmovso8c1',9,'2026-05-07 18:03:17');
INSERT INTO user_sessions VALUES('5zekpmfki2umovu0wt4',1,'2026-05-07 18:41:08');
INSERT INTO user_sessions VALUES('fmzf1jvk6jjmovu7era',32,'2026-05-07 18:46:11');
INSERT INTO user_sessions VALUES('1jiywrp4e47movu8ndl',1,'2026-05-07 18:47:09');
INSERT INTO user_sessions VALUES('770yelxkfs4movu8ndm',1,'2026-05-07 18:47:09');
INSERT INTO user_sessions VALUES('kgjer2ir9wmovu9fmo',1,'2026-05-07 18:47:46');
INSERT INTO user_sessions VALUES('3vu5qzz59efmovu9fmq',1,'2026-05-07 18:47:46');
INSERT INTO user_sessions VALUES('n4h0vvtqu4pmovuafo1',33,'2026-05-07 18:48:32');
INSERT INTO user_sessions VALUES('pt99q8b2tpmovuafo2',33,'2026-05-07 18:48:32');
CREATE TABLE reservations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    date TEXT NOT NULL,
    start_time TEXT NOT NULL,
    end_time TEXT NOT NULL,
    reason TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES "users_old"(id) ON DELETE CASCADE
);
INSERT INTO reservations VALUES(1,9,'2026-05-11','08:00','10:00','EXED','2026-05-07 18:22:38');
INSERT INTO reservations VALUES(2,9,'2026-05-12','08:00','10:00','EXED','2026-05-07 18:22:38');
INSERT INTO reservations VALUES(3,9,'2026-05-13','08:00','10:00','EXED','2026-05-07 18:22:38');
INSERT INTO reservations VALUES(4,9,'2026-05-14','08:00','10:00','EXED','2026-05-07 18:22:38');
INSERT INTO reservations VALUES(5,9,'2026-05-15','08:00','10:00','EXED','2026-05-07 18:22:38');
INSERT INTO reservations VALUES(6,9,'2026-05-11','08:00','10:00','EXED','2026-05-07 18:22:38');
INSERT INTO reservations VALUES(7,9,'2026-05-12','08:00','10:00','EXED','2026-05-07 18:22:38');
INSERT INTO reservations VALUES(8,9,'2026-05-13','08:00','10:00','EXED','2026-05-07 18:22:38');
INSERT INTO reservations VALUES(9,9,'2026-05-14','08:00','10:00','EXED','2026-05-07 18:22:38');
INSERT INTO reservations VALUES(10,9,'2026-05-15','08:00','10:00','EXED','2026-05-07 18:22:38');
CREATE TABLE activity_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    user_name TEXT NOT NULL,
    action TEXT NOT NULL,
    entity_type TEXT,
    entity_id INTEGER,
    details TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES "users_old"(id) ON DELETE SET NULL
);
INSERT INTO activity_log VALUES(1,1,'Administrador','Creó usuario: Edson Israel Llanque (academica)','user',4,NULL,'2026-05-07 17:16:11');
INSERT INTO activity_log VALUES(2,1,'Administrador','Eliminó usuario: Edson Israel Llanque','user',4,NULL,'2026-05-07 17:40:43');
INSERT INTO activity_log VALUES(3,1,'Administrador','Creó usuario: Edson Israel (academica)','user',5,NULL,'2026-05-07 17:59:23');
INSERT INTO activity_log VALUES(4,1,'Administrador','Creó usuario: Mikaela (post_productor)','user',9,NULL,'2026-05-07 18:02:56');
INSERT INTO activity_log VALUES(5,5,'Edson Israel','Agregó docente pendiente: Ricardo','pending_teacher',4,'EHT-511 Turismo','2026-05-07 18:07:33');
INSERT INTO activity_log VALUES(6,1,'Administrador','Eliminó usuario: Mikaela','user',9,NULL,'2026-05-07 18:42:31');
INSERT INTO activity_log VALUES(7,1,'Administrador','Creó usuario: Mikaela (academica)','user',31,NULL,'2026-05-07 18:42:48');
INSERT INTO activity_log VALUES(8,1,'Administrador','Eliminó usuario: Mikaela','user',31,NULL,'2026-05-07 18:43:44');
INSERT INTO activity_log VALUES(9,1,'Administrador','Creó usuario: Mikaela (academica)','user',32,NULL,'2026-05-07 18:45:10');
INSERT INTO activity_log VALUES(10,1,'Administrador','Editó usuario #32','user',32,NULL,'2026-05-07 18:45:39');
INSERT INTO activity_log VALUES(11,1,'Administrador','Eliminó usuario: Mikaela','user',32,NULL,'2026-05-07 18:47:48');
INSERT INTO activity_log VALUES(12,1,'Administrador','Creó usuario: Diego (academica)','user',33,NULL,'2026-05-07 18:48:12');
INSERT INTO activity_log VALUES(13,1,'Administrador','Editó usuario #33','user',33,NULL,'2026-05-07 18:48:41');
CREATE TABLE global_subjects (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    code TEXT NOT NULL,
    name TEXT NOT NULL,
    career TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(code, name)
);
CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        role TEXT NOT NULL DEFAULT 'academica' CHECK(role IN ('admin', 'post_productor', 'academica')),
        name TEXT NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    );
INSERT INTO users VALUES(1,'admin','admin','admin','Administrador','2026-05-07 17:13:29');
INSERT INTO users VALUES(2,'reserva','reserva','post_productor','Usuario de Reserva','2026-05-07 17:13:29');
INSERT INTO users VALUES(5,'eisrael','12345678','academica','Edson Israel','2026-05-07 17:59:23');
INSERT INTO users VALUES(33,'diego','12345678','post_productor','Diego','2026-05-07 18:48:12');
INSERT INTO sqlite_sequence VALUES('semesters',1);
INSERT INTO sqlite_sequence VALUES('subjects',5);
INSERT INTO sqlite_sequence VALUES('filming_assignments',2);
INSERT INTO sqlite_sequence VALUES('recording_sessions',3);
INSERT INTO sqlite_sequence VALUES('pending_teachers',4);
INSERT INTO sqlite_sequence VALUES('users',35);
INSERT INTO sqlite_sequence VALUES('activity_log',13);
INSERT INTO sqlite_sequence VALUES('reservations',10);
COMMIT;
