// ================================================
// Admin Panel — User Management, Global Subjects, Activity Log
// ================================================

const AdminPanel = {
    users: [],
    globalSubjects: [],
    holidays: [],
    holidaysFilter: 'all',
    log: [],
    apiKeys: [],
    lastApiKey: null,
    activeTab: 'users',

    init() {
        document.getElementById('admin-tab-users')?.addEventListener('click', () => this.switchTab('users'));
        document.getElementById('admin-tab-subjects')?.addEventListener('click', () => this.switchTab('subjects'));
        document.getElementById('admin-tab-holidays')?.addEventListener('click', () => this.switchTab('holidays'));
        document.getElementById('admin-tab-log')?.addEventListener('click', () => this.switchTab('log'));
        document.getElementById('admin-tab-apikeys')?.addEventListener('click', () => this.switchTab('apikeys'));
        document.getElementById('admin-tab-staff-report')?.addEventListener('click', () => this.switchTab('staff-report'));

        // Set base URL in docs section
        const baseUrlEl = document.getElementById('apikey-base-url');
        if (baseUrlEl) baseUrlEl.textContent = window.location.origin;

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
        if (tab === 'apikeys') await this.loadApiKeys();
        if (tab === 'staff-report') await this.loadStaffReport();
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
        try {
            const result = await API.get('/activity-log?limit=100');
            this.log = Array.isArray(result) ? result : [];
        } catch (e) {
            console.warn('[loadLog]', e);
            this.log = [];
        }
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
                ? `<span title="Fijo: aplica cada año" style="display:inline-flex;align-items:center;gap:3px;font-size:10px;font-weight:700;padding:2px 7px;border-radius:4px;background:rgba(96,165,250,0.15);color:#60a5fa;"><svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="23 4 23 10 17 10"/><path d="M20.49 15a9 9 0 1 1-2.12-9.36L23 10"/></svg> Fijo</span>`
                : `<span title="Móvil: solo ese año" style="display:inline-flex;align-items:center;gap:3px;font-size:10px;font-weight:700;padding:2px 7px;border-radius:4px;background:rgba(167,139,250,0.15);color:#a78bfa;"><svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg> Móvil</span>`;
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
    },

    // ---- API KEYS ----
    async loadApiKeys() {
        const list = document.getElementById('apikeys-list');
        if (list) list.innerHTML = '<div style="padding:20px; text-align:center; color:var(--text-muted); font-size:13px;">Cargando...</div>';
        const data = await API.get('/admin/api-keys');
        this.apiKeys = Array.isArray(data) ? data : [];
        this.renderApiKeys();

        // Bind create button once loaded
        const btn = document.getElementById('btn-create-apikey');
        if (btn && !btn.dataset.bound) {
            btn.dataset.bound = '1';
            btn.addEventListener('click', () => this.createApiKey());
            document.getElementById('apikey-name')?.addEventListener('keydown', (e) => {
                if (e.key === 'Enter') this.createApiKey();
            });
        }
    },

    renderApiKeys() {
        const list = document.getElementById('apikeys-list');
        const countEl = document.getElementById('apikeys-count');
        if (!list) return;

        if (countEl) countEl.textContent = this.apiKeys.length;

        if (this.apiKeys.length === 0) {
            list.innerHTML = `<div class="empty-state" style="padding:28px 12px;">
                <p>No hay API Keys registradas</p>
                <span>Crea una usando el formulario de arriba</span>
            </div>`;
            return;
        }

        const fmtDate = (str) => {
            if (!str) return '<span style="color:var(--text-muted);font-size:11px;">Nunca</span>';
            const d = new Date(str);
            return d.toLocaleDateString('es-BO', { day: '2-digit', month: 'short', year: 'numeric' })
                 + ' ' + d.toLocaleTimeString('es-BO', { hour: '2-digit', minute: '2-digit' });
        };

        list.innerHTML = this.apiKeys.map((k, i) => {
            const bg = i % 2 === 0 ? 'var(--bg-card)' : 'var(--bg-elevated)';
            const activeBadge = k.is_active
                ? `<span style="display:inline-block;padding:2px 8px;border-radius:4px;font-size:10px;font-weight:700;background:rgba(52,211,153,0.15);color:#34d399;">Activa</span>`
                : `<span style="display:inline-block;padding:2px 8px;border-radius:4px;font-size:10px;font-weight:700;background:rgba(239,68,68,0.15);color:#f87171;">Inactiva</span>`;
            return `
                <div style="display:grid;grid-template-columns:1fr 100px 140px 130px 80px;gap:0;padding:10px 12px;background:${bg};border-bottom:1px solid var(--border-light);align-items:center;"
                    onmouseover="this.style.background='var(--bg-tertiary)'" onmouseout="this.style.background='${bg}'">
                    <div>
                        <div style="font-size:13px;font-weight:600;color:var(--text-primary);">${k.name}</div>
                        <div style="font-family:monospace;font-size:11px;color:var(--text-muted);margin-top:2px;">${k.key_preview}</div>
                    </div>
                    <div>${activeBadge}</div>
                    <div style="font-size:11px;color:var(--text-secondary);">${fmtDate(k.last_used_at)}</div>
                    <div style="font-size:11px;color:var(--text-secondary);">${fmtDate(k.created_at)}</div>
                    <div style="display:flex;gap:6px;justify-content:flex-end;">
                        <button class="btn-icon" title="${k.is_active ? 'Desactivar' : 'Activar'}" onclick="AdminPanel.toggleApiKey(${k.id})" style="color:${k.is_active ? 'var(--accent)' : 'var(--text-muted)'}">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/>${k.is_active ? '<polyline points="8 12 11 15 16 9"/>' : '<line x1="8" y1="8" x2="16" y2="16"/><line x1="16" y1="8" x2="8" y2="16"/>'}</svg>
                        </button>
                        <button class="btn-icon btn-danger-icon" title="Eliminar key" onclick="AdminPanel.deleteApiKey(${k.id}, '${k.name.replace(/'/g, "&apos;")}')">
                            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/></svg>
                        </button>
                    </div>
                </div>
            `;
        }).join('');
    },

    async createApiKey() {
        const name = document.getElementById('apikey-name')?.value.trim();
        if (!name) return showToast('Ingresa un nombre para la API Key', 'error');

        const btn = document.getElementById('btn-create-apikey');
        if (btn) { btn.disabled = true; btn.textContent = 'Generando...'; }

        const result = await API.post('/admin/api-keys', { name });

        if (btn) {
            btn.disabled = false;
            btn.innerHTML = `<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg> Generar Key`;
        }

        if (result.error) return showToast(result.error, 'error');

        // Show the reveal box
        this.lastApiKey = result.api_key;
        const tokenEl = document.getElementById('apikey-reveal-token');
        const revealBox = document.getElementById('apikey-reveal-box');
        if (tokenEl) tokenEl.textContent = result.api_key;
        if (revealBox) revealBox.style.display = 'block';

        // Clear input
        document.getElementById('apikey-name').value = '';
        showToast(`API Key "${name}" creada. ¡Cópiala ahora!`, 'success');
        await this.loadApiKeys();
    },

    async toggleApiKey(id) {
        const result = await API.put(`/admin/api-keys/${id}/toggle`, {});
        if (result.error) return showToast(result.error, 'error');
        showToast(result.is_active ? 'API Key activada' : 'API Key desactivada', 'info');
        await this.loadApiKeys();
    },

    async deleteApiKey(id, name) {
        Calendar.showConfirm({
            title: 'Eliminar API Key',
            message: `¿Eliminar la key "${name}"? Los sistemas que la usen dejarán de funcionar inmediatamente.`
        }, async () => {
            const result = await API.del(`/admin/api-keys/${id}`);
            if (result.error) return showToast(result.error, 'error');
            showToast('API Key eliminada', 'success');
            await this.loadApiKeys();
        });
    },

    async copyApiKey() {
        if (!this.lastApiKey) return;
        try {
            await navigator.clipboard.writeText(this.lastApiKey);
            const btn = document.getElementById('btn-copy-apikey');
            if (btn) {
                const orig = btn.innerHTML;
                btn.innerHTML = `<svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg> ¡Copiada!`;
                setTimeout(() => { btn.innerHTML = orig; }, 2000);
            }
            showToast('API Key copiada al portapapeles', 'success');
        } catch (e) {
            showToast('No se pudo copiar. Selecciona el texto manualmente.', 'error');
        }
    },

    hideApiKeyReveal() {
        const box = document.getElementById('apikey-reveal-box');
        if (box) box.style.display = 'none';
        this.lastApiKey = null;
    },

    // ---- STAFF REPORT ----
    staffReport: [],

    initStaffReportSelectors() {
        const monthSel = document.getElementById('staff-report-month');
        const yearSel  = document.getElementById('staff-report-year');
        if (!monthSel || !yearSel) return;

        // Set current month
        const now = new Date();
        monthSel.value = String(now.getMonth() + 1);

        // Populate years (current and a couple back)
        const cy = now.getFullYear();
        yearSel.innerHTML = '';
        for (let y = cy; y >= cy - 2; y--) {
            const opt = document.createElement('option');
            opt.value = y;
            opt.textContent = y;
            yearSel.appendChild(opt);
        }
        yearSel.value = String(cy);
    },

    async loadStaffReport() {
        // Init selectors on first call
        const monthSel = document.getElementById('staff-report-month');
        const yearSel  = document.getElementById('staff-report-year');
        if (yearSel && yearSel.options.length === 0) this.initStaffReportSelectors();

        const month = monthSel?.value || (new Date().getMonth() + 1);
        const year  = yearSel?.value  || new Date().getFullYear();

        const list = document.getElementById('staff-report-list');
        const kpis = document.getElementById('staff-report-kpis');

        const monthNames = ['','Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'];
        if (list) list.innerHTML = `<div style="padding:28px; text-align:center; color:var(--text-muted); font-size:13px;">Cargando reporte de ${monthNames[month]} ${year}...</div>`;
        if (kpis) kpis.innerHTML = '';

        const data = await API.get(`/admin/staff-report?year=${year}&month=${month}`);
        if (!Array.isArray(data)) {
            if (list) list.innerHTML = '<div style="padding:28px; text-align:center; color:var(--text-muted);">No se pudo cargar el reporte.</div>';
            return;
        }
        this.staffReport = data;
        this.staffReportMonth = monthNames[month];
        this.staffReportYear = year;
        this.renderStaffReport();
    },

    renderStaffReport() {
        const list = document.getElementById('staff-report-list');
        const kpis = document.getElementById('staff-report-kpis');
        if (!list) return;

        const data = this.staffReport;
        const periodLabel = `${this.staffReportMonth || ''} ${this.staffReportYear || ''}`.trim();

        if (data.length === 0) {
            list.innerHTML = `<div class="empty-state" style="padding:32px 12px;"><p>Sin participaciones en ${periodLabel}</p><span>No hay sesiones con staff asignado en este período</span></div>`;
            if (kpis) kpis.innerHTML = '';
            return;
        }

        const totalSessions = data.reduce((s, u) => s + u.total, 0);
        const maxSessions   = data[0]?.total || 1;
        const topParticipant = data[0]?.name || '—';

        // KPI cards
        if (kpis) {
            kpis.innerHTML = [
                { label: 'Total Participaciones', value: totalSessions, icon: '<path d="M22 12h-4l-3 9L9 3l-3 9H2"/>', color: 'var(--accent)' },
                { label: 'Personas Activas',      value: data.length,   icon: '<path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/>', color: '#a78bfa' },
                { label: 'Líder del Mes',         value: topParticipant, icon: '<polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/>', color: '#fbbf24' },
            ].map(k => `
                <div style="padding:16px 18px; background:var(--bg-card); border:1px solid var(--border-light); border-radius:8px; display:flex; align-items:center; gap:14px;">
                    <div style="width:40px; height:40px; border-radius:8px; background:${k.color}20; display:flex; align-items:center; justify-content:center; flex-shrink:0;">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="${k.color}" stroke-width="2">${k.icon}</svg>
                    </div>
                    <div>
                        <div style="font-size:20px; font-weight:800; color:var(--text-primary); line-height:1;">${k.value}</div>
                        <div style="font-size:11px; color:var(--text-muted); margin-top:3px; text-transform:uppercase; letter-spacing:.4px;">${k.label}</div>
                    </div>
                </div>
            `).join('');
        }

        const medal = [
            '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#fbbf24" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="8" r="7"/><polyline points="8.21 13.89 7 23 12 20 17 23 15.79 13.88"/></svg>',
            '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#9ca3af" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="8" r="7"/><polyline points="8.21 13.89 7 23 12 20 17 23 15.79 13.88"/></svg>',
            '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#b45309" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="8" r="7"/><polyline points="8.21 13.89 7 23 12 20 17 23 15.79 13.88"/></svg>'
        ];
        const fmtDate = (d) => {
            const dt = new Date(d + 'T12:00:00');
            return dt.toLocaleDateString('es-BO', { weekday:'short', day:'2-digit', month:'short' });
        };
        const turnoColor  = { 'mañana': 'var(--cyan, #22d3ee)', 'tarde': 'var(--amber, #fbbf24)', 'sesión': 'var(--accent)' };
        const sourceLabel = { 
            'sesión': '<svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="vertical-align:-2px;"><rect width="20" height="20" x="2" y="2" rx="2.18" ry="2.18"/><line x1="7" x2="7" y1="2" y2="22"/><line x1="17" x2="17" y1="2" y2="22"/><line x1="2" x2="22" y1="12" y2="12"/><line x1="2" x2="7" y1="7" y2="7"/><line x1="2" x2="7" y1="17" y2="17"/><line x1="17" x2="22" y1="17" y2="17"/><line x1="17" x2="22" y1="7" y2="7"/></svg>', 
            'full-day': '<svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="vertical-align:-2px;"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"/><line x1="16" x2="16" y1="2" y2="6"/><line x1="8" x2="8" y1="2" y2="6"/><line x1="3" x2="21" y1="10" y2="10"/></svg>', 
            'reserva': '<svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="vertical-align:-2px;"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"/><line x1="16" x2="16" y1="2" y2="6"/><line x1="8" x2="8" y1="2" y2="6"/><line x1="3" x2="21" y1="10" y2="10"/><path d="M8 14h.01"/><path d="M12 14h.01"/><path d="M16 14h.01"/><path d="M8 18h.01"/><path d="M12 18h.01"/><path d="M16 18h.01"/></svg>' 
        };

        list.innerHTML = data.map((u, i) => {
            const pct  = Math.round((u.total / maxSessions) * 100);
            const bg   = i % 2 === 0 ? 'var(--bg-card)' : 'var(--bg-elevated)';
            const rank = i < 3 ? medal[i] : `<span style="font-size:12px; font-weight:700; color:var(--text-muted);">${i + 1}</span>`;
            const rowId = `staff-detail-${u.id}`;

            // Group entries by date
            const byDate = {};
            for (const e of (u.entries || [])) {
                if (!byDate[e.date]) byDate[e.date] = [];
                byDate[e.date].push(e);
            }
            const datesHtml = Object.entries(byDate).map(([date, entries]) => {
                const entriesHtml = entries.map(e => {
                    const tColor = turnoColor[e.turno] || 'var(--text-muted)';
                    const srcIcon = sourceLabel[e.source] || '';
                    return `<div style="display:flex; align-items:center; gap:6px; margin-left:12px;">
                        <span style="display:inline-block; width:6px; height:6px; border-radius:50%; background:${tColor}; flex-shrink:0;"></span>
                        <span style="font-size:10px; font-weight:600; color:${tColor}; text-transform:uppercase; min-width:52px;">${e.turno}</span>
                        <span style="font-size:12px;" title="${e.source || ''}">${srcIcon}</span>
                        <span style="font-size:11px; color:var(--text-primary);">${e.subject || '—'}</span>
                        ${e.teacher ? `<span style="font-size:10px; color:var(--text-muted);">· ${e.teacher}</span>` : ''}
                    </div>`;
                }).join('');
                return `<div style="margin-bottom:8px;">
                    <div style="font-size:11px; font-weight:700; color:var(--text-secondary); margin-bottom:3px;">${fmtDate(date)}</div>
                    ${entriesHtml}
                </div>`;
            }).join('');

            return `
                <div style="border-bottom:1px solid var(--border-light); background:${bg};" onmouseover="this.style.background='var(--bg-tertiary)'" onmouseout="this.style.background='${bg}'">
                    <div style="display:grid; grid-template-columns:36px 1fr 90px 80px 44px; gap:0; padding:10px 14px; align-items:center; cursor:pointer;" onclick="var el=document.getElementById('${rowId}'); el.style.display = el.style.display==='none'?'block':'none'">
                        <div style="font-size:18px; text-align:center;">${rank}</div>
                        <div>
                            <div style="font-size:13px; font-weight:600; color:var(--text-primary); margin-bottom:5px;">${u.name}</div>
                            <div style="height:5px; background:var(--border-light); border-radius:3px; overflow:hidden;">
                                <div style="height:100%; width:${pct}%; background:linear-gradient(90deg, var(--accent), #a78bfa); border-radius:3px; transition:width .4s ease;"></div>
                            </div>
                        </div>
                        <div style="text-align:center;">
                            <span style="font-size:22px; font-weight:800; color:var(--accent); line-height:1;">${u.total}</span>
                            <div style="font-size:10px; color:var(--text-muted); text-transform:uppercase;">sesiones</div>
                        </div>
                        <div style="text-align:center;">
                            <span style="font-size:22px; font-weight:800; color:#a78bfa; line-height:1;">${u.days}</span>
                            <div style="font-size:10px; color:var(--text-muted); text-transform:uppercase;">días</div>
                        </div>
                        <div style="text-align:center;">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="var(--text-muted)" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
                        </div>
                    </div>
                    <div id="${rowId}" style="display:none; padding:10px 14px 14px 50px; background:var(--bg-tertiary); border-top:1px solid var(--border-light);">
                        <div style="font-size:11px; font-weight:600; color:var(--text-muted); text-transform:uppercase; margin-bottom:8px;">Detalle de asistencia (${u.days} días, ${u.total} sesiones):</div>
                        <div>${datesHtml || '<span style="font-size:12px; color:var(--text-muted);">Sin registros detallados</span>'}</div>
                    </div>
                </div>
            `;
        }).join('');
    }
};

document.addEventListener('DOMContentLoaded', () => {
    setTimeout(() => AdminPanel.init(), 200);
});

