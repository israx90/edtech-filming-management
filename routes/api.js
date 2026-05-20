const express = require('express');
const router = express.Router();
const { queryAll, queryOne, execute, saveDb } = require('../db/database');

// ========== AUTHENTICATION ==========

router.post('/login', async async (req, res) => {
    const { username, password } = req.body;
    const user = await queryOne('SELECT * FROM users WHERE username = ? AND password = ?', [username, password]);
    if (!user) return res.status(401).json({ error: 'Credenciales inválidas' });
    
    const token = Math.random().toString(36).substring(2) + Date.now().toString(36);
    await execute('INSERT INTO user_sessions (token, user_id) VALUES (?, ?)', [token, user.id]);
    
    res.json({ token, user: { id: user.id, username: user.username, role: user.role, name: user.name } });
});

router.post('/logout', async async (req, res) => {
    const token = req.headers.authorization?.split(' ')[1];
    if (token) await execute('DELETE FROM user_sessions WHERE token = ?', [token]);
    res.json({ success: true });
});

// Middleware for Auth
router.use(async async (req, res, next) => {
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) return res.status(401).json({ error: 'No autorizado' });
    const session = await queryOne('SELECT * FROM user_sessions WHERE token = ?', [token]);
    if (!session) return res.status(401).json({ error: 'No autorizado' });
    req.user = await queryOne('SELECT id, username, role, name FROM users WHERE id = ?', [session.user_id]);
    if (!req.user) return res.status(401).json({ error: 'No autorizado' });
    next();
});

router.get('/me', async async (req, res) => {
    res.json(req.user);
});

// Role helpers
const isAdmin = async async (req, res, next) => {
    if (req.user.role !== 'admin') return res.status(403).json({ error: 'Solo administradores' });
    next();
};
const canEdit = async async (req, res, next) => {
    if (!['admin', 'post_productor'].includes(req.user.role)) return res.status(403).json({ error: 'Sin permiso de edición' });
    next();
};

// Activity logger helper
async function await logAction(user, action, entity_type = null, entity_id = null, details = null) {
    try {
        await execute('INSERT INTO activity_log (user_id, user_name, action, entity_type, entity_id, details) VALUES (?, ?, ?, ?, ?, ?)',
            [user.id, user.name, action, entity_type, entity_id, details]);
    } catch(e) { /* non-critical */ }
}

// ========== RESERVATIONS ==========

router.get('/reservations', async async (req, res) => {
    const { month, year } = req.query;
    let q = `SELECT r.*, u.name as user_name FROM reservations r JOIN users u ON u.id = r.user_id`;
    const params = [];
    if (month && year) {
        const m = String(month).padStart(2, '0');
        q += ` WHERE r.date LIKE ?`;
        params.push(`${year}-${m}-%`);
    }
    q += ' ORDER BY r.date ASC, r.start_time ASC';
    res.json(await queryAll(q, params));
});

router.post('/reservations', async async (req, res) => {
    const { start_date, end_date, start_time, end_time, reason } = req.body;
    if (!start_date || !end_date || !start_time || !end_time) return res.status(400).json({ error: 'Campos requeridos' });
    
    let currentDate = new Date(start_date + 'T00:00:00');
    const lastDate = new Date(end_date + 'T00:00:00');
    
    if (currentDate > lastDate) return res.status(400).json({ error: 'Rango de fechas inválido' });
    
    while (currentDate <= lastDate) {
        const dStr = currentDate.toISOString().split('T')[0];
        await execute(`INSERT INTO reservations (user_id, date, start_time, end_time, reason) VALUES (?, ?, ?, ?, ?)`,
            [req.user.id, dStr, start_time, end_time, reason || 'Reserva']);
        currentDate.setDate(currentDate.getDate() + 1);
    }
        
    res.status(201).json({ success: true });
});

