const express = require('express');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const crypto = require('crypto');
const { queryAll, queryOne, execute, logAction } = require('../src/db');
const { getAuthUser, requireAuth, requireAdmin, getToken, extractCodeAndName } = require('../src/auth');

const app = express();
app.use(cors());
app.use(express.json());

// Serve static files from root (favicon, html, css, js)
const path = require('path');
app.use(express.static(path.join(__dirname, '..')));

// Explicit favicon route as fallback
app.get('/favicon.ico', (req, res) => res.redirect('/favicon.png'));
app.get('/favicon.png', (req, res) => res.sendFile(path.join(__dirname, '..', 'favicon.png')));


// Async handler wrapper
const asyncHandler = fn => (req, res, next) => {
  return Promise.resolve(fn(req, res, next)).catch(err => {
    console.error('[API Error]', err);
    res.status(500).json({ error: 'Error interno del servidor', detail: err.message });
  });
};

// --- DB MIGRATIONS (run once at startup) ---
(async () => {
  try {
    // Check if column exists first, add it if not
    const [cols] = await require('../src/db').getPool().execute("SHOW COLUMNS FROM recording_sessions LIKE 'is_displacement'");
    if (cols.length === 0) {
      await execute("ALTER TABLE recording_sessions ADD COLUMN is_displacement TINYINT(1) DEFAULT 0");
      console.log('[Migration] Added is_displacement column to recording_sessions');
    }
  } catch (e) { console.error('[Migration] is_displacement:', e.message); }

  // Create api_keys table
  try {
    await execute(`
      CREATE TABLE IF NOT EXISTS api_keys (
        id           INT AUTO_INCREMENT PRIMARY KEY,
        name         VARCHAR(100) NOT NULL,
        key_hash     VARCHAR(128) NOT NULL UNIQUE,
        key_preview  VARCHAR(12)  NOT NULL,
        created_by   INT,
        is_active    TINYINT(1) DEFAULT 1,
        last_used_at DATETIME DEFAULT NULL,
        created_at   DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    `);
    console.log('[Migration] api_keys table ready.');
  } catch (e) { console.error('[Migration] api_keys table:', e.message); }

  // Create holidays table
  try {
    await execute(`
      CREATE TABLE IF NOT EXISTS holidays (
        id INT AUTO_INCREMENT PRIMARY KEY,
        date_key VARCHAR(10) NOT NULL UNIQUE,
        name VARCHAR(200) NOT NULL,
        is_fixed TINYINT(1) DEFAULT 0
      )
    `);
  } catch (e) { console.error('[Migration] holidays table:', e.message); }

  // Seed default Bolivian holidays if the table is empty
  try {
    const count = await queryOne('SELECT COUNT(*) as c FROM holidays');
    if (parseInt(count?.c || 0) === 0) {
      const defaults = [
        // Fijos (MM-DD)
        { date_key: '01-01', name: 'Año Nuevo',                      is_fixed: 1 },
        { date_key: '01-22', name: 'Día del Estado Plur.',            is_fixed: 1 },
        { date_key: '02-10', name: 'Efeméride de Oruro',              is_fixed: 1 },
        { date_key: '04-15', name: 'Efeméride de Tarija',             is_fixed: 1 },
        { date_key: '05-01', name: 'Día del Trabajo',                 is_fixed: 1 },
        { date_key: '05-25', name: 'Efeméride Chuquisaca',            is_fixed: 1 },
        { date_key: '06-21', name: 'Año Nuevo Andino',                is_fixed: 1 },
        { date_key: '07-16', name: 'Efeméride de La Paz',             is_fixed: 1 },
        { date_key: '08-06', name: 'Independencia',                   is_fixed: 1 },
        { date_key: '09-14', name: 'Efeméride Cochabamba',            is_fixed: 1 },
        { date_key: '09-24', name: 'Efeméride Santa Cruz',            is_fixed: 1 },
        { date_key: '10-01', name: 'Efeméride de Pando',              is_fixed: 1 },
        { date_key: '11-02', name: 'Día de los Difuntos',             is_fixed: 1 },
        { date_key: '11-10', name: 'Efeméride de Potosí',             is_fixed: 1 },
        { date_key: '11-18', name: 'Efeméride de Beni',               is_fixed: 1 },
        { date_key: '12-25', name: 'Navidad',                         is_fixed: 1 },
        // Móviles 2025
        { date_key: '2025-03-03', name: 'Carnaval',          is_fixed: 0 },
        { date_key: '2025-03-04', name: 'Carnaval',          is_fixed: 0 },
        { date_key: '2025-04-17', name: 'Jueves Santo',      is_fixed: 0 },
        { date_key: '2025-04-18', name: 'Viernes Santo',     is_fixed: 0 },
        { date_key: '2025-06-19', name: 'Corpus Christi',    is_fixed: 0 },
        // Móviles 2026
        { date_key: '2026-02-16', name: 'Carnaval',                          is_fixed: 0 },
        { date_key: '2026-02-17', name: 'Carnaval',                          is_fixed: 0 },
        { date_key: '2026-04-03', name: 'Viernes Santo',                     is_fixed: 0 },
        { date_key: '2026-01-23', name: 'Día del Estado Plur. (Traslado)',   is_fixed: 0 },
        { date_key: '2026-06-04', name: 'Corpus Christi',                    is_fixed: 0 },
        { date_key: '2026-06-05', name: 'Feriado Largo (Corpus Christi)',    is_fixed: 0 },
        { date_key: '2026-06-22', name: 'Año Nuevo Andino (Traslado)',       is_fixed: 0 },
        { date_key: '2026-08-07', name: 'Feriado Largo (Independencia)',     is_fixed: 0 },
        // Móviles 2027
        { date_key: '2027-02-08', name: 'Carnaval',          is_fixed: 0 },
        { date_key: '2027-02-09', name: 'Carnaval',          is_fixed: 0 },
        { date_key: '2027-03-25', name: 'Jueves Santo',      is_fixed: 0 },
        { date_key: '2027-03-26', name: 'Viernes Santo',     is_fixed: 0 },
        { date_key: '2027-05-27', name: 'Corpus Christi',    is_fixed: 0 },
      ];
      for (const h of defaults) {
        try { await execute('INSERT IGNORE INTO holidays (date_key, name, is_fixed) VALUES (?, ?, ?)', [h.date_key, h.name, h.is_fixed]); } catch(e) {}
      }
      console.log('[Seed] Feriados bolivianos insertados por defecto.');
    }
  } catch (e) { console.error('[Seed] holidays:', e.message); }
})();

// --- HEALTH CHECK (diagnóstico) ---
app.get('/api/health', asyncHandler(async (req, res) => {
  const hasDb = !!process.env.DATABASE_URL;
  let dbOk = false;
  let dbError = null;
  if (hasDb) {
    try { await queryOne('SELECT 1 as ok'); dbOk = true; }
    catch (e) { dbError = e.message; }
  }
  res.json({ status: dbOk ? 'ok' : 'error', DATABASE_URL_set: hasDb, db_connected: dbOk, db_error: dbError });
}));

app.get('/api/logs/sql', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAdmin(user, res)) return;
  const fs = require('fs');
  const path = require('path');
  const logFile = path.join(__dirname, '..', 'sql_logs.txt');
  if (fs.existsSync(logFile)) {
    res.type('text/plain').send(fs.readFileSync(logFile, 'utf8'));
  } else {
    res.type('text/plain').send('No hay logs SQL registrados aún.');
  }
}));

app.get('/api/logs/sql/clear', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAdmin(user, res)) return;
  const fs = require('fs');
  const path = require('path');
  const logFile = path.join(__dirname, '..', 'sql_logs.txt');
  if (fs.existsSync(logFile)) {
    fs.writeFileSync(logFile, '');
    res.json({ success: true, message: 'Logs limpiados' });
  } else {
    res.json({ success: true, message: 'No había logs que limpiar' });
  }
}));

// --- AUTH & ME ---
app.post('/api/login', asyncHandler(async (req, res) => {
  const { username, password } = req.body;
  const u = await queryOne('SELECT * FROM users WHERE LOWER(username) = LOWER(?)', [username]);
  if (!u) return res.status(401).json({ error: 'Credenciales inválidas' });
  const passwordOk = bcrypt.compareSync(password, u.password) || u.password === password;
  if (!passwordOk) return res.status(401).json({ error: 'Credenciales inválidas' });
  if (u.password === password) {
    await execute('UPDATE users SET password = ? WHERE id = ?', [bcrypt.hashSync(password, 10), u.id]);
  }
  const token = crypto.randomBytes(32).toString('hex');
  await execute('INSERT INTO user_sessions (token, user_id) VALUES (?, ?)', [token, u.id]);
  res.json({ token, user: { id: u.id, name: u.name, username: u.username, role: u.role } });
}));

app.get('/api/logout', asyncHandler(async (req, res) => {
  const token = getToken(req);
  if (token) await execute('DELETE FROM user_sessions WHERE token = ?', [token]);
  res.json({ success: true });
}));

app.get('/api/me', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!user) return res.status(401).json({ error: 'No autorizado' });
  res.json(user);
}));

app.get('/api/staff', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;
  const rows = await queryAll("SELECT id, name, role FROM users WHERE role IN ('post_productor', 'admin') ORDER BY name ASC");
  res.json(rows);
}));

