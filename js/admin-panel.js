// ================================================
// Admin Panel — User Management, Global Subjects, Activity Log
// ================================================

const AdminPanel = {
    users: [],
    globalSubjects: [],
    holidays: [],
    holidaysFilter: 'all',
    log: [],
    activeTab: 'users',

    init() {
        document.getElementById('admin-tab-users')?.addEventListener('click', () => this.switchTab('users'));
        document.getElementById('admin-tab-subjects')?.addEventListener('click', () => this.switchTab('subjects'));
        document.getElementById('admin-tab-holidays')?.addEventListener('click', () => this.switchTab('holidays'));
        document.getElementById('admin-tab-log')?.addEventListener('click', () => this.switchTab('log'));

        // User management
        document.getElementById('btn-save-new-user')?.addEventListener('click', () => this.createUser());
        document.getElementById('btn-copy-whatsapp')?.addEventListener('click', () => this.copyToWhatsApp());

        // Auto-generate username from full name
        document.getElementById('new-user-name')?.addEventListener('input', (e) => {
            const usernameField = document.getElementById('new-user-username');
            // Only auto-fill if user hasn't manually edited the username field
            if (!usernameField.dataset.manuallyEdited) {
                usernameField.value = this.generateUsername(e.target.value);
            }
            // Hide success box if typing new user
            document.getElementById('new-user-success-box').style.display = 'none';
        });
        document.getElementById('new-user-username')?.addEventListener('input', function() {
            this.dataset.manuallyEdited = this.value ? 'yes' : '';
        });

        // Global subjects
        document.getElementById('btn-add-global-subject')?.addEventListener('click', () => this.addGlobalSubject());
        document.getElementById('btn-import-global-subjects')?.addEventListener('click', () => this.importBulkSubjects());

        // Holidays
        document.getElementById('btn-add-holiday')?.addEventListener('click', () => this.addHoliday());
        // Allow pressing Enter in holiday inputs
        ['holiday-date-key', 'holiday-name'].forEach(id => {
            document.getElementById(id)?.addEventListener('keydown', (e) => { if (e.key === 'Enter') this.addHoliday(); });
        });
    },

    // Generate a username from a full name: "Edson Israel Llanque" → "eillanque"
    generateUsername(fullName) {
        const parts = fullName.trim().normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase().split(/\s+/).filter(Boolean);
        if (parts.length === 0) return '';
        if (parts.length === 1) return parts[0];
        // First letter of each word except last, then full last word
        const initials = parts.slice(0, -1).map(p => p.charAt(0)).join('');
        return initials + parts[parts.length - 1];
    },

    async refresh() {
        if (App.user?.role !== 'admin') return;
        await this.loadTab(this.activeTab);
    },

    switchTab(tab) {
        this.activeTab = tab;
        document.querySelectorAll('.admin-tab-btn').forEach(b => b.classList.remove('active'));
        document.getElementById(`admin-tab-${tab}`)?.classList.add('active');
        document.querySelectorAll('.admin-tab-panel').forEach(p => p.style.display = 'none');
        document.getElementById(`admin-panel-${tab}`)?.style.display && (document.getElementById(`admin-panel-${tab}`).style.display = '');
        document.querySelectorAll('.admin-tab-panel').forEach(p => p.classList.remove('active'));
        document.getElementById(`admin-panel-${tab}`)?.classList.add('active');
        this.loadTab(tab);
    },

    async loadTab(tab) {
        if (tab === 'users') await this.loadUsers();
        if (tab === 'subjects') await this.loadGlobalSubjects();
        if (tab === 'holidays') await this.loadHolidays();
        if (tab === 'log') await this.loadLog();
    },

    // ---- USERS ----
    async loadUsers() {
        this.users = await API.get('/users');
        this.renderUsers();
    },

    renderUsers() {
        const list = document.getElementById('admin-users-list');
        if (!list) return;
        const roleLabel = { admin: 'Admin', post_productor: 'Post-Producción', academica: 'Académica' };
        const roleClass = { admin: 'role-admin', post_productor: 'role-postprod', academica: 'role-academica' };

        list.innerHTML = this.users.map(u => `
            <div class="admin-user-row" data-id="${u.id}">
                <div class="admin-user-avatar">${u.name.charAt(0).toUpperCase()}</div>
                <div class="admin-user-info">
                    <div class="admin-user-name">${u.name}</div>
                    <div class="admin-user-username">@${u.username}</div>
                </div>
                <span class="role-badge ${roleClass[u.role] || ''}">${roleLabel[u.role] || u.role}</span>
                <div class="admin-user-actions">
                    <select class="input select role-select" data-uid="${u.id}" ${u.id === App.user.id ? 'disabled' : ''}>
                        <option value="admin" ${u.role === 'admin' ? 'selected' : ''}>Admin</option>
                        <option value="post_productor" ${u.role === 'post_productor' ? 'selected' : ''}>Post-Producción</option>
                        <option value="academica" ${u.role === 'academica' ? 'selected' : ''}>Académica</option>
                    </select>
                    ${u.id !== App.user.id ? `<button class="btn-icon btn-danger-icon" onclick="AdminPanel.deleteUser(${u.id})" title="Eliminar usuario">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                    </button>` : ''}
                </div>
            </div>
        `).join('');

        // Bind role change selects
        list.querySelectorAll('.role-select').forEach(sel => {
            sel.addEventListener('change', async (e) => {
                const uid = +sel.dataset.uid;
                await API.put(`/users/${uid}`, { role: e.target.value });
                showToast('Rol actualizado', 'success');
                await this.loadUsers();
            });
        });
    },

    async createUser() {
        const name = document.getElementById('new-user-name').value.trim();
        const username = document.getElementById('new-user-username').value.trim().toLowerCase().replace(/\s+/g, '');
        const password = document.getElementById('new-user-password').value.trim();
        const role = document.getElementById('new-user-role').value;

        if (!name || !username || !password) return showToast('Todos los campos son requeridos', 'error');

        const result = await API.post('/users', { name, username, password, role });
        if (result.error) {
            if (result.error.includes('ya existe')) {
                showToast(`El usuario "${username}" ya está en uso. Prueba con "${username}2" o un nombre diferente.`, 'error');
                // Suggest alternative
                document.getElementById('new-user-username').value = username + '2';
                document.getElementById('new-user-username').dataset.manuallyEdited = 'yes';
            } else {
                showToast(result.error, 'error');
            }
            return;
        }

        showToast(`Usuario "${name}" creado correctamente`, 'success');
        
        // Show success box with credentials for WhatsApp
        const roleLabel = { admin: 'Administrador', post_productor: 'Post-Producción', academica: 'Académica' }[role] || role;
        
        this.lastCreatedUser = {
            name,
            username,
            password,
            role: roleLabel
        };
        
        document.getElementById('new-user-success-text').textContent = `${name} (@${username})`;
        document.getElementById('new-user-success-box').style.display = 'flex';
        
        // Clear fields
        document.getElementById('new-user-name').value = '';
        const unField = document.getElementById('new-user-username');
        unField.value = '';
        unField.dataset.manuallyEdited = '';
        document.getElementById('new-user-password').value = '';
        await this.loadUsers();
    },

    async copyToWhatsApp() {
        if (!this.lastCreatedUser) return;
        const u = this.lastCreatedUser;
        const url = window.location.origin + window.location.pathname;
        
        const text = `Hola ${u.name}, estas son tus credenciales de acceso al Calendario de Filmaciones (${u.role}):

🌐 *Enlace:* ${url}
👤 *Usuario:* ${u.username}
🔑 *Contraseña:* ${u.password}

_Por favor, guarda estos datos de forma segura._`;

        try {
            await navigator.clipboard.writeText(text);
            const btn = document.getElementById('btn-copy-whatsapp');
            const originalHTML = btn.innerHTML;
            btn.innerHTML = `<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg> ¡Copiado!`;
            setTimeout(() => { btn.innerHTML = originalHTML; }, 2000);
        } catch (err) {
            showToast('No se pudo copiar al portapapeles', 'error');
        }
    },

    async deleteUser(id) {
        const u = this.users.find(x => x.id === id);
        Calendar.showConfirm({
            title: 'Eliminar Usuario',
            message: `¿Eliminar a "${u?.name || 'este usuario'}"? Se cerrarán todas sus sesiones activas.`
        }, async () => {
            const result = await API.del(`/users/${id}`);
            if (result.error) return showToast(result.error, 'error');
            showToast('Usuario eliminado', 'success');
            await this.loadUsers();
        });
    },

    // ---- GLOBAL SUBJECTS ----
    async loadGlobalSubjects() {
        this.globalSubjects = await API.get('/global-subjects');
        this.renderGlobalSubjects();
    },

    renderGlobalSubjects() {
        const list = document.getElementById('global-subjects-list');
        if (!list) return;

        const countEl = document.getElementById('gs-count');
        if (countEl) countEl.textContent = this.globalSubjects.length;

        if (this.globalSubjects.length === 0) {
            list.innerHTML = '<div class="empty-state"><p>No hay materias globales aún</p><span>Agrega materias o importa desde texto CSV</span></div>';
            return;
        }

        list.innerHTML = this.globalSubjects.map(s => `
            <div class="gs-row">
                <span class="gs-code">${s.code}</span>
                <span class="gs-name">${s.name}</span>
                ${s.career ? `<span class="gs-career">${s.career}</span>` : '<span></span>'}
                <button class="btn-icon btn-danger-icon" onclick="AdminPanel.deleteGlobalSubject(${s.id})" title="Eliminar">
                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/></svg>
                </button>
            </div>
        `).join('');
    },

    async addGlobalSubject() {
        const code = document.getElementById('gs-code').value.trim();
        const name = document.getElementById('gs-name').value.trim();
        const career = document.getElementById('gs-career').value.trim();
        if (!code || !name) return showToast('Código y nombre requeridos', 'error');
        const result = await API.post('/global-subjects', { code, name, career });
        if (result.error) return showToast(result.error, 'error');
        document.getElementById('gs-code').value = '';
        document.getElementById('gs-name').value = '';
        document.getElementById('gs-career').value = '';
        showToast('Materia agregada', 'success');
        await this.loadGlobalSubjects();
    },

    async importBulkSubjects() {
        const raw = document.getElementById('gs-bulk-import').value.trim();
        if (!raw) return showToast('Ingresa datos para importar', 'error');

        // Parse: each line is "CODE - Name (Career)" or "CODE,Name,Career" or "CODE\tName"
        const lines = raw.split('\n').map(l => l.trim()).filter(Boolean);
        const subjects = [];
        for (const line of lines) {
            // Try comma, tab, or " - " separator
            let parts = line.includes(',') ? line.split(',') : line.includes('\t') ? line.split('\t') : line.split(' - ');
            if (parts.length >= 2) {
                subjects.push({ code: parts[0].trim(), name: parts[1].trim(), career: parts[2]?.trim() || null });
            }
        }
        if (subjects.length === 0) return showToast('No se pudo parsear ninguna materia. Usa formato: CÓDIGO,Nombre', 'error');

        const result = await API.post('/global-subjects/bulk', { subjects });
        if (result.error) return showToast(result.error, 'error');
        document.getElementById('gs-bulk-import').value = '';
        showToast(`Importadas: ${result.inserted} materias`, 'success');
        await this.loadGlobalSubjects();
    },

    async deleteGlobalSubject(id) {
        await API.del(`/global-subjects/${id}`);
        showToast('Materia eliminada', 'success');
        await this.loadGlobalSubjects();
    },

    // ---- ACTIVITY LOG ----
    async loadLog() {
        this.log = await API.get('/activity-log?limit=100');
        this.renderLog();
    },

    renderLog() {
        const list = document.getElementById('activity-log-list');
        if (!list) return;

        if (!this.log || this.log.length === 0) {
            list.innerHTML = '<div class="empty-state"><p>Sin actividad registrada aún</p></div>';
            return;
        }

        list.innerHTML = this.log.map(entry => {
            const dt = new Date(entry.created_at);
            const dateStr = dt.toLocaleDateString('es-BO', { day: '2-digit', month: 'short', year: 'numeric' });
            const timeStr = dt.toLocaleTimeString('es-BO', { hour: '2-digit', minute: '2-digit' });
            return `
                <div class="log-entry">
                    <div class="log-avatar">${entry.user_name.charAt(0).toUpperCase()}</div>
                    <div class="log-body">
                        <span class="log-user">${entry.user_name}</span>
                        <span class="log-action">${entry.action}</span>
                        ${entry.details ? `<span class="log-details">${entry.details}</span>` : ''}
                    </div>
                    <div class="log-time">
                        <span>${dateStr}</span>
                        <span>${timeStr}</span>
                    </div>
                </div>
            `;
        }).join('');
    },

    // ---- HOLIDAYS (FERIADOS) ----
    async loadHolidays() {
        this.holidays = await API.get('/holidays');
        this.renderHolidays();
    },

    filterHolidays(filter) {
        this.holidaysFilter = filter;
        ['all', 'fixed', 'mobile'].forEach(f => {
            const btn = document.getElementById(`btn-holidays-filter-${f}`);
            if (btn) btn.style.fontWeight = f === filter ? '700' : '';
        });
        this.renderHolidays();
    },

    renderHolidays() {
        const list = document.getElementById('holidays-list');
        const countEl = document.getElementById('holidays-count');
        if (!list) return;

        let filtered = this.holidays || [];
        if (this.holidaysFilter === 'fixed') filtered = filtered.filter(h => h.is_fixed);
        if (this.holidaysFilter === 'mobile') filtered = filtered.filter(h => !h.is_fixed);

        if (countEl) countEl.textContent = this.holidays.length;

        if (filtered.length === 0) {
            list.innerHTML = `<div class="empty-state" style="padding:24px 12px;"><p>No hay feriados registrados</p><span>Agrega uno usando el formulario de arriba</span></div>`;
            return;
        }

        list.innerHTML = filtered.map((h, i) => {
            const isFixed = h.is_fixed;
            const typeBadge = isFixed
                ? `<span title="Fijo: aplica cada año" style="display:inline-flex;align-items:center;gap:3px;font-size:10px;font-weight:700;padding:2px 7px;border-radius:4px;background:rgba(96,165,250,0.15);color:#60a5fa;">🔁 Fijo</span>`
                : `<span title="Móvil: solo ese año" style="display:inline-flex;align-items:center;gap:3px;font-size:10px;font-weight:700;padding:2px 7px;border-radius:4px;background:rgba(167,139,250,0.15);color:#a78bfa;">📅 Móvil</span>`;
            const bgStyle = i % 2 === 0 ? 'var(--bg-card)' : 'var(--bg-elevated)';
            return `
                <div style="display:grid;grid-template-columns:70px 110px 1fr 48px;gap:0;padding:9px 12px;background:${bgStyle};border-bottom:1px solid var(--border-light);align-items:center;" onmouseover="this.style.background='var(--bg-tertiary)'" onmouseout="this.style.background='${bgStyle}'">
                    <div>${typeBadge}</div>
                    <div style="font-family:monospace;font-size:12px;font-weight:600;color:var(--text-secondary);">${h.date_key}</div>
                    <div style="font-size:13px;font-weight:500;color:var(--text-primary);">${h.name}</div>
                    <div style="text-align:right;">
                        <button class="btn-icon btn-danger-icon" onclick="AdminPanel.deleteHoliday(${h.id})" title="Eliminar feriado">
                            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/></svg>
                        </button>
                    </div>
                </div>
            `;
        }).join('');
    },

    async addHoliday() {
        const dateKey = document.getElementById('holiday-date-key')?.value.trim();
        const name = document.getElementById('holiday-name')?.value.trim();
        const isFixed = document.getElementById('holiday-type')?.value === '1';

        if (!dateKey || !name) return showToast('Fecha y nombre son requeridos', 'error');

        const result = await API.post('/holidays', { date_key: dateKey, name, is_fixed: isFixed });
        if (result.error) return showToast(result.error, 'error');

        document.getElementById('holiday-date-key').value = '';
        document.getElementById('holiday-name').value = '';
        document.getElementById('holiday-type').value = '0';
        showToast(`Feriado "${name}" agregado`, 'success');
        await this.loadHolidays();
    },

    async deleteHoliday(id) {
        const h = this.holidays.find(x => x.id === id);
        Calendar.showConfirm({
            title: 'Eliminar Feriado',
            message: `¿Eliminar "${h?.name || 'este feriado'}" (${h?.date_key})? Dejará de mostrarse en el calendario.`
        }, async () => {
            const result = await API.del(`/holidays/${id}`);
            if (result.error) return showToast(result.error, 'error');
            showToast('Feriado eliminado', 'success');
            await this.loadHolidays();
        });
    },

    prefillHoliday(type) {
        const dateInput = document.getElementById('holiday-date-key');
        const typeSelect = document.getElementById('holiday-type');
        if (!dateInput || !typeSelect) return;
        if (type === 'fixed') {
            dateInput.placeholder = 'MM-DD (ej: 12-25)';
            typeSelect.value = '1';
        } else {
            const yyyy = new Date().getFullYear();
            dateInput.placeholder = `YYYY-MM-DD (ej: ${yyyy}-02-16)`;
            typeSelect.value = '0';
        }
        dateInput.focus();
        showToast(type === 'fixed' ? 'Ingresa la fecha como MM-DD' : 'Ingresa la fecha como YYYY-MM-DD', 'info');
    }
};

document.addEventListener('DOMContentLoaded', () => {
    setTimeout(() => AdminPanel.init(), 200);
});