router.delete('/reservations/:id', async async (req, res) => {
    const resv = await queryOne('SELECT * FROM reservations WHERE id = ?', [+req.params.id]);
    if (!resv) return res.status(404).json({ error: 'No encontrada' });
    if (req.user.role !== 'admin' && req.user.role !== 'post_productor' && resv.user_id !== req.user.id) return res.status(403).json({ error: 'No tienes permiso' });
    
    await execute('DELETE FROM reservations WHERE id = ?', [+req.params.id]);
    res.json({ success: true });
});

// ========== SEMESTERS ==========

router.get('/semesters', async async (req, res) => {
    res.json(await queryAll('SELECT * FROM semesters ORDER BY created_at DESC'));
});

router.post('/semesters', async async (req, res) => {
    const { name } = req.body;
    if (!name) return res.status(400).json({ error: 'Nombre requerido' });
    try {
        await execute('UPDATE semesters SET is_active = 0');
        await execute('INSERT INTO semesters (name, is_active) VALUES (?, 1)', [name]);
        const semester = await queryOne('SELECT * FROM semesters WHERE name = ?', [name]);
        res.status(201).json(semester);
    } catch (err) {
        res.status(409).json({ error: 'Ya existe ese semestre' });
    }
});

router.put('/semesters/:id/activate', async async (req, res) => {
    await execute('UPDATE semesters SET is_active = 0');
    await execute('UPDATE semesters SET is_active = 1 WHERE id = ?', [+req.params.id]);
    res.json({ success: true });
});

router.delete('/semesters/:id', async async (req, res) => {
    await execute('DELETE FROM semesters WHERE id = ?', [+req.params.id]);
    res.json({ success: true });
});

// ========== SUBJECTS ==========

router.get('/subjects', async async (req, res) => {
    let semId = req.query.semester_id;
    if (!semId) {
        const active = await queryOne('SELECT id FROM semesters WHERE is_active = 1');
        if (!active) return res.json([]);
        semId = active.id;
    }
    const subjects = await queryAll(`
        SELECT s.*, fa.id as assignment_id, fa.status as assignment_status, fa.last_hito_reached,
               fa.teacher_name, fa.script_status, fa.drive_link
        FROM subjects s
        LEFT JOIN filming_assignments fa ON fa.subject_id = s.id AND fa.status != 'cancelled'
        WHERE s.semester_id = ?
        ORDER BY s.code ASC
    `, [+semId]);
    res.json(subjects);
});

function extractCodeAndName(str) {
    if (!str) return { code: null, name: null };
    const s = str.trim();
    const parts = s.split(' ');
    if (parts.length > 1 && parts[0].includes('-')) {
        return { code: parts[0], name: parts.slice(1).join(' ') };
    }
    return { code: 'EXT', name: s };
}

router.post('/subjects', async async (req, res) => {
    let { code, name, semester_id } = req.body;
    if (!name && code) { name = code; code = null; }
    
    if (!code) {
        const extracted = extractCodeAndName(name);
        code = extracted.code;
        name = extracted.name;
    }
    
    if (!name || !semester_id) return res.status(400).json({ error: 'Campos requeridos' });
    await execute('INSERT INTO subjects (code, name, semester_id) VALUES (?, ?, ?)', [code, name, +semester_id]);
    const subject = await queryOne('SELECT * FROM subjects ORDER BY id DESC LIMIT 1');
    res.status(201).json(subject);
});

router.post('/subjects/bulk', async async (req, res) => {
    const { subjects, semester_id } = req.body;
    if (!subjects || !semester_id) return res.status(400).json({ error: 'Datos requeridos' });
    const results = [];
    for (const item of subjects) {
        try {
            let code = item.code;
            let name = item.name;
            if (!code) {
                const ext = extractCodeAndName(name);
                code = ext.code;
                name = ext.name;
            }
            await execute('INSERT INTO subjects (code, name, semester_id) VALUES (?, ?, ?)', [code, name, +semester_id]);
            results.push({ success: true, ...item });
        } catch (e) {
            results.push({ error: e.message, ...item });
        }
    }
    res.status(201).json(results);
});