// --- DASHBOARD ---
app.get('/api/dashboard', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;

  const sem = await queryOne('SELECT * FROM semesters WHERE is_active = true');
  if (!sem) return res.json({ semester: null, totalSubjects: 0, completedSubjects: 0, pendingSubjects: 0, inProgressSubjects: 0, nextSession: null, recentSessions: [], inProgressList: [] });

  const totalRow = await queryOne('SELECT COUNT(*) as c FROM subjects WHERE semester_id = ?', [sem.id]);
  const completedRow = await queryOne('SELECT COUNT(*) as c FROM subjects WHERE semester_id = ? AND completed = true', [sem.id]);
  const inProgRow = await queryOne("SELECT COUNT(DISTINCT fa.subject_id) as c FROM filming_assignments fa JOIN subjects s ON s.id = fa.subject_id WHERE s.semester_id = ? AND fa.status = 'in_progress'", [sem.id]);
  
  const total = parseInt(totalRow?.c || 0);
  const completed = parseInt(completedRow?.c || 0);
  const inProg = parseInt(inProgRow?.c || 0);

  const today = new Date().toISOString().split('T')[0];
  const nextSession = await queryOne(
    "SELECT rs.*, fa.teacher_name, fa.phone, s.code as subject_code, s.name as subject_name FROM recording_sessions rs JOIN filming_assignments fa ON fa.id = rs.assignment_id JOIN subjects s ON s.id = fa.subject_id WHERE rs.session_date >= ? AND fa.status != 'cancelled' ORDER BY rs.session_date ASC, rs.start_time ASC LIMIT 1",
    [today]
  );
  const recentSessions = await queryAll(
    "SELECT rs.*, fa.teacher_name, s.code as subject_code, s.name as subject_name, fa.status as assignment_status FROM recording_sessions rs JOIN filming_assignments fa ON fa.id = rs.assignment_id JOIN subjects s ON s.id = fa.subject_id JOIN semesters sem ON sem.id = s.semester_id AND sem.is_active = true ORDER BY rs.session_date DESC LIMIT 5"
  );
  const inProgressList = await queryAll(
    "SELECT fa.*, s.code as subject_code, s.name as subject_name FROM filming_assignments fa JOIN subjects s ON s.id = fa.subject_id WHERE s.semester_id = ? AND fa.status = 'in_progress' ORDER BY fa.created_at DESC",
    [sem.id]
  );

  res.json({ semester: sem, totalSubjects: total, completedSubjects: completed, pendingSubjects: Math.max(0, total - completed - inProg), inProgressSubjects: inProg, inProgressList, nextSession, recentSessions });
}));

// --- SEMESTERS ---
app.get('/api/semesters', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;
  res.json(await queryAll('SELECT * FROM semesters ORDER BY created_at DESC'));
}));
app.post('/api/semesters', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAdmin(user, res)) return;
  const { name } = req.body;
  if (!name) return res.status(400).json({ error: 'Nombre requerido' });
  try {
    await execute('UPDATE semesters SET is_active = false');
    const id = await execute('INSERT INTO semesters (name, is_active) VALUES (?, true)', [name]);
    await logAction(user, `Creó semestre: ${name}`, 'semester', id);
    res.status(201).json(await queryOne('SELECT * FROM semesters WHERE id = ?', [id]));
  } catch (e) { res.status(409).json({ error: 'Ya existe' }); }
}));
app.put('/api/semesters/:id/activate', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;
  if (!['admin', 'academica'].includes(user.role)) return res.status(403).json({ error: 'No autorizado' });
  const id = parseInt(req.params.id);
  await execute('UPDATE semesters SET is_active = false');
  await execute('UPDATE semesters SET is_active = true WHERE id = ?', [id]);
  await logAction(user, `Activó semestre #${id}`, 'semester', id);
  res.json({ success: true });
}));
app.delete('/api/semesters/:id', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAdmin(user, res)) return;
  const id = parseInt(req.params.id);
  const sem = await queryOne('SELECT * FROM semesters WHERE id = ?', [id]);
  if (sem) await logAction(user, `Eliminó semestre: ${sem.name}`, 'semester', id);
  await execute('DELETE FROM subjects WHERE semester_id = ?', [id]);
  await execute('DELETE FROM semesters WHERE id = ?', [id]);
  res.json({ success: true });
}));

// --- SUBJECTS ---
app.get('/api/subjects', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;
  let semId = req.query.semester_id;
  if (!semId) {
    const active = await queryOne('SELECT id FROM semesters WHERE is_active = true');
    if (!active) return res.json([]);
    semId = active.id;
  }
  res.json(await queryAll(`
    SELECT s.*,
           MAX(gs.career) AS career,
           fa.id as assignment_id, fa.status as assignment_status,
           fa.last_hito_reached, fa.teacher_name, fa.script_status, fa.drive_link
    FROM subjects s
    LEFT JOIN filming_assignments fa ON fa.id = (
      SELECT fa2.id FROM filming_assignments fa2
      WHERE fa2.subject_id = s.id AND fa2.status != 'cancelled'
      ORDER BY fa2.created_at DESC
      LIMIT 1
    )
    LEFT JOIN global_subjects gs ON UPPER(TRIM(gs.code)) = UPPER(TRIM(s.code))
    WHERE s.semester_id = ?
    GROUP BY s.id, fa.id, fa.status, fa.last_hito_reached, fa.teacher_name, fa.script_status, fa.drive_link
    ORDER BY s.code ASC
  `, [semId]));

}));
app.post('/api/subjects', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;
  let { code, name, semester_id, subject_type, career } = req.body;
  if (!name && code) { name = code; code = null; }
  if (!code) { const ext = extractCodeAndName(name); code = ext.code; name = ext.name; }
  if (!name || !semester_id) return res.status(400).json({ error: 'Campos requeridos' });
  const existing = await queryOne('SELECT id FROM subjects WHERE UPPER(code) = UPPER(?) AND UPPER(name) = UPPER(?) AND semester_id = ?', [code, name, semester_id]);
  if (existing) return res.status(409).json({ error: 'Esta materia ya existe en el semestre' });
  const id = await execute('INSERT INTO subjects (code, name, subject_type, semester_id) VALUES (?, ?, ?, ?)', [code, name, subject_type || 'Teórica', semester_id]);
  if (career) {
    try {
      await execute('INSERT IGNORE INTO global_subjects (code, name, career) VALUES (?, ?, ?)', [code, name, career]);
      await execute('UPDATE global_subjects SET career = ? WHERE code = ? AND (career IS NULL OR career = "")', [career, code]);
    } catch (e) {}
  }
  res.status(201).json(await queryOne('SELECT * FROM subjects WHERE id = ?', [id]));
}));
app.post('/api/subjects/bulk', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;
  const { subjects, semester_id, replace } = req.body;
  let deleted = 0;
  if (replace) {
    const count = await queryOne('SELECT COUNT(*) as c FROM subjects WHERE semester_id = ?', [semester_id]);
    deleted = parseInt(count?.c || 0);
    await execute('DELETE FROM subjects WHERE semester_id = ?', [semester_id]);
  }
  const results = [];
  for (const item of subjects) {
    try {
      let code = item.code?.trim() || null;
      let name = item.name?.trim() || null;
      let career = item.career?.trim() || null;
      if (!code) { const ext = extractCodeAndName(name); code = ext.code; name = ext.name; }
      const existing = await queryOne('SELECT id FROM subjects WHERE UPPER(code) = UPPER(?) AND UPPER(name) = UPPER(?) AND semester_id = ?', [code, name, semester_id]);
      if (existing) { results.push({ ...item, skipped: true }); continue; }
      await execute('INSERT INTO subjects (code, name, subject_type, semester_id) VALUES (?, ?, ?, ?)', [code, name, item.subject_type || 'Teórica', semester_id]);
      if (career) {
        try {
          await execute('INSERT IGNORE INTO global_subjects (code, name, career) VALUES (?, ?, ?)', [code, name, career]);
          await execute('UPDATE global_subjects SET career = ? WHERE code = ? AND (career IS NULL OR career = "")', [career, code]);
        } catch (e) {}
      }
      results.push({ ...item, success: true });
    } catch (e) { results.push({ ...item, error: e.message }); }
  }
  res.status(201).json({ results, deleted });
}));
app.post('/api/subjects/bulk-delete', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;
  const { semester_id } = req.body;
  const count = await queryOne('SELECT COUNT(*) as c FROM subjects WHERE semester_id = ?', [semester_id]);
  await execute('DELETE FROM subjects WHERE semester_id = ?', [semester_id]);
  await logAction(user, `Eliminó todas las materias del semestre #${semester_id}`, 'subject');
  res.json({ success: true, deleted: parseInt(count?.c || 0) });
}));
app.put('/api/subjects/:id', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;
  const id = parseInt(req.params.id);
  const { code, name, completed, subject_type, career } = req.body;
  if (code !== undefined) await execute('UPDATE subjects SET code = ? WHERE id = ?', [code, id]);
  if (name !== undefined) await execute('UPDATE subjects SET name = ? WHERE id = ?', [name, id]);
  if (subject_type !== undefined) await execute('UPDATE subjects SET subject_type = ? WHERE id = ?', [subject_type, id]);
  if (career !== undefined) {
    const sub = await queryOne('SELECT code FROM subjects WHERE id = ?', [id]);
    if (sub && sub.code) await execute('UPDATE global_subjects SET career = ? WHERE code = ?', [career, sub.code]);
  }
  if (completed !== undefined) await execute('UPDATE subjects SET completed = ? WHERE id = ?', [!!completed, id]);
  res.json(await queryOne('SELECT * FROM subjects WHERE id = ?', [id]));
}));
app.delete('/api/subjects/:id', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;
  const id = parseInt(req.params.id);
  const assignments = await queryAll('SELECT id FROM filming_assignments WHERE subject_id = ?', [id]);
  for (const a of assignments) await execute('DELETE FROM recording_sessions WHERE assignment_id = ?', [a.id]);
  await execute('DELETE FROM filming_assignments WHERE subject_id = ?', [id]);
  await execute('DELETE FROM subjects WHERE id = ?', [id]);
  res.json({ success: true });
}));
app.post('/api/subjects/deduplicate', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAdmin(user, res)) return;
  const { semester_id } = req.body;
  if (!semester_id) return res.status(400).json({ error: 'semester_id es requerido' });

  // Update orphaned assignments to point to the surviving subject
  await execute(`
    UPDATE filming_assignments fa
    JOIN subjects t1 ON fa.subject_id = t1.id
    JOIN subjects t2 ON t1.code = t2.code AND t1.name = t2.name AND t1.semester_id = t2.semester_id AND t1.id > t2.id
    SET fa.subject_id = t2.id
    WHERE t1.semester_id = ?
  `, [semester_id]);

  // Delete the duplicates
  const result = await execute(`
    DELETE t1 FROM subjects t1
    INNER JOIN subjects t2 
    WHERE t1.id > t2.id AND t1.code = t2.code AND t1.name = t2.name AND t1.semester_id = t2.semester_id AND t1.semester_id = ?
  `, [semester_id]);

  await logAction(user, `Eliminó materias duplicadas del semestre #${semester_id}`, 'subject');
  res.json({ success: true, message: 'Duplicados eliminados correctamente' });
}));


// --- ASSIGNMENTS ---
app.get('/api/assignments', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;
  res.json(await queryAll("SELECT fa.*, s.code as subject_code, s.name as subject_name FROM filming_assignments fa JOIN subjects s ON s.id = fa.subject_id JOIN semesters sem ON sem.id = s.semester_id AND sem.is_active = true ORDER BY fa.created_at DESC"));
}));
app.post('/api/assignments', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;
  const { teacher_name, phone, subject_id, drive_link, script_status, session, sede, flight_ticket_path, pending_teacher_id } = req.body;
  const aid = await execute(
    'INSERT INTO filming_assignments (teacher_name, phone, subject_id, drive_link, script_status, sede, flight_ticket_path) VALUES (?, ?, ?, ?, ?, ?, ?)',
    [teacher_name, phone ?? null, subject_id, drive_link ?? null, script_status || 'not_uploaded', sede || 'La Paz', flight_ticket_path ?? null]
  );
  if (session?.session_date && session?.start_time && session?.end_time) {
    await execute('INSERT INTO recording_sessions (assignment_id, session_date, start_time, end_time, hito_reached, notes, staff_1_id, staff_2_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
      [aid, session.session_date, session.start_time, session.end_time, session.hito_reached || null, session.notes || null, req.body.staff_1_id ?? null, req.body.staff_2_id ?? null]);
    if (session.hito_reached) await execute('UPDATE filming_assignments SET last_hito_reached = ? WHERE id = ?', [session.hito_reached, aid]);
  }
  const result = await queryOne('SELECT fa.*, s.code as subject_code, s.name as subject_name FROM filming_assignments fa JOIN subjects s ON s.id = fa.subject_id WHERE fa.id = ?', [aid]);
  await logAction(user, `Creó filmación: ${result.subject_code} (${teacher_name})`, 'assignment', aid, session?.session_date ? `Fecha: ${session.session_date}` : null);
  
  if (pending_teacher_id) {
    const pt = await queryOne('SELECT * FROM pending_teachers WHERE id = ?', [pending_teacher_id]);
    if (pt?.added_by_user_id && pt.added_by_user_id != user.id) {
      await execute('INSERT INTO notifications (user_id, from_user_id, from_user_name, type, message, entity_type, entity_id) VALUES (?, ?, ?, ?, ?, ?, ?)',
        [pt.added_by_user_id, user.id, user.name, 'scheduled', `${user.name} agendó filmación de ${teacher_name}`, 'assignment', aid]);
    }
  }
  res.status(201).json(result);
}));
app.get('/api/assignments/:id', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;
  const id = parseInt(req.params.id);
  const a = await queryOne('SELECT fa.*, s.code as subject_code, s.name as subject_name FROM filming_assignments fa JOIN subjects s ON s.id = fa.subject_id WHERE fa.id = ?', [id]);
  if (!a) return res.status(404).json({ error: 'No encontrada' });
  a.sessions = await queryAll('SELECT rs.*, u1.name as staff_1_name, u2.name as staff_2_name, u3.name as staff_3_name, u4.name as staff_4_name FROM recording_sessions rs LEFT JOIN users u1 ON rs.staff_1_id = u1.id LEFT JOIN users u2 ON rs.staff_2_id = u2.id LEFT JOIN users u3 ON rs.staff_3_id = u3.id LEFT JOIN users u4 ON rs.staff_4_id = u4.id WHERE rs.assignment_id = ? ORDER BY rs.session_date ASC', [id]);
  res.json(a);
}));
app.put('/api/assignments/:id', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;
  const id = parseInt(req.params.id);
  const { teacher_name, phone, drive_link, script_status, status, sede, flight_ticket_path, assigned_staff, bitacora, rating, rating_comment } = req.body;
  if (teacher_name !== undefined) await execute('UPDATE filming_assignments SET teacher_name = ? WHERE id = ?', [teacher_name, id]);
  if (phone !== undefined) await execute('UPDATE filming_assignments SET phone = ? WHERE id = ?', [phone, id]);
  if (drive_link !== undefined) await execute('UPDATE filming_assignments SET drive_link = ? WHERE id = ?', [drive_link, id]);
  if (script_status !== undefined) await execute('UPDATE filming_assignments SET script_status = ? WHERE id = ?', [script_status, id]);
  if (sede !== undefined) await execute('UPDATE filming_assignments SET sede = ? WHERE id = ?', [sede, id]);
  if (flight_ticket_path !== undefined) await execute('UPDATE filming_assignments SET flight_ticket_path = ? WHERE id = ?', [flight_ticket_path, id]);
  if (assigned_staff !== undefined) await execute('UPDATE filming_assignments SET assigned_staff = ? WHERE id = ?', [assigned_staff, id]);
  if (bitacora !== undefined) await execute('UPDATE filming_assignments SET bitacora = ? WHERE id = ?', [bitacora, id]);
  if (rating !== undefined) await execute('UPDATE filming_assignments SET rating = ? WHERE id = ?', [rating || null, id]);
  if (rating_comment !== undefined) await execute('UPDATE filming_assignments SET rating_comment = ? WHERE id = ?', [rating_comment || null, id]);
  if (status !== undefined) {
    await execute('UPDATE filming_assignments SET status = ? WHERE id = ?', [status, id]);
    if (status === 'completed') {
      const a = await queryOne('SELECT subject_id FROM filming_assignments WHERE id = ?', [id]);
      if (a) await execute('UPDATE subjects SET completed = true WHERE id = ?', [a.subject_id]);
    }
  }
  const updated = await queryOne('SELECT fa.*, s.code as subject_code, s.name as subject_name FROM filming_assignments fa JOIN subjects s ON s.id = fa.subject_id WHERE fa.id = ?', [id]);
  if (status !== undefined || teacher_name !== undefined) await logAction(user, status ? `Marcó filmación como: ${status}` : `Editó filmación: ${updated.subject_code}`, 'assignment', id, updated.teacher_name);
  res.json(updated);
}));
app.delete('/api/assignments/:id', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;
  const id = parseInt(req.params.id);
  const fa = await queryOne('SELECT fa.*, s.code as subject_code FROM filming_assignments fa JOIN subjects s ON s.id = fa.subject_id WHERE fa.id = ?', [id]);
  if (fa) await logAction(user, `Eliminó filmación: ${fa.subject_code} (${fa.teacher_name})`, 'assignment', id);
  await execute('DELETE FROM filming_assignments WHERE id = ?', [id]);
  res.json({ success: true });
}));