router.put('/subjects/:id', async async (req, res) => {
    const { code, name, completed } = req.body;
    if (code !== undefined) await execute('UPDATE subjects SET code = ? WHERE id = ?', [code, +req.params.id]);
    if (name !== undefined) await execute('UPDATE subjects SET name = ? WHERE id = ?', [name, +req.params.id]);
    if (completed !== undefined) await execute('UPDATE subjects SET completed = ? WHERE id = ?', [completed ? 1 : 0, +req.params.id]);
    res.json(await queryOne('SELECT * FROM subjects WHERE id = ?', [+req.params.id]));
});

router.delete('/subjects/:id', async async (req, res) => {
    await execute('DELETE FROM subjects WHERE id = ?', [+req.params.id]);
    res.json({ success: true });
});

// ========== FILMING ASSIGNMENTS ==========

router.get('/assignments', async async (req, res) => {
    res.json(await queryAll(`
        SELECT fa.*, s.code as subject_code, s.name as subject_name
        FROM filming_assignments fa
        JOIN subjects s ON s.id = fa.subject_id
        JOIN semesters sem ON sem.id = s.semester_id AND sem.is_active = 1
        ORDER BY fa.created_at DESC
    `));
});

router.get('/assignments/:id', async async (req, res) => {
    const a = await queryOne(`
        SELECT fa.*, s.code as subject_code, s.name as subject_name
        FROM filming_assignments fa JOIN subjects s ON s.id = fa.subject_id
        WHERE fa.id = ?
    `, [+req.params.id]);
    if (!a) return res.status(404).json({ error: 'No encontrada' });
    a.sessions = await queryAll(`
        SELECT rs.*, u1.name as staff_1_name, u2.name as staff_2_name 
        FROM recording_sessions rs 
        LEFT JOIN users u1 ON rs.staff_1_id = u1.id 
        LEFT JOIN users u2 ON rs.staff_2_id = u2.id 
        WHERE rs.assignment_id = ? ORDER BY rs.session_date ASC
    `, [+req.params.id]);
    res.json(a);
});

router.post('/assignments', async async (req, res) => {
    const { teacher_name, phone, subject_id, drive_link, script_status, session } = req.body;
    if (!teacher_name || !subject_id) return res.status(400).json({ error: 'Docente y materia requeridos' });

    await execute(`INSERT INTO filming_assignments (teacher_name, phone, subject_id, drive_link, script_status) VALUES (?, ?, ?, ?, ?)`,
        [teacher_name, phone || null, +subject_id, drive_link || null, script_status || 'pending']);

    const assignment = await queryOne('SELECT * FROM filming_assignments ORDER BY id DESC LIMIT 1');

    if (session && session.session_date && session.start_time && session.end_time) {
        await execute(`INSERT INTO recording_sessions (assignment_id, session_date, start_time, end_time, hito_reached, notes) VALUES (?, ?, ?, ?, ?, ?)`,
            [assignment.id, session.session_date, session.start_time, session.end_time, session.hito_reached || null, session.notes || null]);
        if (session.hito_reached) {
            await execute('UPDATE filming_assignments SET last_hito_reached = ? WHERE id = ?', [session.hito_reached, assignment.id]);
        }
    }

    const result = await queryOne(`SELECT fa.*, s.code as subject_code, s.name as subject_name FROM filming_assignments fa JOIN subjects s ON s.id = fa.subject_id WHERE fa.id = ?`, [assignment.id]);
    res.status(201).json(result);
});