// --- SESSIONS ---
app.get('/api/sessions', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;
  const { month, year } = req.query;
  let q = "SELECT rs.*, fa.teacher_name, fa.phone, fa.subject_id, fa.drive_link, fa.script_status, fa.status as assignment_status, fa.id as assignment_id, fa.sede, s.code as subject_code, s.name as subject_name, s.subject_type, (SELECT gs.career FROM global_subjects gs WHERE gs.code = s.code LIMIT 1) AS career, u1.name as staff_1_name, u2.name as staff_2_name, u3.name as staff_3_name, u4.name as staff_4_name FROM recording_sessions rs JOIN filming_assignments fa ON fa.id = rs.assignment_id JOIN subjects s ON s.id = fa.subject_id JOIN semesters sem ON sem.id = s.semester_id AND sem.is_active = true LEFT JOIN users u1 ON rs.staff_1_id = u1.id LEFT JOIN users u2 ON rs.staff_2_id = u2.id LEFT JOIN users u3 ON rs.staff_3_id = u3.id LEFT JOIN users u4 ON rs.staff_4_id = u4.id";
  const params = [];
  if (month && year) {
    q += " WHERE EXTRACT(YEAR FROM rs.session_date) = ? AND EXTRACT(MONTH FROM rs.session_date) = ?";
    params.push(parseInt(year), parseInt(month));
  }
  q += " ORDER BY rs.session_date ASC, rs.start_time ASC";
  res.json(await queryAll(q, params));
}));
app.get('/api/sessions/availability', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;
  const year = parseInt(req.query.year || new Date().getFullYear());
  const month = parseInt(req.query.month || (new Date().getMonth() + 1));
  const sessions = await queryAll("SELECT session_date, start_time, end_time, is_displacement FROM recording_sessions WHERE EXTRACT(YEAR FROM session_date) = ? AND EXTRACT(MONTH FROM session_date) = ? AND (status IS NULL OR status != 'cancelled')", [year, month]);
  const reservations = await queryAll("SELECT date, start_time, end_time FROM reservations WHERE is_displacement = 0 AND EXTRACT(YEAR FROM date) = ? AND EXTRACT(MONTH FROM date) = ?", [year, month]);
  const result = {};
  const pad = n => String(n).padStart(2, '0');
  // Filter out displacement sessions once (they don't block the studio)
  const nonDispSessions = sessions.filter(s => !s.is_displacement || s.is_displacement == 0);
  for (let day = 1; day <= new Date(year, month, 0).getDate(); day++) {
    const dateStr = `${year}-${pad(month)}-${pad(day)}`;
    let morningBusy = false, afternoonBusy = false;
    [...nonDispSessions, ...reservations.map(r => ({ session_date: r.date, start_time: r.start_time, end_time: r.end_time }))].forEach(s => {
      if (s.session_date !== dateStr) return;
      const t1 = s.start_time?.substring(0,5);
      const t2 = s.end_time?.substring(0,5);
      if (t1 < '13:00') {
        morningBusy = true;
        if (t2 >= '14:00') afternoonBusy = true;
      } else {
        afternoonBusy = true;
      }
    });
    if (morningBusy && afternoonBusy) result[dateStr] = 'full';
    else if (morningBusy) result[dateStr] = 'morning_busy';
    else if (afternoonBusy) result[dateStr] = 'afternoon_busy';
  }
  res.json(result);
}));
app.post('/api/sessions', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;
  const { assignment_id, session_date, start_time, end_time, hito_reached, notes, staff_1_id, staff_2_id, is_displacement } = req.body;
  // Check conflicts with other sessions
  let conflictMsg = null;
  const sConflict = await queryOne(
    `SELECT rs.id, fa.teacher_name, sub.code as subject_code, rs.start_time, rs.end_time 
     FROM recording_sessions rs 
     JOIN filming_assignments fa ON rs.assignment_id = fa.id 
     JOIN subjects sub ON fa.subject_id = sub.id 
     WHERE rs.session_date = ? AND rs.status != 'cancelled' 
     AND ((? >= rs.start_time AND ? < rs.end_time) OR (? > rs.start_time AND ? <= rs.end_time) OR (? <= rs.start_time AND ? >= rs.end_time))`,
    [session_date, start_time, start_time, end_time, end_time, start_time, end_time]
  );
  if (sConflict) {
    conflictMsg = `Conflicto con la sesión de ${sConflict.teacher_name} (${sConflict.subject_code}) de ${sConflict.start_time?.substring(0,5)} a ${sConflict.end_time?.substring(0,5)}`;
  } else {
    // Check conflicts with reservations (that are not displacements)
    const rConflict = await queryOne(
      `SELECT r.id, r.reason, u.name as user_name, r.start_time, r.end_time 
       FROM reservations r 
       JOIN users u ON r.user_id = u.id 
       WHERE r.date = ? AND r.is_displacement = 0
       AND ((? >= r.start_time AND ? < r.end_time) OR (? > r.start_time AND ? <= r.end_time) OR (? <= r.start_time AND ? >= r.end_time))`,
      [session_date, start_time, start_time, end_time, end_time, start_time, end_time]
    );
    if (rConflict) {
      conflictMsg = `Conflicto con la reserva de ${rConflict.user_name} (${rConflict.reason || 'Sin motivo'}) de ${rConflict.start_time?.substring(0,5)} a ${rConflict.end_time?.substring(0,5)}`;
    }
  }

  if (conflictMsg) return res.status(409).json({ error: conflictMsg });
  const sid = await execute('INSERT INTO recording_sessions (assignment_id, session_date, start_time, end_time, hito_reached, notes, staff_1_id, staff_2_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
    [assignment_id, session_date, start_time, end_time, hito_reached || null, notes || null, staff_1_id || null, staff_2_id || null]);
  // Set is_displacement in a separate safe call (column may not exist on first deploy)
  if (is_displacement) {
    try { await execute('UPDATE recording_sessions SET is_displacement = ? WHERE id = ?', [1, sid]); } catch(e) { /* column not yet migrated */ }
  }
  if (hito_reached) {
    await execute('UPDATE filming_assignments SET last_hito_reached = ? WHERE id = ?', [hito_reached, assignment_id]);
    if (hito_reached === 'semanas') {
      await execute("UPDATE filming_assignments SET status = 'completed' WHERE id = ?", [assignment_id]);
      const a = await queryOne('SELECT subject_id FROM filming_assignments WHERE id = ?', [assignment_id]);
      if (a) await execute('UPDATE subjects SET completed = true WHERE id = ?', [a.subject_id]);
    }
  }
  res.status(201).json(await queryOne('SELECT * FROM recording_sessions WHERE id = ?', [sid]));
}));
app.put('/api/sessions/:id', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;
  const id = parseInt(req.params.id);
  const body = req.body;
  if (body.session_date !== undefined || body.start_time !== undefined || body.end_time !== undefined) {
    const currentSession = await queryOne('SELECT * FROM recording_sessions WHERE id = ?', [id]);
    if (currentSession) {
      const session_date = body.session_date !== undefined ? body.session_date : currentSession.session_date;
      const start_time = body.start_time !== undefined ? body.start_time : currentSession.start_time;
      const end_time = body.end_time !== undefined ? body.end_time : currentSession.end_time;
      
      let conflictMsg = null;
      const sConflict = await queryOne(
        `SELECT rs.id, fa.teacher_name, sub.code as subject_code, rs.start_time, rs.end_time 
         FROM recording_sessions rs 
         JOIN filming_assignments fa ON rs.assignment_id = fa.id 
         JOIN subjects sub ON fa.subject_id = sub.id 
         WHERE rs.session_date = ? AND rs.status != 'cancelled' AND rs.id != ?
         AND ((? >= rs.start_time AND ? < rs.end_time) OR (? > rs.start_time AND ? <= rs.end_time) OR (? <= rs.start_time AND ? >= rs.end_time))`,
        [session_date, id, start_time, start_time, end_time, end_time, start_time, end_time]
      );
      if (sConflict) {
        conflictMsg = `Conflicto con la sesión de ${sConflict.teacher_name} (${sConflict.subject_code}) de ${sConflict.start_time?.substring(0,5)} a ${sConflict.end_time?.substring(0,5)}`;
      } else {
        const rConflict = await queryOne(
          `SELECT r.id, r.reason, u.name as user_name, r.start_time, r.end_time 
           FROM reservations r 
           JOIN users u ON r.user_id = u.id 
           WHERE r.date = ? AND r.is_displacement = 0
           AND ((? >= r.start_time AND ? < r.end_time) OR (? > r.start_time AND ? <= r.end_time) OR (? <= r.start_time AND ? >= r.end_time))`,
          [session_date, start_time, start_time, end_time, end_time, start_time, end_time]
        );
        if (rConflict) {
          conflictMsg = `Conflicto con la reserva de ${rConflict.user_name} (${rConflict.reason || 'Sin motivo'}) de ${rConflict.start_time?.substring(0,5)} a ${rConflict.end_time?.substring(0,5)}`;
        }
      }
      if (conflictMsg) return res.status(409).json({ error: conflictMsg });
    }
  }

  if (body.session_date !== undefined) await execute('UPDATE recording_sessions SET session_date = ? WHERE id = ?', [body.session_date, id]);
  if (body.start_time !== undefined) await execute('UPDATE recording_sessions SET start_time = ? WHERE id = ?', [body.start_time, id]);
  if (body.end_time !== undefined) await execute('UPDATE recording_sessions SET end_time = ? WHERE id = ?', [body.end_time, id]);
  if (body.hito_reached !== undefined) await execute('UPDATE recording_sessions SET hito_reached = ? WHERE id = ?', [body.hito_reached, id]);
  if (body.notes !== undefined) await execute('UPDATE recording_sessions SET notes = ? WHERE id = ?', [body.notes, id]);
  if ('staff_1_id' in body) await execute('UPDATE recording_sessions SET staff_1_id = ? WHERE id = ?', [body.staff_1_id, id]);
  if ('staff_2_id' in body) await execute('UPDATE recording_sessions SET staff_2_id = ? WHERE id = ?', [body.staff_2_id, id]);
  if ('staff_3_id' in body) await execute('UPDATE recording_sessions SET staff_3_id = ? WHERE id = ?', [body.staff_3_id, id]);
  if ('staff_4_id' in body) await execute('UPDATE recording_sessions SET staff_4_id = ? WHERE id = ?', [body.staff_4_id, id]);
  if ('is_displacement' in body) {
    await execute('UPDATE recording_sessions SET is_displacement = ? WHERE id = ?', [body.is_displacement ? 1 : 0, id]);
  }
  if (body.status !== undefined) {
    await execute('UPDATE recording_sessions SET status = ? WHERE id = ?', [body.status, id]);
    if (body.status === 'cancelled') {
      const sInfo = await queryOne('SELECT rs.session_date, rs.start_time, rs.end_time, rs.assignment_id, fa.teacher_name, sub.code FROM recording_sessions rs JOIN filming_assignments fa ON fa.id = rs.assignment_id JOIN subjects sub ON sub.id = fa.subject_id WHERE rs.id = ?', [id]);
      if (sInfo) {
        const cancelMsg = `[${sInfo.session_date} ${sInfo.start_time?.substring(0,5)}-${sInfo.end_time?.substring(0,5)}] Sesión CANCELADA — Docente no se presentó.`;
        const fa = await queryOne('SELECT bitacora FROM filming_assignments WHERE id = ?', [sInfo.assignment_id]);
        await execute('UPDATE filming_assignments SET bitacora = ? WHERE id = ?', [fa?.bitacora ? fa.bitacora + '\n' + cancelMsg : cancelMsg, sInfo.assignment_id]);
      }
    }
  }
  res.json(await queryOne('SELECT * FROM recording_sessions WHERE id = ?', [id]));
}));
app.delete('/api/sessions/:id', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;
  const id = parseInt(req.params.id);
  await execute('DELETE FROM recording_sessions WHERE id = ?', [id]);
  res.json({ success: true });
}));