router.put('/assignments/:id', async async (req, res) => {
    const { teacher_name, phone, drive_link, script_status, status } = req.body;
    const id = +req.params.id;
    if (teacher_name !== undefined) await execute('UPDATE filming_assignments SET teacher_name = ? WHERE id = ?', [teacher_name, id]);
    if (phone !== undefined) await execute('UPDATE filming_assignments SET phone = ? WHERE id = ?', [phone, id]);
    if (drive_link !== undefined) await execute('UPDATE filming_assignments SET drive_link = ? WHERE id = ?', [drive_link, id]);
    if (script_status !== undefined) await execute('UPDATE filming_assignments SET script_status = ? WHERE id = ?', [script_status, id]);
    if (status !== undefined) {
        await execute('UPDATE filming_assignments SET status = ? WHERE id = ?', [status, id]);
        if (status === 'completed') {
            const a = await queryOne('SELECT subject_id FROM filming_assignments WHERE id = ?', [id]);
            if (a) await execute('UPDATE subjects SET completed = 1 WHERE id = ?', [a.subject_id]);
        }
    }
    res.json(await queryOne(`SELECT fa.*, s.code as subject_code, s.name as subject_name FROM filming_assignments fa JOIN subjects s ON s.id = fa.subject_id WHERE fa.id = ?`, [id]));
});

router.delete('/assignments/:id', async async (req, res) => {
    await execute('DELETE FROM filming_assignments WHERE id = ?', [+req.params.id]);
    res.json({ success: true });
});

// ========== RECORDING SESSIONS ==========

router.get('/sessions', async async (req, res) => {
    const { month, year } = req.query;
    let q = `SELECT rs.*, fa.teacher_name, fa.phone, fa.subject_id, fa.drive_link, fa.script_status, fa.status as assignment_status, fa.id as assignment_id,
             s.code as subject_code, s.name as subject_name,
             u1.name as staff_1_name, u2.name as staff_2_name
             FROM recording_sessions rs
             JOIN filming_assignments fa ON fa.id = rs.assignment_id
             JOIN subjects s ON s.id = fa.subject_id
             JOIN semesters sem ON sem.id = s.semester_id AND sem.is_active = 1
             LEFT JOIN users u1 ON rs.staff_1_id = u1.id
             LEFT JOIN users u2 ON rs.staff_2_id = u2.id`;
    const params = [];
    if (month && year) {
        const m = String(month).padStart(2, '0');
        q += ` WHERE rs.session_date LIKE ?`;
        params.push(`${year}-${m}-%`);
    }
    q += ' ORDER BY rs.session_date ASC, rs.start_time ASC';
    res.json(await queryAll(q, params));
});

router.post('/sessions', async async (req, res) => {
    const { assignment_id, session_date, start_time, end_time, hito_reached, notes, staff_1_id, staff_2_id } = req.body;
    if (!assignment_id || !session_date || !start_time || !end_time) return res.status(400).json({ error: 'Campos requeridos' });

    await execute(`INSERT INTO recording_sessions (assignment_id, session_date, start_time, end_time, hito_reached, notes, staff_1_id, staff_2_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
        [+assignment_id, session_date, start_time, end_time, hito_reached || null, notes || null, staff_1_id || null, staff_2_id || null]);

    if (hito_reached) {
        await execute('UPDATE filming_assignments SET last_hito_reached = ? WHERE id = ?', [hito_reached, +assignment_id]);
        if (hito_reached === 'semanas') {
            await execute('UPDATE filming_assignments SET status = ? WHERE id = ?', ['completed', +assignment_id]);
            const a = await queryOne('SELECT subject_id FROM filming_assignments WHERE id = ?', [+assignment_id]);
            if (a) await execute('UPDATE subjects SET completed = 1 WHERE id = ?', [a.subject_id]);
        }
    }

    const session = await queryOne('SELECT * FROM recording_sessions ORDER BY id DESC LIMIT 1');
    res.status(201).json(session);
});

router.put('/sessions/:id', async async (req, res) => {
    const id = +req.params.id;
    const { session_date, start_time, end_time, hito_reached, notes, staff_1_id, staff_2_id } = req.body;
    if (session_date !== undefined) await execute('UPDATE recording_sessions SET session_date = ? WHERE id = ?', [session_date, id]);
    if (start_time !== undefined) await execute('UPDATE recording_sessions SET start_time = ? WHERE id = ?', [start_time, id]);
    if (end_time !== undefined) await execute('UPDATE recording_sessions SET end_time = ? WHERE id = ?', [end_time, id]);
    if (hito_reached !== undefined) await execute('UPDATE recording_sessions SET hito_reached = ? WHERE id = ?', [hito_reached, id]);
    if (notes !== undefined) await execute('UPDATE recording_sessions SET notes = ? WHERE id = ?', [notes, id]);
    if (staff_1_id !== undefined) await execute('UPDATE recording_sessions SET staff_1_id = ? WHERE id = ?', [staff_1_id || null, id]);
    if (staff_2_id !== undefined) await execute('UPDATE recording_sessions SET staff_2_id = ? WHERE id = ?', [staff_2_id || null, id]);

    if (hito_reached) {
        const s = await queryOne('SELECT assignment_id FROM recording_sessions WHERE id = ?', [id]);
        if (s) await execute('UPDATE filming_assignments SET last_hito_reached = ? WHERE id = ?', [hito_reached, s.assignment_id]);
    }
    res.json(await queryOne('SELECT * FROM recording_sessions WHERE id = ?', [id]));
});

router.delete('/sessions/:id', async async (req, res) => {
    await execute('DELETE FROM recording_sessions WHERE id = ?', [+req.params.id]);
    res.json({ success: true });
});

// ========== CLOSED WEEKS ==========

router.get('/closed-weeks', async async (req, res) => {
    res.json(await queryAll('SELECT * FROM closed_weeks ORDER BY week_start DESC'));
});

router.post('/closed-weeks', async async (req, res) => {
    const { week_start, reason } = req.body;
    if (!week_start) return res.status(400).json({ error: 'Fecha requerida' });
    try {
        await execute('INSERT INTO closed_weeks (week_start, reason) VALUES (?, ?)', [week_start, reason || 'Estudio cerrado']);
        res.status(201).json(await queryOne('SELECT * FROM closed_weeks ORDER BY id DESC LIMIT 1'));
    } catch (e) {
        res.status(409).json({ error: 'Semana ya cerrada' });
    }
});

router.delete('/closed-weeks/:id', async async (req, res) => {
    await execute('DELETE FROM closed_weeks WHERE id = ?', [+req.params.id]);
    res.json({ success: true });
});

// ========== DASHBOARD ==========

router.get('/dashboard', async async (req, res) => {
    const sem = await queryOne('SELECT * FROM semesters WHERE is_active = 1');
    if (!sem) return res.json({ semester: null, totalSubjects: 0, completedSubjects: 0, pendingSubjects: 0, inProgressSubjects: 0, nextSession: null, recentSessions: [], inProgressList: [] });

    const total = await queryOne('SELECT COUNT(*) as c FROM subjects WHERE semester_id = ?', [sem.id]).c;
    const completed = await queryOne('SELECT COUNT(*) as c FROM subjects WHERE semester_id = ? AND completed = 1', [sem.id]).c;
    const inProg = await queryOne(`SELECT COUNT(DISTINCT fa.subject_id) as c FROM filming_assignments fa JOIN subjects s ON s.id = fa.subject_id WHERE s.semester_id = ? AND fa.status = 'in_progress'`, [sem.id]).c;
    const pending = Math.max(0, total - completed - inProg);

    const today = new Date().toISOString().split('T')[0];
    const nextSession = await queryOne(`SELECT rs.*, fa.teacher_name, fa.phone, s.code as subject_code, s.name as subject_name
        FROM recording_sessions rs JOIN filming_assignments fa ON fa.id = rs.assignment_id JOIN subjects s ON s.id = fa.subject_id
        WHERE rs.session_date >= ? AND fa.status != 'cancelled' ORDER BY rs.session_date ASC, rs.start_time ASC LIMIT 1`, [today]);

    const recentSessions = await queryAll(`SELECT rs.*, fa.teacher_name, s.code as subject_code, s.name as subject_name, fa.status as assignment_status
        FROM recording_sessions rs JOIN filming_assignments fa ON fa.id = rs.assignment_id JOIN subjects s ON s.id = fa.subject_id
        JOIN semesters sem ON sem.id = s.semester_id AND sem.is_active = 1 ORDER BY rs.session_date DESC LIMIT 5`);

    const inProgressList = await queryAll(`SELECT fa.*, s.code as subject_code, s.name as subject_name
        FROM filming_assignments fa JOIN subjects s ON s.id = fa.subject_id WHERE s.semester_id = ? AND fa.status = 'in_progress' ORDER BY fa.created_at DESC`, [sem.id]);

    res.json({ semester: sem, totalSubjects: total, completedSubjects: completed, pendingSubjects: pending, inProgressSubjects: inProg, inProgressList, nextSession, recentSessions });
});

// ========== AVAILABILITY ==========

router.get('/availability/:date', async async (req, res) => {
    const date = req.params.date;
    const d = new Date(date + 'T12:00:00');
    const dow = d.getDay();
    const monOff = dow === 0 ? -6 : 1 - dow;
    const mon = new Date(d); mon.setDate(mon.getDate() + monOff);
    const monStr = mon.toISOString().split('T')[0];

    const closed = await queryOne('SELECT * FROM closed_weeks WHERE week_start = ?', [monStr]);
    if (closed) return res.json({ closed: true, reason: closed.reason, slots: [] });

    const startH = parseInt((await queryOne("SELECT value FROM settings WHERE key = 'studio_start_time'")?.value || '08:00').split(':')[0]);
    const endH = parseInt((await queryOne("SELECT value FROM settings WHERE key = 'studio_end_time'")?.value || '18:00').split(':')[0]);

    const existing = await queryAll(`SELECT rs.start_time, rs.end_time, fa.teacher_name, s.code as subject_code
        FROM recording_sessions rs JOIN filming_assignments fa ON fa.id = rs.assignment_id JOIN subjects s ON s.id = fa.subject_id
        WHERE rs.session_date = ? ORDER BY rs.start_time ASC`, [date]);

    const slots = [];
    for (let h = startH; h < endH; h++) {
        const ss = `${String(h).padStart(2,'0')}:00`, se = `${String(h+1).padStart(2,'0')}:00`;
        const occ = existing.find(s => (ss >= s.start_time && ss < s.end_time) || (se > s.start_time && se <= s.end_time));
        slots.push({ start: ss, end: se, available: !occ, session: occ || null });
    }
    res.json({ closed: false, slots, existingSessions: existing });
});

// ========== PENDING TEACHERS ==========

router.get('/pending-teachers', async async (req, res) => {
    const showResolved = req.query.resolved === '1';
    const q = showResolved
        ? `SELECT pt.*, u.name as added_by_name FROM pending_teachers pt LEFT JOIN users u ON u.id = pt.added_by_user_id ORDER BY pt.resolved ASC, pt.created_at DESC`
        : `SELECT pt.*, u.name as added_by_name FROM pending_teachers pt LEFT JOIN users u ON u.id = pt.added_by_user_id WHERE pt.resolved = 0 ORDER BY pt.created_at DESC`;
    res.json(await queryAll(q));
});

router.post('/pending-teachers', async async (req, res) => {
    let { name, subject_code, subject, phone, sede, is_external, notes } = req.body;
    if (!name || !subject) return res.status(400).json({ error: 'Nombre y materia son requeridos' });
    
    if (!subject_code) {
        const ext = extractCodeAndName(subject);
        subject_code = ext.code;
        subject = ext.name;
    }

    await execute(
        'INSERT INTO pending_teachers (name, subject_code, subject, phone, sede, is_external, notes, added_by_user_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
        [name, subject_code, subject, phone || null, sede || 'La Paz', is_external ? 1 : 0, notes || null, req.user.id]
    );
    const teacher = await queryOne(`SELECT pt.*, u.name as added_by_name FROM pending_teachers pt LEFT JOIN users u ON u.id = pt.added_by_user_id ORDER BY pt.id DESC LIMIT 1`);
    await logAction(req.user, `Agregó docente pendiente: ${name}`, 'pending_teacher', teacher.id, `${subject_code || ''} ${subject}`);
    res.status(201).json(teacher);
});

router.put('/pending-teachers/:id', async async (req, res) => {
    const id = +req.params.id;
    let { name, subject_code, subject, phone, sede, is_external, notes, resolved } = req.body;
    
    if (subject !== undefined && subject_code === undefined) {
        const ext = extractCodeAndName(subject);
        subject_code = ext.code;
        subject = ext.name;
    }
    
    if (name !== undefined) await execute('UPDATE pending_teachers SET name = ? WHERE id = ?', [name, id]);
    if (subject_code !== undefined) await execute('UPDATE pending_teachers SET subject_code = ? WHERE id = ?', [subject_code, id]);
    if (subject !== undefined) await execute('UPDATE pending_teachers SET subject = ? WHERE id = ?', [subject, id]);
    if (phone !== undefined) await execute('UPDATE pending_teachers SET phone = ? WHERE id = ?', [phone, id]);
    if (sede !== undefined) await execute('UPDATE pending_teachers SET sede = ? WHERE id = ?', [sede, id]);
    if (is_external !== undefined) await execute('UPDATE pending_teachers SET is_external = ? WHERE id = ?', [is_external ? 1 : 0, id]);
    if (notes !== undefined) await execute('UPDATE pending_teachers SET notes = ? WHERE id = ?', [notes, id]);
    if (resolved !== undefined) {
        await execute('UPDATE pending_teachers SET resolved = ? WHERE id = ?', [resolved ? 1 : 0, id]);
        await logAction(req.user, resolved ? `Marcó docente como resuelto` : `Reabrió docente`, 'pending_teacher', id);
    } else {
        await logAction(req.user, `Editó docente pendiente`, 'pending_teacher', id, name || '');
    }
    res.json(await queryOne('SELECT pt.*, u.name as added_by_name FROM pending_teachers pt LEFT JOIN users u ON u.id = pt.added_by_user_id WHERE pt.id = ?', [id]));
});

router.delete('/pending-teachers/:id', async async (req, res) => {
    const t = await queryOne('SELECT * FROM pending_teachers WHERE id = ?', [+req.params.id]);
    if (t) await logAction(req.user, `Eliminó docente pendiente: ${t.name}`, 'pending_teacher', t.id);
    await execute('DELETE FROM pending_teachers WHERE id = ?', [+req.params.id]);
    res.json({ success: true });
});

// Get staff (post_productors and admins) for dropdowns
router.get('/staff', async async (req, res) => {
    const staff = await queryAll('SELECT id, name, role FROM users WHERE role IN ("post_productor", "admin") ORDER BY name ASC');
    res.json(staff);
});

// ========== USER MANAGEMENT (admin only) ==========

router.get('/users', isAdmin, async async (req, res) => {
    res.json(await queryAll('SELECT id, username, role, name, created_at FROM users ORDER BY created_at ASC'));
});

router.post('/users', isAdmin, async async (req, res) => {
    const { username, password, role, name } = req.body;
    if (!username || !password || !role || !name) return res.status(400).json({ error: 'Todos los campos son requeridos' });
    if (!['admin', 'post_productor', 'academica'].includes(role)) return res.status(400).json({ error: 'Rol inválido' });
    try {
        await execute('INSERT INTO users (username, password, role, name) VALUES (?, ?, ?, ?)', [username, password, role, name]);
        const user = await queryOne('SELECT id, username, role, name, created_at FROM users WHERE username = ?', [username]);
        await logAction(req.user, `Creó usuario: ${name} (${role})`, 'user', user.id);
        res.status(201).json(user);
    } catch(e) {
        res.status(409).json({ error: 'El nombre de usuario ya existe' });
    }
});

router.put('/users/:id', isAdmin, async async (req, res) => {
    const id = +req.params.id;
    const { username, password, role, name } = req.body;
    if (username !== undefined) await execute('UPDATE users SET username = ? WHERE id = ?', [username, id]);
    if (password !== undefined && password !== '') await execute('UPDATE users SET password = ? WHERE id = ?', [password, id]);
    if (role !== undefined) await execute('UPDATE users SET role = ? WHERE id = ?', [role, id]);
    if (name !== undefined) await execute('UPDATE users SET name = ? WHERE id = ?', [name, id]);
    await logAction(req.user, `Editó usuario #${id}`, 'user', id);
    res.json(await queryOne('SELECT id, username, role, name, created_at FROM users WHERE id = ?', [id]));
});

router.delete('/users/:id', isAdmin, async async (req, res) => {
    if (+req.params.id === req.user.id) return res.status(400).json({ error: 'No puedes eliminarte a ti mismo' });
    const u = await queryOne('SELECT * FROM users WHERE id = ?', [+req.params.id]);
    if (u) await logAction(req.user, `Eliminó usuario: ${u.name}`, 'user', u.id);
    await execute('DELETE FROM users WHERE id = ?', [+req.params.id]);
    res.json({ success: true });
});

// ========== ACTIVITY LOG ==========

router.get('/activity-log', isAdmin, async async (req, res) => {
    const limit = parseInt(req.query.limit) || 50;
    res.json(await queryAll(`SELECT * FROM activity_log ORDER BY created_at DESC LIMIT ?`, [limit]));
});

// ========== GLOBAL SUBJECTS ==========

router.get('/global-subjects', async async (req, res) => {
    const q = req.query.q ? `%${req.query.q}%` : null;
    if (q) {
        return res.json(await queryAll('SELECT * FROM global_subjects WHERE code LIKE ? OR name LIKE ? ORDER BY code ASC LIMIT 50', [q, q]));
    }
    res.json(await queryAll('SELECT * FROM global_subjects ORDER BY code ASC'));
});

router.post('/global-subjects', isAdmin, async async (req, res) => {
    const { code, name, career } = req.body;
    if (!code || !name) return res.status(400).json({ error: 'Código y nombre requeridos' });
    try {
        await execute('INSERT INTO global_subjects (code, name, career) VALUES (?, ?, ?)', [code, name, career || null]);
        const gs = await queryOne('SELECT * FROM global_subjects ORDER BY id DESC LIMIT 1');
        await logAction(req.user, `Agregó materia global: ${code} - ${name}`, 'global_subject', gs.id);
        res.status(201).json(gs);
    } catch(e) {
        res.status(409).json({ error: 'Esa materia ya existe' });
    }
});

router.post('/global-subjects/bulk', isAdmin, async async (req, res) => {
    const { subjects } = req.body;
    if (!subjects || !Array.isArray(subjects)) return res.status(400).json({ error: 'Lista requerida' });
    let inserted = 0, skipped = 0;
    for (const s of subjects) {
        try {
            await execute('INSERT OR IGNORE INTO global_subjects (code, name, career) VALUES (?, ?, ?)', [s.code, s.name, s.career || null]);
            inserted++;
        } catch(e) { skipped++; }
    }
    await logAction(req.user, `Importó ${inserted} materias globales`, 'global_subject');
    res.json({ inserted, skipped });
});

router.delete('/global-subjects/:id', isAdmin, async async (req, res) => {
    await execute('DELETE FROM global_subjects WHERE id = ?', [+req.params.id]);
    res.json({ success: true });
});

module.exports = router;