// --- RESERVATIONS ---
app.get('/api/reservations', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;
  const { month, year } = req.query;
  let q = "SELECT r.*, u.name as user_name FROM reservations r JOIN users u ON u.id = r.user_id";
  const params = [];
  if (month && year) {
    q += " WHERE EXTRACT(YEAR FROM r.date) = ? AND EXTRACT(MONTH FROM r.date) = ?";
    params.push(parseInt(year), parseInt(month));
  }
  q += " ORDER BY r.date ASC, r.start_time ASC";
  res.json(await queryAll(q, params));
}));
app.post('/api/reservations', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;
  const { start_date, end_date, start_time, end_time, reason, is_displacement, attendees } = req.body;
  const current = new Date(start_date);
  const last = new Date(end_date);
  const d = new Date(current);
  while (d <= last) {
    const dStr = d.toISOString().split('T')[0];
    const exists = await queryOne('SELECT id FROM reservations WHERE user_id = ? AND date = ? AND start_time = ? AND end_time = ?', [user.id, dStr, start_time, end_time]);
    if (!exists) {
      await execute('INSERT INTO reservations (user_id, date, start_time, end_time, reason, is_displacement, attendees) VALUES (?, ?, ?, ?, ?, ?, ?)',
        [user.id, dStr, start_time, end_time, reason || 'Reserva', !!is_displacement, attendees || null]);
    }
    d.setDate(d.getDate() + 1);
  }
  res.status(201).json({ success: true });
}));
app.put('/api/reservations/:id', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;
  const id = parseInt(req.params.id);
  const { start_date, end_date, start_time, end_time, reason, is_displacement, attendees } = req.body;

  // Get the original row to find all sibling rows of this multi-day reservation
  const original = await queryOne('SELECT * FROM reservations WHERE id = ?', [id]);
  if (!original) return res.status(404).json({ error: 'Reserva no encontrada' });

  // Find all sibling rows (same user, same time, same reason = same reservation)
  const siblings = await queryAll(
    'SELECT id, date FROM reservations WHERE user_id = ? AND start_time = ? AND end_time = ? AND reason = ?',
    [original.user_id, original.start_time, original.end_time, original.reason]
  );
  const siblingIds = siblings.map(s => s.id);

  // Check if date range actually changed
  const oldDates = siblings.map(s => typeof s.date === 'string' ? s.date.substring(0, 10) : s.date.toISOString().substring(0, 10)).sort();
  const datesChanged = start_date && end_date && (oldDates[0] !== start_date || oldDates[oldDates.length - 1] !== end_date);

  if (datesChanged) {
    // Delete all old sibling rows and recreate for new date range
    if (siblingIds.length > 0) {
      await execute(`DELETE FROM reservations WHERE id IN (${siblingIds.map(() => '?').join(',')})`, siblingIds);
    }
    // Generate dates without timezone issues using string math
    const [sy, sm, sd] = start_date.split('-').map(Number);
    const [ey, em, ed] = end_date.split('-').map(Number);
    const startD = new Date(sy, sm - 1, sd);
    const endD = new Date(ey, em - 1, ed);
    for (let d = new Date(startD); d <= endD; d.setDate(d.getDate() + 1)) {
      const dStr = `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
      await execute('INSERT INTO reservations (user_id, date, start_time, end_time, reason, is_displacement, attendees) VALUES (?, ?, ?, ?, ?, ?, ?)',
        [original.user_id, dStr, start_time || original.start_time, end_time || original.end_time,
         reason !== undefined ? reason : original.reason,
         is_displacement !== undefined ? (is_displacement ? 1 : 0) : (original.is_displacement ? 1 : 0),
         attendees !== undefined ? attendees : original.attendees]);
    }
  } else {
    // Update all sibling rows in place (common case: toggling displacement, editing time, etc.)
    const updateAll = async (field, value) => {
      if (siblingIds.length > 0) {
        await execute(`UPDATE reservations SET ${field} = ? WHERE id IN (${siblingIds.map(() => '?').join(',')})`, [value, ...siblingIds]);
      }
    };
    if (start_time !== undefined) await updateAll('start_time', start_time);
    if (end_time !== undefined) await updateAll('end_time', end_time);
    if (reason !== undefined) await updateAll('reason', reason);
    if (is_displacement !== undefined) await updateAll('is_displacement', is_displacement ? 1 : 0);
    if (attendees !== undefined) await updateAll('attendees', attendees);
  }
  res.json({ success: true });
}));
app.delete('/api/reservations/:id', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;
  await execute('DELETE FROM reservations WHERE id = ?', [parseInt(req.params.id)]);
  res.json({ success: true });
}));

// --- USERS ---
app.get('/api/users', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAdmin(user, res)) return;
  res.json(await queryAll('SELECT id, username, role, name, created_at FROM users ORDER BY created_at ASC'));
}));
app.post('/api/users', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAdmin(user, res)) return;
  const { username, password, role, name } = req.body;
  try {
    const id = await execute('INSERT INTO users (username, password, role, name) VALUES (?, ?, ?, ?)', [username, bcrypt.hashSync(password, 10), role, name]);
    res.status(201).json(await queryOne('SELECT id, username, role, name, created_at FROM users WHERE id = ?', [id]));
  } catch (e) { res.status(409).json({ error: 'El usuario ya existe' }); }
}));
app.put('/api/users/:id', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAdmin(user, res)) return;
  const id = parseInt(req.params.id);
  const { username, password, role, name } = req.body;
  if (username !== undefined) await execute('UPDATE users SET username = ? WHERE id = ?', [username, id]);
  if (password) await execute('UPDATE users SET password = ? WHERE id = ?', [bcrypt.hashSync(password, 10), id]);
  if (role !== undefined) await execute('UPDATE users SET role = ? WHERE id = ?', [role, id]);
  if (name !== undefined) await execute('UPDATE users SET name = ? WHERE id = ?', [name, id]);
  res.json(await queryOne('SELECT id, username, role, name, created_at FROM users WHERE id = ?', [id]));
}));
app.delete('/api/users/:id', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAdmin(user, res)) return;
  const id = parseInt(req.params.id);
  if (id === user.id) return res.status(400).json({ error: 'No puedes eliminarte a ti mismo' });
  await execute('DELETE FROM users WHERE id = ?', [id]);
  res.json({ success: true });
}));

// --- CLOSED WEEKS ---
app.get('/api/closed-weeks', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;
  res.json(await queryAll('SELECT * FROM closed_weeks ORDER BY week_start DESC'));
}));
app.post('/api/closed-weeks', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;
  try {
    await execute('INSERT INTO closed_weeks (week_start, reason) VALUES (?, ?)', [req.body.week_start, req.body.reason || 'Estudio cerrado']);
    res.status(201).json(await queryOne('SELECT * FROM closed_weeks ORDER BY id DESC LIMIT 1'));
  } catch (e) { res.status(409).json({ error: 'Semana ya cerrada' }); }
}));
app.delete('/api/closed-weeks/:id', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;
  await execute('DELETE FROM closed_weeks WHERE id = ?', [parseInt(req.params.id)]);
  res.json({ success: true });
}));

// --- NOTIFICATIONS ---
app.get('/api/notifications', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;
  try {
    const limit = parseInt(req.query.limit || 20);
    const notifications = await queryAll('SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC LIMIT ?', [user.id, limit]);
    const row = await queryOne('SELECT COUNT(*) as c FROM notifications WHERE user_id = ? AND is_read = false', [user.id]);
    res.json({ notifications, unread_count: parseInt(row?.c || 0) });
  } catch (e) { res.json({ notifications: [], unread_count: 0 }); }
}));
app.put('/api/notifications/read-all', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;
  await execute('UPDATE notifications SET is_read = true WHERE user_id = ?', [user.id]);
  res.json({ success: true });
}));
app.put('/api/notifications/:id/read', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;
  await execute('UPDATE notifications SET is_read = true WHERE id = ? AND user_id = ?', [parseInt(req.params.id), user.id]);
  res.json({ success: true });
}));

// --- PENDING TEACHERS ---
app.get('/api/pending-teachers', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;
  let semId = req.query.semester_id;
  if (!semId || semId === 'undefined') {
    const active = await queryOne('SELECT id FROM semesters WHERE is_active = true');
    semId = active ? active.id : 0;
  }
  // Subquery: get the latest non-cancelled filming_assignment per teacher in this semester
  res.json(await queryAll(`
    SELECT pt.*,
           u.name  AS added_by_name,
           fa.status AS assignment_status,
           fa.id     AS assignment_id
    FROM pending_teachers pt
    LEFT JOIN users u ON u.id = pt.added_by_user_id
    LEFT JOIN (
      SELECT fa2.id, fa2.teacher_name, fa2.status, s2.semester_id
      FROM filming_assignments fa2
      JOIN subjects s2 ON s2.id = fa2.subject_id
      WHERE fa2.status IS NULL OR fa2.status != 'cancelled'
    ) fa ON LOWER(TRIM(fa.teacher_name)) = LOWER(TRIM(pt.name))
         AND fa.semester_id = pt.semester_id
    WHERE pt.semester_id = ?
    ORDER BY
      CASE COALESCE(pt.status,'pending')
        WHEN 'guion_revisado'   THEN 1
        WHEN 'pending'          THEN 2
        WHEN 'guion_incompleto' THEN 3
        WHEN 'contacted'        THEN 4
        WHEN 'scheduled'        THEN 5
        WHEN 'unavailable'      THEN 6
        ELSE 7
      END, pt.created_at ASC
  `, [semId]));
}));
app.post('/api/pending-teachers', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;
  let { name, subject_code, subject, subject_type, phone, sede, is_external, notes, drive_link, flight_ticket_path, semester_id } = req.body;
  if (!semester_id) {
    const active = await queryOne('SELECT id FROM semesters WHERE is_active = true');
    semester_id = active ? active.id : null;
  }
  if (!subject_code) { const ext = extractCodeAndName(subject); subject_code = ext.code; subject = ext.name; }
  const id = await execute(
    'INSERT INTO pending_teachers (semester_id, name, subject_code, subject, subject_type, phone, sede, is_external, notes, drive_link, flight_ticket_path, added_by_user_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
    [semester_id ?? null, name ?? null, subject_code ?? null, subject ?? null, subject_type || 'Teórica', phone ?? null, sede || 'La Paz', !!is_external, notes ?? null, drive_link ?? null, flight_ticket_path ?? null, user.id]
  );
  res.status(201).json(await queryOne('SELECT pt.*, u.name as added_by_name FROM pending_teachers pt LEFT JOIN users u ON u.id = pt.added_by_user_id WHERE pt.id = ?', [id]));
}));
app.put('/api/pending-teachers/:id', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;
  const id = parseInt(req.params.id);
  let { name, subject_code, subject, subject_type, phone, sede, is_external, notes, drive_link, flight_ticket_path, resolved, status } = req.body;
  if (subject !== undefined && subject_code === undefined) { const ext = extractCodeAndName(subject); subject_code = ext.code; subject = ext.name; }
  if (name !== undefined) await execute('UPDATE pending_teachers SET name = ? WHERE id = ?', [name, id]);
  if (subject_code !== undefined) await execute('UPDATE pending_teachers SET subject_code = ? WHERE id = ?', [subject_code, id]);
  if (subject !== undefined) await execute('UPDATE pending_teachers SET subject = ? WHERE id = ?', [subject, id]);
  if (subject_type !== undefined) await execute('UPDATE pending_teachers SET subject_type = ? WHERE id = ?', [subject_type, id]);
  if (phone !== undefined) await execute('UPDATE pending_teachers SET phone = ? WHERE id = ?', [phone, id]);
  if (sede !== undefined) await execute('UPDATE pending_teachers SET sede = ? WHERE id = ?', [sede, id]);
  if (is_external !== undefined) await execute('UPDATE pending_teachers SET is_external = ? WHERE id = ?', [!!is_external, id]);
  if (notes !== undefined) await execute('UPDATE pending_teachers SET notes = ? WHERE id = ?', [notes, id]);
  if (drive_link !== undefined) await execute('UPDATE pending_teachers SET drive_link = ? WHERE id = ?', [drive_link, id]);
  if (flight_ticket_path !== undefined) await execute('UPDATE pending_teachers SET flight_ticket_path = ? WHERE id = ?', [flight_ticket_path, id]);
  if (resolved !== undefined) await execute('UPDATE pending_teachers SET resolved = ? WHERE id = ?', [!!resolved, id]);
  if (status !== undefined) {
    await execute('UPDATE pending_teachers SET status = ? WHERE id = ?', [status, id]);
    if ((status === 'scheduled' || status === 'contacted') && user) {
      const pt = await queryOne('SELECT * FROM pending_teachers WHERE id = ?', [id]);
      if (pt?.added_by_user_id && pt.added_by_user_id != user.id) {
        await execute('INSERT INTO notifications (user_id, from_user_id, from_user_name, type, message, entity_type, entity_id) VALUES (?, ?, ?, ?, ?, ?, ?)',
          [pt.added_by_user_id, user.id, user.name, status, `${user.name} actualizó a ${pt.name}`, 'pending_teacher', id]);
      }
    }
  }
  res.json(await queryOne('SELECT pt.*, u.name as added_by_name FROM pending_teachers pt LEFT JOIN users u ON u.id = pt.added_by_user_id WHERE pt.id = ?', [id]));
}));
app.delete('/api/pending-teachers/:id', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;
  await execute('DELETE FROM pending_teachers WHERE id = ?', [parseInt(req.params.id)]);
  res.json({ success: true });
}));

// --- GLOBAL SUBJECTS ---
app.get('/api/global-subjects', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;
  const q = req.query.q;
  if (q) return res.json(await queryAll('SELECT * FROM global_subjects WHERE code LIKE ? OR name LIKE ? ORDER BY code ASC LIMIT 50', [`%${q}%`, `%${q}%`]));
  res.json(await queryAll('SELECT * FROM global_subjects ORDER BY code ASC'));
}));
app.post('/api/global-subjects', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAdmin(user, res)) return;
  try {
    const id = await execute('INSERT INTO global_subjects (code, name, career) VALUES (?, ?, ?)', [req.body.code, req.body.name, req.body.career]);
    res.status(201).json(await queryOne('SELECT * FROM global_subjects WHERE id = ?', [id]));
  } catch (e) { res.status(409).json({ error: 'Esa materia ya existe' }); }
}));
app.delete('/api/global-subjects/:id', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAdmin(user, res)) return;
  await execute('DELETE FROM global_subjects WHERE id = ?', [parseInt(req.params.id)]);
  res.json({ success: true });
}));
app.post('/api/global-subjects/bulk', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAdmin(user, res)) return;
  let inserted = 0, skipped = 0;
  for (const s of req.body.subjects) {
    try { await execute('INSERT IGNORE INTO global_subjects (code, name, career) VALUES (?, ?, ?)', [s.code, s.name, s.career]); inserted++; } 
    catch (e) { skipped++; }
  }
  res.json({ inserted, skipped });
}));

// --- MEETING REQUESTS & PUBLIC ---
app.get('/api/meeting-requests', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;
  const status = req.query.status;
  res.json(await queryAll(status ? 'SELECT * FROM meeting_requests WHERE status = ? ORDER BY created_at DESC' : 'SELECT * FROM meeting_requests ORDER BY created_at DESC', status ? [status] : []));
}));
app.put('/api/meeting-requests/:id', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;
  const id = parseInt(req.params.id);
  const { status, admin_notes } = req.body;
  const mr = await queryOne('SELECT * FROM meeting_requests WHERE id = ?', [id]);
  await execute('UPDATE meeting_requests SET status = ?, admin_notes = ?, reviewed_by_user_id = ?, reviewed_at = NOW() WHERE id = ?', [status, admin_notes || null, user.id, id]);
  if (status === 'approved') {
    await execute('INSERT INTO reservations (user_id, date, start_time, end_time, reason, is_displacement) VALUES (?, ?, ?, ?, ?, false)', [user.id, mr.requested_date, mr.start_time, mr.end_time, `Reunión: ${mr.requester_name}`]);
  }
  res.json({ success: true });
}));

app.get('/api/public/availability', asyncHandler(async (req, res) => {
  const year = parseInt(req.query.year || new Date().getFullYear());
  const month = parseInt(req.query.month || (new Date().getMonth() + 1));
  const pad = n => String(n).padStart(2, '0');
  const stRow = await queryOne("SELECT value FROM settings WHERE key = 'studio_start_time'");
  const etRow = await queryOne("SELECT value FROM settings WHERE key = 'studio_end_time'");
  const daysRow = await queryOne("SELECT value FROM settings WHERE key = 'studio_days'");
  const studioStart = stRow?.value || '08:00';
  const studioEnd = etRow?.value || '18:00';
  const workDays = (daysRow?.value || '1,2,3,4,5').split(',').map(Number);

  const sessions = await queryAll("SELECT session_date, start_time, end_time FROM recording_sessions WHERE EXTRACT(YEAR FROM session_date) = ? AND EXTRACT(MONTH FROM session_date) = ? AND (status IS NULL OR status != 'cancelled')", [year, month]);
  const reservations = await queryAll("SELECT date, start_time, end_time FROM reservations WHERE is_displacement = false AND EXTRACT(YEAR FROM date) = ? AND EXTRACT(MONTH FROM date) = ?", [year, month]);
  const closedWeeks = await queryAll('SELECT week_start FROM closed_weeks');
  const meetingRequests = await queryAll("SELECT requested_date, start_time, end_time FROM meeting_requests WHERE status = 'pending' AND EXTRACT(YEAR FROM requested_date) = ? AND EXTRACT(MONTH FROM requested_date) = ?", [year, month]);

  const availability = [];
  for (let day = 1; day <= new Date(year, month, 0).getDate(); day++) {
    const dateStr = `${year}-${pad(month)}-${pad(day)}`;
    const d = new Date(dateStr);
    const dow = d.getDay() === 0 ? 7 : d.getDay();
    if (!workDays.includes(dow)) { availability.push({ date: dateStr, status: 'closed' }); continue; }
    
    const mondayOffset = dow === 1 ? 0 : 1 - dow;
    const monday = new Date(d); monday.setDate(d.getDate() + mondayOffset);
    if (closedWeeks.some(cw => cw.week_start === monday.toISOString().split('T')[0])) {
      availability.push({ date: dateStr, status: 'closed', reason: 'Semana cerrada' }); continue;
    }

    const dayMR = meetingRequests.filter(mr => mr.requested_date === dateStr);
    const busyIntervals = [
      ...sessions.filter(s => s.session_date === dateStr).map(s => ({ start: s.start_time?.substring(0, 5), end: s.end_time?.substring(0, 5) })),
      ...reservations.filter(r => r.date === dateStr).map(r => ({ start: r.start_time?.substring(0, 5), end: r.end_time?.substring(0, 5) })),
    ];

    const startH = parseInt(studioStart.split(':')[0]);
    const endH = parseInt(studioEnd.split(':')[0]);
    const allSlots = [];
    for (let h = startH; h < endH; h++) {
      const ss = `${pad(h)}:00`; const se = `${pad(h+1)}:00`;
      if (!busyIntervals.some(b => !(se <= b.start || ss >= b.end))) allSlots.push({ start: ss, end: se });
    }

    if (allSlots.length === 0) availability.push({ date: dateStr, status: 'occupied' });
    else if (allSlots.length === endH - startH) availability.push({ date: dateStr, status: 'available', start_time: studioStart, end_time: studioEnd, pending_meetings: dayMR.length });
    else {
      const merged = [];
      for (const slot of allSlots) {
        if (merged.length && merged[merged.length-1].end === slot.start) merged[merged.length-1].end = slot.end;
        else merged.push({ ...slot });
      }
      availability.push({ date: dateStr, status: 'partial', free_slots: merged, pending_meetings: dayMR.length });
    }
  }
  res.json({ month, year, studio_hours: { start: studioStart, end: studioEnd }, work_days: workDays, availability });
}));
app.post('/api/public/meeting-request', asyncHandler(async (req, res) => {
  const { requester_name, requester_contact, requested_date, start_time, end_time, reason } = req.body;
  const id = await execute('INSERT INTO meeting_requests (requester_name, requester_contact, requested_date, start_time, end_time, reason) VALUES (?, ?, ?, ?, ?, ?)', [requester_name, requester_contact || null, requested_date, start_time, end_time, reason || null]);
  res.status(201).json({ success: true, id });
}));


// ================================================
// Holidays (Feriados)
// ================================================
app.get('/api/holidays', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAuth(user, res)) return;
  const rows = await queryAll('SELECT * FROM holidays ORDER BY is_fixed DESC, date_key ASC');
  res.json(rows);
}));

app.post('/api/holidays', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAdmin(user, res)) return;
  const { date_key, name, is_fixed } = req.body;
  if (!date_key || !name) return res.status(400).json({ error: 'date_key y name son requeridos' });
  // Validate format: MM-DD or YYYY-MM-DD
  const fixedPattern = /^\d{2}-\d{2}$/;
  const mobilePattern = /^\d{4}-\d{2}-\d{2}$/;
  if (!fixedPattern.test(date_key) && !mobilePattern.test(date_key)) {
    return res.status(400).json({ error: 'Formato de fecha inválido. Usa MM-DD (fijo) o YYYY-MM-DD (móvil)' });
  }
  try {
    const id = await execute('INSERT INTO holidays (date_key, name, is_fixed) VALUES (?, ?, ?)', [date_key, name.trim(), is_fixed ? 1 : 0]);
    await logAction(user, `Agregó feriado "${name}" (${date_key})`, 'holiday', id);
    res.status(201).json(await queryOne('SELECT * FROM holidays WHERE id = ?', [id]));
  } catch (e) {
    if (e.code === 'ER_DUP_ENTRY') return res.status(409).json({ error: 'Ya existe un feriado con esa fecha' });
    throw e;
  }
}));

app.delete('/api/holidays/:id', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAdmin(user, res)) return;
  const id = parseInt(req.params.id);
  const h = await queryOne('SELECT * FROM holidays WHERE id = ?', [id]);
  if (!h) return res.status(404).json({ error: 'Feriado no encontrado' });
  await execute('DELETE FROM holidays WHERE id = ?', [id]);
  await logAction(user, `Eliminó feriado "${h.name}" (${h.date_key})`, 'holiday', id);
  res.json({ success: true });
}));

// ================================================
// QUERY API — Autenticación por API Key
// ================================================

/**
 * Middleware: valida API Key via header Authorization: Bearer <key>
 * o query param ?api_key=<key>
 * Actualiza last_used_at en cada uso.
 */
async function requireApiKey(req, res, next) {
  let rawKey = null;
  const authHeader = req.headers['authorization'] || req.headers['Authorization'];
  if (authHeader && authHeader.startsWith('Bearer ')) {
    rawKey = authHeader.slice(7).trim();
  }
  if (!rawKey && req.query.api_key) {
    rawKey = String(req.query.api_key).trim();
  }
  if (!rawKey) {
    return res.status(401).json({ error: 'API Key requerida. Usa Authorization: Bearer <key> o ?api_key=<key>' });
  }
  const crypto = require('crypto');
  const hash = crypto.createHash('sha256').update(rawKey).digest('hex');
  const keyRow = await require('../src/db').queryOne(
    'SELECT * FROM api_keys WHERE key_hash = ? AND is_active = 1',
    [hash]
  );
  if (!keyRow) {
    return res.status(401).json({ error: 'API Key inválida o revocada' });
  }
  // Actualizar last_used_at de forma no bloqueante
  require('../src/db').execute('UPDATE api_keys SET last_used_at = NOW() WHERE id = ?', [keyRow.id]).catch(() => {});
  req.apiKeyRow = keyRow;
  next();
}

// --- ADMIN: Gestión de API Keys ---

app.get('/api/admin/api-keys', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAdmin(user, res)) return;
  const rows = await queryAll(
    'SELECT id, name, key_preview, is_active, created_by, last_used_at, created_at FROM api_keys ORDER BY created_at DESC'
  );
  res.json(rows);
}));

app.post('/api/admin/api-keys', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAdmin(user, res)) return;
  const { name } = req.body;
  if (!name || !name.trim()) return res.status(400).json({ error: 'El campo "name" es requerido' });

  // Generar token seguro
  const rawToken = crypto.randomBytes(40).toString('hex'); // 80 chars hex
  const hash = crypto.createHash('sha256').update(rawToken).digest('hex');
  const preview = rawToken.substring(0, 8) + '...';

  const id = await execute(
    'INSERT INTO api_keys (name, key_hash, key_preview, created_by, is_active) VALUES (?, ?, ?, ?, 1)',
    [name.trim(), hash, preview, user.id]
  );
  await logAction(user, `Creó API Key "${name}" (id=${id})`, 'api_key', id);
  // Retornar el token real UNA SOLA VEZ
  res.status(201).json({
    id,
    name: name.trim(),
    key_preview: preview,
    is_active: 1,
    created_at: new Date().toISOString(),
    // ⚠️ Este es el único momento en que se muestra el token completo
    api_key: rawToken,
    warning: 'Guarda esta clave ahora. No se volverá a mostrar.'
  });
}));

app.put('/api/admin/api-keys/:id/toggle', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAdmin(user, res)) return;
  const id = parseInt(req.params.id);
  const k = await queryOne('SELECT * FROM api_keys WHERE id = ?', [id]);
  if (!k) return res.status(404).json({ error: 'API Key no encontrada' });
  const newState = k.is_active ? 0 : 1;
  await execute('UPDATE api_keys SET is_active = ? WHERE id = ?', [newState, id]);
  await logAction(user, `${newState ? 'Activó' : 'Desactivó'} API Key "${k.name}" (id=${id})`, 'api_key', id);
  res.json({ success: true, is_active: newState });
}));

app.delete('/api/admin/api-keys/:id', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAdmin(user, res)) return;
  const id = parseInt(req.params.id);
  const k = await queryOne('SELECT * FROM api_keys WHERE id = ?', [id]);
  if (!k) return res.status(404).json({ error: 'API Key no encontrada' });
  await execute('DELETE FROM api_keys WHERE id = ?', [id]);
  await logAction(user, `Eliminó API Key "${k.name}" (id=${id})`, 'api_key', id);
  res.json({ success: true });
}));

// --- QUERY API: Disponibilidad ---

/**
 * Helper: calcular disponibilidad de un día dado todos los datos necesarios.
 * Regla especial de desplazamiento:
 *   Si el día SOLO tiene sesiones de desplazamiento (is_displacement=1)
 *   y ninguna sesión normal, el estudio está libre → status 'displacement'.
 */
function calcDayAvailability({ dateStr, dow, workDays, closedWeeks, sessions, displacementSessions, reservations, studioStart, studioEnd }) {
  const pad = n => String(n).padStart(2, '0');

  // Día no laborable
  if (!workDays.includes(dow)) return { date: dateStr, status: 'closed', reason: 'Día no laborable' };

  // Semana cerrada
  const d = new Date(dateStr);
  const mondayOffset = dow === 1 ? 0 : 1 - dow;
  const monday = new Date(d);
  monday.setDate(d.getDate() + mondayOffset);
  const mondayStr = monday.toISOString().split('T')[0];
  if (closedWeeks.some(cw => cw.week_start === mondayStr)) {
    return { date: dateStr, status: 'closed', reason: 'Semana cerrada' };
  }

  const dayNormalSessions = sessions.filter(s => s.session_date === dateStr);
  const dayDisplacements = displacementSessions.filter(s => s.session_date === dateStr);
  const dayReservations = reservations.filter(r => r.date === dateStr);

  // Si SOLO hay desplazamientos (sin sesiones normales y sin reservas), el estudio está disponible
  if (dayDisplacements.length > 0 && dayNormalSessions.length === 0 && dayReservations.length === 0) {
    return {
      date: dateStr,
      status: 'displacement',
      is_displacement: true,
      free_slots: [{ start: studioStart, end: studioEnd }],
      notes: 'Equipo en desplazamiento — estudio disponible'
    };
  }

  // Calcular slots ocupados
  const busyIntervals = [
    ...dayNormalSessions.map(s => ({ start: s.start_time?.substring(0, 5), end: s.end_time?.substring(0, 5) })),
    ...dayReservations.map(r => ({ start: r.start_time?.substring(0, 5), end: r.end_time?.substring(0, 5) })),
  ];

  const startH = parseInt(studioStart.split(':')[0]);
  const endH   = parseInt(studioEnd.split(':')[0]);
  const allSlots = [];
  for (let h = startH; h < endH; h++) {
    const ss = `${pad(h)}:00`;
    const se = `${pad(h + 1)}:00`;
    if (!busyIntervals.some(b => !(se <= b.start || ss >= b.end))) allSlots.push({ start: ss, end: se });
  }

  if (allSlots.length === 0) return { date: dateStr, status: 'occupied', is_displacement: false };
  if (allSlots.length === endH - startH) {
    return { date: dateStr, status: 'available', is_displacement: false, free_slots: [{ start: studioStart, end: studioEnd }] };
  }

  // Fusionar slots adyacentes
  const merged = [];
  for (const slot of allSlots) {
    if (merged.length && merged[merged.length - 1].end === slot.start) merged[merged.length - 1].end = slot.end;
    else merged.push({ ...slot });
  }
  return { date: dateStr, status: 'partial', is_displacement: false, free_slots: merged };
}

/**
 * Helper: cargar datos de estudio y sesiones para un rango de fechas.
 */
async function loadStudioData(startDate, endDate) {
  const stRow = await queryOne("SELECT value FROM settings WHERE `key` = 'studio_start_time'");
  const etRow = await queryOne("SELECT value FROM settings WHERE `key` = 'studio_end_time'");
  const daysRow = await queryOne("SELECT value FROM settings WHERE `key` = 'studio_days'");
  const studioStart = stRow?.value || '08:00';
  const studioEnd   = etRow?.value || '18:00';
  const workDays    = (daysRow?.value || '1,2,3,4,5').split(',').map(Number);

  const sessions = await queryAll(
    "SELECT session_date, start_time, end_time FROM recording_sessions WHERE session_date >= ? AND session_date <= ? AND (status IS NULL OR status != 'cancelled') AND (is_displacement = 0 OR is_displacement IS NULL)",
    [startDate, endDate]
  );
  const displacementSessions = await queryAll(
    "SELECT session_date, start_time, end_time FROM recording_sessions WHERE session_date >= ? AND session_date <= ? AND (status IS NULL OR status != 'cancelled') AND is_displacement = 1",
    [startDate, endDate]
  );
  const reservations = await queryAll(
    'SELECT date, start_time, end_time FROM reservations WHERE is_displacement = false AND date >= ? AND date <= ?',
    [startDate, endDate]
  );
  const closedWeeks = await queryAll('SELECT week_start FROM closed_weeks');

  return { studioStart, studioEnd, workDays, sessions, displacementSessions, reservations, closedWeeks };
}

// GET /api/query/availability?year=YYYY&month=MM
app.get('/api/query/availability', asyncHandler(async (req, res) => {
  await new Promise((resolve, reject) => requireApiKey(req, res, (err) => err ? reject(err) : resolve()));
  if (res.headersSent) return;

  const year  = parseInt(req.query.year  || new Date().getFullYear());
  const month = parseInt(req.query.month || (new Date().getMonth() + 1));
  const pad   = n => String(n).padStart(2, '0');
  const daysInMonth = new Date(year, month, 0).getDate();
  const startDate = `${year}-${pad(month)}-01`;
  const endDate   = `${year}-${pad(month)}-${pad(daysInMonth)}`;

  const data = await loadStudioData(startDate, endDate);
  const availability = [];

  for (let day = 1; day <= daysInMonth; day++) {
    const dateStr = `${year}-${pad(month)}-${pad(day)}`;
    const d = new Date(dateStr);
    const dow = d.getDay() === 0 ? 7 : d.getDay();
    availability.push(calcDayAvailability({ dateStr, dow, ...data }));
  }

  res.json({
    year,
    month,
    studio_hours: { start: data.studioStart, end: data.studioEnd },
    work_days: data.workDays,
    total_days: daysInMonth,
    summary: {
      available:    availability.filter(d => d.status === 'available').length,
      partial:      availability.filter(d => d.status === 'partial').length,
      occupied:     availability.filter(d => d.status === 'occupied').length,
      displacement: availability.filter(d => d.status === 'displacement').length,
      closed:       availability.filter(d => d.status === 'closed').length,
    },
    availability
  });
}));

// GET /api/query/availability/range?start_date=YYYY-MM-DD&end_date=YYYY-MM-DD
app.get('/api/query/availability/range', asyncHandler(async (req, res) => {
  await new Promise((resolve, reject) => requireApiKey(req, res, (err) => err ? reject(err) : resolve()));
  if (res.headersSent) return;

  const { start_date, end_date } = req.query;
  if (!start_date || !end_date) {
    return res.status(400).json({ error: 'Se requieren start_date y end_date en formato YYYY-MM-DD' });
  }
  const startDate = start_date;
  const endDate   = end_date;

  const data = await loadStudioData(startDate, endDate);
  const availability = [];
  const current = new Date(startDate);
  const last    = new Date(endDate);

  while (current <= last) {
    const dateStr = current.toISOString().split('T')[0];
    const dow = current.getDay() === 0 ? 7 : current.getDay();
    availability.push(calcDayAvailability({ dateStr, dow, ...data }));
    current.setDate(current.getDate() + 1);
  }

  res.json({
    start_date: startDate,
    end_date: endDate,
    studio_hours: { start: data.studioStart, end: data.studioEnd },
    work_days: data.workDays,
    summary: {
      available:    availability.filter(d => d.status === 'available').length,
      partial:      availability.filter(d => d.status === 'partial').length,
      occupied:     availability.filter(d => d.status === 'occupied').length,
      displacement: availability.filter(d => d.status === 'displacement').length,
      closed:       availability.filter(d => d.status === 'closed').length,
    },
    availability
  });
}));

// GET /api/query/availability/:date  (YYYY-MM-DD)
app.get('/api/query/availability/:date', asyncHandler(async (req, res) => {
  await new Promise((resolve, reject) => requireApiKey(req, res, (err) => err ? reject(err) : resolve()));
  if (res.headersSent) return;

  const dateStr = req.params.date;
  if (!/^\d{4}-\d{2}-\d{2}$/.test(dateStr)) {
    return res.status(400).json({ error: 'Formato de fecha inválido. Usa YYYY-MM-DD' });
  }

  const data = await loadStudioData(dateStr, dateStr);
  const d    = new Date(dateStr);
  const dow  = d.getDay() === 0 ? 7 : d.getDay();
  const day  = calcDayAvailability({ dateStr, dow, ...data });

  res.json({
    studio_hours: { start: data.studioStart, end: data.studioEnd },
    work_days: data.workDays,
    day
  });
}));

// GET /api/admin/staff-report — participation count per user (recording_sessions + reservations)
app.get('/api/admin/staff-report', asyncHandler(async (req, res) => {
  const user = await getAuthUser(req);
  if (!requireAdmin(user, res)) return;

  const year  = parseInt(req.query.year)  || new Date().getFullYear();
  const month = parseInt(req.query.month) || (new Date().getMonth() + 1);

  // Build user lookup by id and by name (normalized)
  const usersDb = await queryAll('SELECT id, name FROM users ORDER BY name ASC');
  const nameMap = {};      // id -> name
  const nameToId = {};     // normalized-name -> id
  for (const u of usersDb) {
    nameMap[u.id] = u.name;
    nameToId[u.name.toLowerCase().trim()] = u.id;
  }

  // Helper to get/init a user entry
  const ensureUser = (id, name) => {
    if (!map[id]) map[id] = { id, name: nameMap[id] || name, total: 0, dates: new Set(), entries: [] };
  };

  const map = {}; // key -> { id, name, total, dates, entries }

  // ── SOURCE 1: recording_sessions (staff_1_id…staff_4_id) ──
  const sessions = await queryAll(`
    SELECT rs.session_date, rs.start_time, rs.end_time,
           rs.staff_1_id, rs.staff_2_id, rs.staff_3_id, rs.staff_4_id,
           s.code as subject_code, s.name as subject_name,
           fa.teacher_name
    FROM recording_sessions rs
    JOIN filming_assignments fa ON fa.id = rs.assignment_id
    JOIN subjects s ON s.id = fa.subject_id
    WHERE (rs.status IS NULL OR rs.status != 'cancelled')
      AND (fa.status IS NULL OR fa.status != 'cancelled')
      AND EXTRACT(YEAR FROM rs.session_date) = ?
      AND EXTRACT(MONTH FROM rs.session_date) = ?
    ORDER BY rs.session_date ASC
  `, [year, month]);

  for (const s of sessions) {
    const dateStr = s.session_date
      ? (typeof s.session_date === 'string' ? s.session_date.slice(0, 10)
        : s.session_date.toISOString().slice(0, 10))
      : null;

    const startH = parseInt((s.start_time || '08:00').substring(0, 2), 10);
    const endH   = parseInt((s.end_time   || '10:00').substring(0, 2), 10);
    const isFullDay = startH < 13 && endH > 13;

    const slots = [
      { key: 'staff_1_id', turno: isFullDay ? 'mañana' : 'sesión' },
      { key: 'staff_2_id', turno: isFullDay ? 'mañana' : 'sesión' },
      { key: 'staff_3_id', turno: 'tarde' },
      { key: 'staff_4_id', turno: 'tarde' },
    ];

    for (const { key, turno } of slots) {
      const uid = s[key];
      if (!uid) continue;
      ensureUser(uid, `Usuario #${uid}`);
      map[uid].total += 1;
      if (dateStr) map[uid].dates.add(dateStr);
      map[uid].entries.push({
        date: dateStr, turno, source: 'sesión',
        subject: s.subject_code ? `${s.subject_code} - ${s.subject_name}` : (s.subject_name || null),
        teacher: s.teacher_name || null
      });
    }
  }

  // ── SOURCE 2: reservations.attendees (Full Day attendance list) ──
  const reservations = await queryAll(`
    SELECT date, start_time, end_time, reason, attendees
    FROM reservations
    WHERE attendees IS NOT NULL AND attendees != '' AND attendees != '[]'
      AND EXTRACT(YEAR FROM date) = ?
      AND EXTRACT(MONTH FROM date) = ?
    ORDER BY date ASC
  `, [year, month]);

  for (const r of reservations) {
    const dateStr = r.date
      ? (typeof r.date === 'string' ? r.date.slice(0, 10) : r.date.toISOString().slice(0, 10))
      : null;

    // Precise shift detection using 12:00 as the boundary:
    //   - isMorning : reservation STARTS before 12:00  (covers morning block 08:00–12:00)
    //   - isAfternoon: reservation ENDS   after  12:00  (covers afternoon block 12:00–20:00+)
    const startMin = parseInt((r.start_time || '08:00').substring(0, 2), 10) * 60
                   + parseInt((r.start_time || '08:00').substring(3, 5), 10);
    const endMin   = parseInt((r.end_time   || '17:00').substring(0, 2), 10) * 60
                   + parseInt((r.end_time   || '17:00').substring(3, 5), 10);
    const NOON = 12 * 60; // 720 minutes

    const isMorning   = startMin < NOON;   // starts before noon → has morning content
    const isAfternoon = endMin   > NOON;   // ends after noon → has afternoon content

    let names = [];
    try { names = typeof r.attendees === 'string' ? JSON.parse(r.attendees) : r.attendees; } catch(e) {}
    if (!Array.isArray(names)) names = [];

    for (const rawName of names) {
      if (!rawName || !rawName.trim()) continue;
      const normalized = rawName.toLowerCase().trim();
      const uid = nameToId[normalized] || `name:${rawName.trim()}`;
      const displayName = nameMap[uid] || rawName.trim();

      ensureUser(uid, displayName);
      if (dateStr) map[uid].dates.add(dateStr);

      const label = r.reason || (isMorning && isAfternoon ? 'Día completo' : isMorning ? 'Mañana' : 'Tarde');
      const src   = isMorning && isAfternoon ? 'full-day' : 'reserva';

      if (isMorning) {
        map[uid].total += 1;
        map[uid].entries.push({ date: dateStr, turno: 'mañana', source: src, subject: label, teacher: null });
      }
      if (isAfternoon) {
        map[uid].total += 1;
        map[uid].entries.push({ date: dateStr, turno: 'tarde', source: src, subject: label, teacher: null });
      }
      // Edge case: reservation entirely before or at noon (e.g. 08:00–12:00 exactly)
      if (!isMorning && !isAfternoon) {
        map[uid].total += 1;
        map[uid].entries.push({ date: dateStr, turno: 'mañana', source: 'reserva', subject: r.reason || 'Reserva', teacher: null });
      }
    }
  }

  // Serialize and sort descending by total
  const report = Object.values(map)
    .filter(u => u.total > 0)
    .map(u => ({
      id: u.id,
      name: u.name,
      total: u.total,
      days: u.dates.size,
      dates: Array.from(u.dates).sort(),
      entries: u.entries.sort((a, b) => (a.date || '').localeCompare(b.date || ''))
    }))
    .sort((a, b) => b.total - a.total || a.name.localeCompare(b.name));

  res.json(report);
}));

// Error handler
app.use((err, req, res, next) => {
  console.error('[API ERROR]', err.message);
  res.status(500).json({ error: 'Error interno del servidor', detail: err.message });
});

// For Vercel, simply export the Express app
module.exports = app;
