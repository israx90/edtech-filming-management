// ================================================
// Modals Module
// ================================================

const Modals = {
    currentAssignmentId: null,

    init() {
        // Close modal on overlay click or close buttons
        document.getElementById('modal-overlay').addEventListener('click', () => this.closeAll());
        document.querySelectorAll('[data-close-modal]').forEach(btn => {
            btn.addEventListener('click', () => this.closeAll());
        });
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape') this.closeAll();
        });

        // Bind all modal triggers
        document.getElementById('btn-new-assignment').addEventListener('click', () => this.openNewAssignment());
        document.getElementById('btn-close-week').addEventListener('click', () => this.openCloseWeek());
        document.getElementById('btn-manage-semester').addEventListener('click', () => this.openSemesterManager());
        document.getElementById('btn-add-subject').addEventListener('click', () => this.openAddSubject());
        document.getElementById('btn-bulk-import').addEventListener('click', () => this.openBulkImport());
        document.getElementById('btn-delete-all-subjects')?.addEventListener('click', () => Goals.deleteAllSubjects());
        document.getElementById('btn-settings').addEventListener('click', () => this.openSemesterManager());
        document.getElementById('btn-new-reservation')?.addEventListener('click', () => this.openNewReservation());

        // Save handlers
        document.getElementById('btn-create-semester').addEventListener('click', () => this.createSemester());
        document.getElementById('btn-save-subject').addEventListener('click', () => this.saveSubject());
        document.getElementById('btn-do-import').addEventListener('click', () => this.doBulkImport());
        document.getElementById('btn-save-assignment').addEventListener('click', () => this.saveAssignment());
        document.getElementById('btn-do-close-week').addEventListener('click', () => this.doCloseWeek());
        document.getElementById('btn-save-session').addEventListener('click', () => this.saveNewSession());
        document.getElementById('btn-detail-add-session').addEventListener('click', () => this.openAddSession());
        document.getElementById('btn-detail-complete').addEventListener('click', () => this.markComplete());
        document.getElementById('btn-save-reservation')?.addEventListener('click', () => this.saveReservation());
        document.getElementById('btn-save-edit-session')?.addEventListener('click', () => this.saveEditSession());

        // Pending teachers integration
        document.getElementById('input-select-pending')?.addEventListener('change', (e) => {
            if (!e.target.value) {
                document.getElementById('input-teacher-name').value = '';
                document.getElementById('input-teacher-phone').value = '';
                document.getElementById('input-assignment-subject').value = '';
                return;
            }
            const pt = Modals.pendingTeachersData?.find(t => t.id == e.target.value);
            if (pt) {
                document.getElementById('input-teacher-name').value = pt.name;
                document.getElementById('input-teacher-phone').value = pt.phone || '';
                
                const subjectSelect = document.getElementById('input-assignment-subject');
                const subjectOptions = Array.from(subjectSelect.options);
                
                const normalize = str => str.normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase().trim();
                const ptSubj = normalize(pt.subject);
                const ptCode = pt.subject_code ? normalize(pt.subject_code) : null;
                
                // Find best match
                let match = subjectOptions.find(opt => {
                    const optText = normalize(opt.text);
                    if (ptCode && optText.includes(ptCode)) return true;
                    return optText === ptSubj || optText.includes(ptSubj) || ptSubj.includes(optText);
                });
                
                if (match) {
                    subjectSelect.value = match.value;
                } else {
                    subjectSelect.value = '';
                }
                
                if (pt.sede) {
                    const sedeSelect = document.getElementById('input-assignment-sede');
                    if (sedeSelect) {
                        sedeSelect.value = pt.sede;
                        Modals.checkFlightTicketVisibility();
                    }
                }
                
                // Auto-fill drive link if available
                const driveLinkInput = document.getElementById('input-drive-link');
                if (driveLinkInput && pt.drive_link) {
                    driveLinkInput.value = pt.drive_link;
                }

                // Show flight ticket info if already uploaded
                if (pt.flight_ticket_path) {
                    const ticketRow = document.getElementById('flight-ticket-container');
                    if (ticketRow) {
                        ticketRow.style.display = 'block'; // Make sure it's visible
                        // Show an existing ticket notice
                        let notice = document.getElementById('existing-ticket-notice');
                        if (!notice) {
                            notice = document.createElement('div');
                            notice.id = 'existing-ticket-notice';
                            notice.style.cssText = 'font-size:11px;color:var(--purple);background:var(--purple-bg);border:1px solid rgba(188,140,255,0.2);border-radius:6px;padding:6px 10px;margin-top:6px;display:flex;align-items:center;gap:6px;';
                            notice.innerHTML = `<svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg> Ya tiene pasaje cargado — <a href="/api${pt.flight_ticket_path}" target="_blank" style="color:var(--purple);font-weight:600;">Ver Pasaje</a>`;
                            ticketRow.appendChild(notice);
                        } else {
                            notice.style.display = 'flex';
                            notice.querySelector('a').href = `/api${pt.flight_ticket_path}`;
                        }
                        // Store path so it gets saved
                        Modals._existingTicketPath = pt.flight_ticket_path;
                    }
                } else {
                    const notice = document.getElementById('existing-ticket-notice');
                    if (notice) notice.style.display = 'none';
                    Modals._existingTicketPath = null;
                }
            }
        });
    },

    open(modalId) {
        document.getElementById('modal-overlay').classList.add('active');
        document.getElementById(modalId).classList.add('active');
    },

    closeAll() {
        document.getElementById('modal-overlay').classList.remove('active');
        document.querySelectorAll('.modal.active').forEach(m => m.classList.remove('active'));
    },

    // ===== SEMESTER MANAGER =====

    async openSemesterManager() {
        this.open('modal-semester');
        const semesters = await API.get('/semesters');
        const list = document.getElementById('semester-list');
        if (semesters.length === 0) {
            list.innerHTML = '<p style="color:var(--text-muted);font-size:13px;text-align:center;padding:20px;">No hay semestres creados</p>';
            return;
        }
        list.innerHTML = semesters.map(s => `
            <div class="semester-item ${s.is_active ? 'is-active' : ''}">
                <span class="semester-item-name">${s.name} ${s.is_active ? '(Activo)' : ''}</span>
                <div class="semester-item-actions">
                    ${!s.is_active ? `<button class="btn-sm btn-outline" onclick="Modals.activateSemester(${s.id})">Activar</button>` : ''}
                    <button class="btn-icon" onclick="Modals.deleteSemester(${s.id})" title="Eliminar">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                    </button>
                </div>
            </div>
        `).join('');
    },

    async createSemester() {
        const name = document.getElementById('input-semester-name').value.trim();
        if (!name) return showToast('Ingresa un nombre', 'error');
        const result = await API.post('/semesters', { name });
        if (result.error) return showToast(result.error, 'error');
        document.getElementById('input-semester-name').value = '';
        showToast(`Semestre "${name}" creado`, 'success');
        await App.loadActiveSemester();
        this.openSemesterManager();
        Dashboard.refresh();
        Calendar.render();
    },

    async activateSemester(id) {
        await API.put(`/semesters/${id}/activate`);
        await App.loadActiveSemester();
        showToast('Semestre activado', 'success');
        this.openSemesterManager();
        Dashboard.refresh();
        Calendar.render();
        Goals.refresh();
    },

    async deleteSemester(id) {
        Calendar.showConfirm({
            title: 'Eliminar Semestre',
            message: '¿Eliminar este semestre y todas sus materias? Esta acción no se puede deshacer.'
        }, async () => {
            await API.del(`/semesters/${id}`);
            await App.loadActiveSemester();
            showToast('Semestre eliminado', 'success');
            this.openSemesterManager();
            Dashboard.refresh();
            Calendar.render();
        });
    },

    // ===== ADD SUBJECT =====

    openAddSubject() {
        if (!App.activeSemester) return showToast('Primero crea un semestre', 'error');
        document.getElementById('input-subject-name').value = '';
        this.open('modal-subject');
    },

    async saveSubject() {
        const name = document.getElementById('input-subject-name').value.trim();
        const subject_type = document.getElementById('input-subject-type-select')?.value || 'Teórica';
        if (!name) return showToast('Ingresa el nombre o materia', 'error');
        const result = await API.post('/subjects', { name, subject_type, semester_id: App.activeSemester.id });
        if (result.error) return showToast(result.error, 'error');
        showToast(`Materia agregada`, 'success');
        this.closeAll();
        Goals.refresh();
        Dashboard.refresh();
    },

    // ===== BULK IMPORT (with Preview) =====

    parsedSubjects: [], // Holds the parsed preview data

    openBulkImport() {
        if (!App.activeSemester) return showToast('Primero crea un semestre', 'error');
        document.getElementById('input-bulk-text').value = '';
        
        // Reset to Step 1
        document.getElementById('import-step-input').style.display = '';
        document.getElementById('import-step-preview').style.display = 'none';
        document.getElementById('btn-preview-import').style.display = '';
        document.getElementById('btn-do-import').style.display = 'none';
        this.parsedSubjects = [];

        const fileInput = document.getElementById('input-bulk-file');
        const fileNameDisplay = document.getElementById('bulk-file-name');
        if (fileInput) {
            fileInput.value = '';
            fileNameDisplay.textContent = '';
            
            if (!fileInput.dataset.bound) {
                fileInput.addEventListener('change', function(e) {
                    const file = e.target.files[0];
                    if (!file) return;
                    fileNameDisplay.textContent = `Archivo seleccionado: ${file.name}`;
                    const reader = new FileReader();
                    reader.onload = function(evt) {
                        document.getElementById('input-bulk-text').value = evt.target.result;
                    };
                    reader.onerror = function() {
                        showToast('Error al leer el archivo CSV', 'error');
                    };
                    reader.readAsText(file);
                });
                fileInput.dataset.bound = 'true';
            }
        }

        // Bind preview button (once)
        if (!document.getElementById('btn-preview-import').dataset.bound) {
            document.getElementById('btn-preview-import').addEventListener('click', () => this.showImportPreview());
            document.getElementById('btn-back-to-input').addEventListener('click', () => {
                document.getElementById('import-step-input').style.display = '';
                document.getElementById('import-step-preview').style.display = 'none';
                document.getElementById('btn-preview-import').style.display = '';
                document.getElementById('btn-do-import').style.display = 'none';
            });
            document.getElementById('btn-preview-import').dataset.bound = 'true';
        }
        
        this.open('modal-bulk-import');
    },

    // Proper CSV line parser that respects quoted fields
    parseCSVLine(line) {
        const fields = [];
        let current = '';
        let inQuotes = false;
        for (let i = 0; i < line.length; i++) {
            const ch = line[i];
            if (inQuotes) {
                if (ch === '"' && line[i + 1] === '"') {
                    current += '"';
                    i++; // skip escaped quote
                } else if (ch === '"') {
                    inQuotes = false;
                } else {
                    current += ch;
                }
            } else {
                if (ch === '"') {
                    inQuotes = true;
                } else if (ch === ',') {
                    fields.push(current.trim());
                    current = '';
                } else {
                    current += ch;
                }
            }
        }
        fields.push(current.trim());
        return fields;
    },

    parseBulkText(text) {
        text = text.replace(/\r\n/g, '\n').replace(/\r/g, '\n');

        const lines = text.split('\n').filter(l => {
            const t = l.trim().toLowerCase();
            return t && !t.startsWith('codigo') && !t.startsWith('código') && !t.startsWith('materia') && !t.startsWith('code');
        });

        const subjects = [];
        const seen = new Set();

        for (const line of lines) {
            let code = '', name = '', subject_type = 'Teórica';

            if (line.includes('\t')) {
                const parts = line.split('\t').map(p => p.trim());
                code = parts[0] || '';
                name = parts[1] || '';
                if (parts[2]) subject_type = parts[2];
            } else if (line.includes(',')) {
                const parts = this.parseCSVLine(line);
                code = parts[0] || '';
                name = parts[1] || '';
                if (parts[2]) subject_type = parts[2];
            } else {
                const trimmed = line.trim();
                const match = trimmed.match(/^([A-Za-z\.\s]+-?\s*\d+)\s+(.+)$/);
                if (match) {
                    code = match[1];
                    name = match[2];
                } else {
                    continue;
                }
            }

            if (!code || !name) continue;

            // Normalize type
            const typeNorm = subject_type.toLowerCase().trim();
            if (typeNorm.includes('numérica') || typeNorm.includes('numerica')) {
                subject_type = 'Numérica';
            } else if (typeNorm.includes('integrador')) {
                subject_type = 'Proyecto Integrador';
            } else if (typeNorm.includes('p.')) {
                subject_type = 'Proyecto Integrador';
            } else {
                subject_type = 'Teórica';
            }

            // Normalize code: remove spaces and dots before dash, uppercase
            const normalizedCode = code.replace(/[\s\.]+/g, '').replace(/(\w+)\s*-\s*(\d+)/, '$1-$2').toUpperCase().trim();

            // Deduplicate by normalized code+name (case-insensitive)
            const key = (normalizedCode + '|' + name.trim()).toUpperCase();
            if (seen.has(key)) continue;
            seen.add(key);

            subjects.push({ code: normalizedCode, name: name.trim(), subject_type, checked: true });
        }

        return subjects;
    },

    async showImportPreview() {
        const text = document.getElementById('input-bulk-text').value.trim();
        if (!text) return showToast('Pega la lista de materias o sube un CSV', 'error');

        const subjects = this.parseBulkText(text);
        if (subjects.length === 0) return showToast('No se pudieron parsear las materias', 'error');

        // Check for existing subjects in this semester
        const existing = await API.get(`/subjects?semester_id=${App.activeSemester.id}`);
        const existingKeys = new Set(existing.map(s => (s.code + '|' + s.name).toUpperCase()));

        let dupCount = 0;
        for (const s of subjects) {
            const key = (s.code + '|' + s.name).toUpperCase();
            if (existingKeys.has(key)) {
                s.isDuplicate = true;
                s.checked = false;
                dupCount++;
            }
        }

        this.parsedSubjects = subjects;

        // Render preview table
        const typeColors = {
            'Teórica':   { bg: 'rgba(96,165,250,0.15)', color: '#60a5fa' },
            'Numérica':  { bg: 'rgba(52,211,153,0.15)', color: '#34d399' },
            'Proyecto Integrador': { bg: 'rgba(167,139,250,0.15)', color: '#a78bfa' }
        };

        let tableHTML = `<table style="width:100%;border-collapse:collapse;font-size:13px;">
            <thead>
                <tr style="background:var(--bg-secondary);position:sticky;top:0;z-index:1;">
                    <th style="padding:8px 10px;text-align:center;width:40px;">
                        <input type="checkbox" id="import-check-all" checked style="accent-color:var(--accent);" onchange="Modals.toggleAllImportChecks(this.checked)">
                    </th>
                    <th style="padding:8px 10px;text-align:left;font-weight:600;color:var(--text-secondary);">Código</th>
                    <th style="padding:8px 10px;text-align:left;font-weight:600;color:var(--text-secondary);">Materia</th>
                    <th style="padding:8px 10px;text-align:left;font-weight:600;color:var(--text-secondary);">Tipo</th>
                    <th style="padding:8px 10px;text-align:center;font-weight:600;color:var(--text-secondary);width:80px;">Estado</th>
                </tr>
            </thead>
            <tbody>`;

        subjects.forEach((s, i) => {
            const tc = typeColors[s.subject_type] || typeColors['Teórica'];
            const rowBg = s.isDuplicate ? 'rgba(251,191,36,0.05)' : '';
            tableHTML += `<tr style="border-bottom:1px solid var(--border-light);background:${rowBg};" data-idx="${i}">
                <td style="padding:6px 10px;text-align:center;">
                    <input type="checkbox" class="import-row-check" data-idx="${i}" ${s.checked ? 'checked' : ''} style="accent-color:var(--accent);" onchange="Modals.toggleImportCheck(${i}, this.checked)">
                </td>
                <td style="padding:6px 10px;font-family:'JetBrains Mono',monospace;font-size:12px;color:var(--accent);">${s.code}</td>
                <td style="padding:6px 10px;color:var(--text-primary);">${s.name}</td>
                <td style="padding:6px 10px;">
                    <span style="background:${tc.bg};color:${tc.color};font-size:10px;padding:2px 8px;border-radius:4px;font-weight:600;">${s.subject_type}</span>
                </td>
                <td style="padding:6px 10px;text-align:center;">
                    ${s.isDuplicate 
                        ? '<span style="background:rgba(251,191,36,0.15);color:#fbbf24;font-size:10px;padding:2px 8px;border-radius:4px;font-weight:600;">Ya existe</span>' 
                        : '<span style="background:rgba(52,211,153,0.15);color:#34d399;font-size:10px;padding:2px 8px;border-radius:4px;font-weight:600;">Nueva</span>'}
                </td>
            </tr>`;
        });

        tableHTML += '</tbody></table>';

        document.getElementById('import-preview-table').innerHTML = tableHTML;
        document.getElementById('preview-count-label').textContent = `${subjects.length} materias detectadas`;
        document.getElementById('preview-dup-label').textContent = dupCount > 0 ? `${dupCount} ya existen en el semestre` : '';

        // Switch to Step 2
        document.getElementById('import-step-input').style.display = 'none';
        document.getElementById('import-step-preview').style.display = '';
        document.getElementById('btn-preview-import').style.display = 'none';
        document.getElementById('btn-do-import').style.display = '';

        this.updateImportButtonCount();
    },

    toggleAllImportChecks(checked) {
        this.parsedSubjects.forEach(s => s.checked = checked);
        document.querySelectorAll('.import-row-check').forEach(cb => cb.checked = checked);
        this.updateImportButtonCount();
    },

    toggleImportCheck(idx, checked) {
        this.parsedSubjects[idx].checked = checked;
        this.updateImportButtonCount();
    },

    updateImportButtonCount() {
        const count = this.parsedSubjects.filter(s => s.checked).length;
        const btn = document.getElementById('btn-do-import');
        btn.innerHTML = `<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg> Importar ${count} materias`;
    },

    async doBulkImport() {
        const subjects = this.parsedSubjects.filter(s => s.checked);
        if (subjects.length === 0) return showToast('Selecciona al menos una materia', 'error');

        const replace = document.getElementById('import-replace-mode').checked;

        const result = await API.post('/subjects/bulk', {
            subjects: subjects.map(s => ({ code: s.code, name: s.name, subject_type: s.subject_type })),
            semester_id: App.activeSemester.id,
            replace
        });
        const results = result.results || result;
        const successCount = Array.isArray(results) ? results.filter(r => r.success || !r.error).length : 0;
        const skippedCount = Array.isArray(results) ? results.filter(r => r.skipped).length : 0;
        const deletedCount = result.deleted || 0;

        let msg = '';
        if (deletedCount > 0) msg += `${deletedCount} anteriores borradas · `;
        msg += `${successCount} importadas`;
        if (skippedCount > 0) msg += ` · ${skippedCount} omitidas (duplicadas)`;
        showToast(msg, 'success');
        this.closeAll();
        Goals.refresh();
        Dashboard.refresh();
    },

    pendingTeacherId: null, // Track which agenda teacher we're scheduling

    checkFlightTicketVisibility() {
        const sede = document.getElementById('input-assignment-sede').value;
        const container = document.getElementById('flight-ticket-container');
        if (container) {
            if (sede && sede !== 'La Paz' && sede !== 'El Alto') {
                container.style.display = '';
            } else {
                container.style.display = 'none';
            }
        }
    },

    async openNewAssignment(prefillData = null) {
        if (!App.activeSemester) return showToast('Primero crea un semestre', 'error');
        
        this.pendingTeacherId = prefillData?.pendingTeacherId || null;

        // Reset form
        document.getElementById('input-teacher-name').value = prefillData?.teacher_name || '';
        document.getElementById('input-teacher-phone').value = prefillData?.phone || '';
        document.getElementById('input-drive-link').value = '';
        document.getElementById('input-script-status').value = 'not_uploaded';
        document.getElementById('input-session-hito').value = '';
        document.getElementById('input-assigned-staff').value = '';
        if (document.getElementById('input-assigned-staff-2')) {
            document.getElementById('input-assigned-staff-2').value = '';
        }

        document.getElementById('input-assignment-sede').value = prefillData?.sede || 'La Paz';
        document.getElementById('input-flight-ticket').value = '';
        document.getElementById('input-flight-ticket-path').value = '';
        document.getElementById('btn-view-flight-ticket').style.display = 'none';
        this.checkFlightTicketVisibility();

        // Load subjects into dropdown
        const subjects = await API.get(`/subjects?semester_id=${App.activeSemester.id}`);
        const select = document.getElementById('input-assignment-subject');
        select.innerHTML = '<option value="">Seleccionar materia...</option>';
        subjects.filter(s => !s.completed).forEach(s => {
            const typeLabel = s.subject_type ? ` [${s.subject_type}]` : '';
            select.innerHTML += `<option value="${s.id}">${s.code} — ${s.name}${typeLabel}</option>`;
        });

        // Pre-select subject if provided
        if (prefillData?.subject_id) {
            select.value = prefillData.subject_id;
        }

        // Load pending teachers (always show this section)
        const pendingTeachers = await API.get('/pending-teachers?resolved=1');
        Modals.pendingTeachersData = pendingTeachers;
        const ptSelect = document.getElementById('input-select-pending');
        const ptRow = document.getElementById('row-select-pending');
        ptSelect.innerHTML = '<option value="">-- Ingreso manual --</option>';
        pendingTeachers.filter(t => !t.status || t.status === 'pending' || t.status === 'contacted' || t.status === 'guion_revisado').forEach(t => {
            const typeTag = t.subject_type ? ` · ${t.subject_type}` : '';
            ptSelect.innerHTML += `<option value="${t.id}">${t.name} — ${t.subject_code || ''} ${t.subject}${typeTag}</option>`;
        });
        ptRow.style.display = ''; // always visible
        
        // If coming from agenda, pre-select the pending teacher
        if (this.pendingTeacherId) {
            ptSelect.value = this.pendingTeacherId;
        }

        // Load post-production users into "Asignado a"
        const staffUsers = await API.get('/staff', true);
        const staffSelect = document.getElementById('input-assigned-staff');
        const staff2Select = document.getElementById('input-assigned-staff-2');
        staffSelect.innerHTML = '<option value="">-- Sin asignar --</option>';
        staff2Select.innerHTML = '<option value="">-- Ninguno --</option>';
        if (Array.isArray(staffUsers)) {
            staffUsers.forEach(u => {
                staffSelect.innerHTML += `<option value="${u.id}">${u.name || u.username}</option>`;
                staff2Select.innerHTML += `<option value="${u.id}">${u.name || u.username}</option>`;
            });
        }

        // Set default date to today
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('input-session-date').value = today;

        // Reset second session block
        const s2block = document.getElementById('session-2-block');
        if (s2block) s2block.style.display = 'none';
        const s2date = document.getElementById('input-session2-date');
        if (s2date) s2date.value = '';
        const s2start = document.getElementById('input-session2-start');
        if (s2start) s2start.value = '08:00';
        const s2end = document.getElementById('input-session2-end');
        if (s2end) s2end.value = '10:00';
        const s2hito = document.getElementById('input-session2-hito');
        if (s2hito) s2hito.value = '';

        document.getElementById('modal-assignment-title').textContent = this.pendingTeacherId ? 'Agendar Filmación desde Agenda' : 'Nueva Filmación';
        this.open('modal-assignment');
    },

    toggleSecondSession() {
        const block = document.getElementById('session-2-block');
        if (!block) return;
        const isHidden = block.style.display === 'none';
        block.style.display = isHidden ? '' : 'none';
        if (isHidden) {
            // Pre-fill next day
            const d1 = document.getElementById('input-session-date').value;
            if (d1) {
                const next = new Date(d1 + 'T12:00:00');
                next.setDate(next.getDate() + 1);
                document.getElementById('input-session2-date').value = next.toISOString().split('T')[0];
            }
            document.getElementById('input-session2-start').value = document.getElementById('input-session-start').value || '08:00';
            document.getElementById('input-session2-end').value = document.getElementById('input-session-end').value || '10:00';
        }
    },

    async saveAssignment() {
        const teacher_name = document.getElementById('input-teacher-name').value.trim();
        const phone = document.getElementById('input-teacher-phone').value.trim();
        const subject_id = document.getElementById('input-assignment-subject').value;
        const drive_link = document.getElementById('input-drive-link')?.value.trim();
        const script_status = document.getElementById('input-script-status').value;
        const sede = document.getElementById('input-assignment-sede').value;

        if (!teacher_name || !subject_id) return showToast('Nombre del docente y materia son requeridos', 'error');

        let flight_ticket_path = null;
        const ticketFile = document.getElementById('input-flight-ticket').files[0];
        if (ticketFile) {
            const formData = new FormData();
            formData.append('file', ticketFile);
            const uploadRes = await fetch(`/api/uploads/ticket?token=${encodeURIComponent(localStorage.getItem('edtech_token'))}`, {
                method: 'POST',
                body: formData
            }).then(r => r.json()).catch(() => ({ error: 'Fallo al subir el archivo' }));
            
            if (uploadRes.error) return showToast(uploadRes.error, 'error');
            flight_ticket_path = uploadRes.path;
        } else if (this._existingTicketPath) {
            // Inherit ticket from pending teacher agenda
            flight_ticket_path = this._existingTicketPath;
        }

        const session_date = document.getElementById('input-session-date').value;
        const start_time = document.getElementById('input-session-start').value;
        const end_time = document.getElementById('input-session-end').value;
        const hito_reached = document.getElementById('input-session-hito').value;

        const session = (session_date && start_time && end_time) ? { session_date, start_time, end_time, hito_reached } : null;

        const pending_teacher_id = this.pendingTeacherId || document.getElementById('input-select-pending')?.value || null;
        const staff_2_id = document.getElementById('input-assigned-staff-2')?.value || null;
        const result = await API.post('/assignments', { teacher_name, phone, subject_id, drive_link, script_status, session, pending_teacher_id, staff_2_id, sede, flight_ticket_path });
        if (result.error) return showToast(result.error, 'error');

        // Save second session if provided
        const s2block = document.getElementById('session-2-block');
        if (s2block && s2block.style.display !== 'none') {
            const session2_date = document.getElementById('input-session2-date').value;
            const session2_start = document.getElementById('input-session2-start').value;
            const session2_end = document.getElementById('input-session2-end').value;
            const session2_hito = document.getElementById('input-session2-hito').value;
            if (session2_date && session2_start && session2_end) {
                const staff1Val = document.getElementById('input-assigned-staff')?.value || null;
                const staff2Val = document.getElementById('input-assigned-staff-2')?.value || null;
                const s2res = await API.post('/sessions', {
                    assignment_id: result.id,
                    session_date: session2_date,
                    start_time: session2_start,
                    end_time: session2_end,
                    hito_reached: session2_hito,
                    staff_1_id: staff1Val,
                    staff_2_id: staff2Val
                });
                if (s2res.error) showToast(`2ª sesión: ${s2res.error}`, 'error');
            }
        }

        // Update the pending teacher status to 'scheduled'
        const pendingId = this.pendingTeacherId || document.getElementById('input-select-pending')?.value;
        if (pendingId) {
            await API.put(`/pending-teachers/${pendingId}`, { status: 'scheduled', resolved: 0 });
            if (typeof PendingTeachers !== 'undefined') {
                PendingTeachers.refresh();
            }
        }
        this.pendingTeacherId = null;

        showToast('Filmación creada exitosamente', 'success');
        this.closeAll();
        Calendar.render();
        Dashboard.refresh();
        if (App.currentView === 'goals') Goals.refresh();
    },

    currentReservationId: null,

    async openNewReservation() {
        if (!App.activeSemester) return showToast('Primero crea un semestre', 'error');
        this.currentReservationId = null;

        // Set default date to today
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('input-res-date').value = today;
        document.getElementById('input-res-end-date').value = today;
        document.getElementById('input-res-end-date').parentElement.style.display = 'block'; // Show end date for new
        document.getElementById('input-res-start').value = '08:00';
        document.getElementById('input-res-end').value = '10:00';
        document.getElementById('input-res-reason').value = '';
        
        document.querySelector('#modal-reservation h3').textContent = 'Nueva Reserva';

        // Load staff and reset attendees
        Calendar._staffUsers = await API.get('/staff');
        document.getElementById('attendees-list').innerHTML = '';

        this.open('modal-reservation');
    },

    async openEditReservation(r) {
        this.currentReservationId = r.id;
        
        document.getElementById('input-res-date').value = r.date;
        document.getElementById('input-res-end-date').value = r.date;
        document.getElementById('input-res-end-date').parentElement.style.display = 'none'; // Hide end date for edit
        document.getElementById('input-res-start').value = r.start_time.substring(0, 5);
        document.getElementById('input-res-end').value = r.end_time.substring(0, 5);
        document.getElementById('input-res-reason').value = r.reason;
        
        document.querySelector('#modal-reservation h3').textContent = 'Editar Reserva';
        
        // Load staff then populate attendees
        Calendar._staffUsers = await API.get('/staff');
        const attendeesList = document.getElementById('attendees-list');
        attendeesList.innerHTML = '';
        let existingAttendees = [];
        if (r.attendees) {
            try { existingAttendees = typeof r.attendees === 'string' ? JSON.parse(r.attendees) : r.attendees; } catch(e) {}
        }
        existingAttendees.forEach(a => Calendar.addAttendeeField(a));
        
        this.open('modal-reservation');
    },

    async saveReservation() {
        const start_date = document.getElementById('input-res-date').value;
        const end_date = document.getElementById('input-res-end-date').value;
        const start_time = document.getElementById('input-res-start').value;
        const end_time = document.getElementById('input-res-end').value;
        const reason = document.getElementById('input-res-reason').value.trim();

        if (!start_date || !start_time || !end_time || !reason) return showToast('Todos los campos son obligatorios', 'error');

        // Collect attendees
        const attendees = Array.from(document.querySelectorAll('#attendees-list .attendee-input'))
            .map(i => i.value.trim()).filter(Boolean);

        let result;
        if (this.currentReservationId) {
            result = await API.put(`/reservations/${this.currentReservationId}`, { start_date, start_time, end_time, reason, attendees: JSON.stringify(attendees) });
        } else {
            if (!end_date) return showToast('La fecha final es obligatoria', 'error');
            if (new Date(start_date) > new Date(end_date)) return showToast('Fecha fin no puede ser menor a fecha inicio', 'error');
            result = await API.post('/reservations', { start_date, end_date, start_time, end_time, reason, attendees: JSON.stringify(attendees) });
        }
        
        if (result.error) return showToast(result.error, 'error');

        showToast('Reserva guardada', 'success');
        this.closeAll();
        Calendar.render();
    },

    // ===== CLOSE WEEK =====

    openCloseWeek() {
        // Default to next Monday
        const now = new Date();
        const day = now.getDay();
        const diff = day === 0 ? 1 : (8 - day);
        const nextMon = new Date(now);
        nextMon.setDate(now.getDate() + diff);
        document.getElementById('input-close-week-date').value = nextMon.toISOString().split('T')[0];
        document.getElementById('input-close-week-reason').value = 'Estudio cerrado';
        this.open('modal-close-week');
    },

    async doCloseWeek() {
        const week_start = document.getElementById('input-close-week-date').value;
        const reason = document.getElementById('input-close-week-reason').value.trim();
        if (!week_start) return showToast('Selecciona la fecha', 'error');

        const result = await API.post('/closed-weeks', { week_start, reason });
        if (result.error) return showToast(result.error, 'error');

        showToast('Semana cerrada', 'success');
        this.closeAll();
        Calendar.render();
    },

    // ===== ASSIGNMENT DETAIL =====

    async showAssignmentDetail(assignmentId) {
        this.currentAssignmentId = assignmentId;
        const data = await API.get(`/assignments/${assignmentId}`);
        if (data.error) return showToast(data.error, 'error');

        document.getElementById('detail-title').textContent = `${data.subject_code} — ${data.subject_name}`;

        const scriptClass = `script-${data.script_status}`;
        const scriptText = SCRIPT_LABELS[data.script_status] || data.script_status;

        let html = `<div class="detail-grid">
            <div class="detail-field">
                <div class="detail-field-label">Docente</div>
                <div class="detail-field-value">${data.teacher_name}</div>
            </div>
            <div class="detail-field">
                <div class="detail-field-label">Teléfono</div>
                <div class="detail-field-value">${data.phone || '—'}</div>
            </div>
            <div class="detail-field">
                <div class="detail-field-label">Sede / Ciudad</div>
                <div class="detail-field-value">${data.sede || 'La Paz'}</div>
            </div>
            <div class="detail-field" style="${(data.sede && data.sede !== 'La Paz' && data.sede !== 'El Alto') ? '' : 'display:none;'}">
                <div class="detail-field-label">Pasaje de Vuelo</div>
                <div class="detail-field-value">${data.flight_ticket_path ? `<a href="/api${data.flight_ticket_path}" target="_blank" class="btn-sm btn-outline">📄 Ver PDF</a>` : '<span style="color:var(--text-muted)">No subido</span>'}</div>
            </div>
            <div class="detail-field">
                <div class="detail-field-label">Estado del Guión</div>
            <div class="detail-field-value"><span class="script-badge" style="background:${(SCRIPT_COLORS[data.script_status]||SCRIPT_COLORS['not_uploaded']).bg};color:${(SCRIPT_COLORS[data.script_status]||SCRIPT_COLORS['not_uploaded']).color};padding:4px 10px;border-radius:4px;font-size:12px;font-weight:600;">${scriptText}</span></div>
            </div>
            <div class="detail-field">
                <div class="detail-field-label">Link del Guión</div>
                <div class="detail-field-value">${data.drive_link ? `<a href="${data.drive_link}" target="_blank">Abrir en Drive ↗</a>` : '—'}</div>
            </div>
            <div class="detail-field">
                <div class="detail-field-label">Último Hito</div>
                <div class="detail-field-value">${data.last_hito_reached ? HITO_LABELS[data.last_hito_reached] : 'Sin registrar'}</div>
            </div>
            <div class="detail-field">
                <div class="detail-field-label">Estado</div>
                <div class="detail-field-value">${data.status === 'completed' ? '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="vertical-align: middle; margin-right: 4px;"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg> Completada' : data.status === 'cancelled' ? '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="vertical-align: middle; margin-right: 4px;"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg> Cancelada' : '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="vertical-align: middle; margin-right: 4px;"><polyline points="23 4 23 10 17 10"/><path d="M20.49 15a9 9 0 1 1-2.12-9.36L23 10"/></svg> En progreso'}</div>
            </div>
        </div>`;

        const canEdit = App.user && ['admin', 'post_productor'].includes(App.user.role);

        // Whatsapp Templates Dropdown (admin/post only)
        const cleanPhone = data.phone ? data.phone.replace(/[^0-9]/g, '') : '';
        const safeTeacherName = (data.teacher_name || '').replace(/'/g, "\\'");
        const safeSubject = (data.subject_name || '').replace(/'/g, "\\'");
        const safeSede = (data.sede || 'La Paz');
        const whatsappHtml = (canEdit && cleanPhone) ? `
        <div class="divider"></div>
        <div class="detail-edit-row" style="align-items:center;">
            <label style="font-size:12px;font-weight:600;color:var(--text-secondary);white-space:nowrap;">Plantillas WhatsApp:</label>
            <select class="input select" id="wa-template-select" style="max-width:240px; margin-right:8px;">
                <option value="">-- Seleccionar Plantilla --</option>
                <option value="coordinacion">Coordinación de Fechas</option>
                <option value="confirmacion">Confirmación de Reserva</option>
                <option value="recordatorio">Recordatorio de Filmación</option>
            </select>
            <button class="btn-sm btn-success" onclick="Modals.sendWhatsappTemplate('${cleanPhone}', '${safeTeacherName}', '${safeSubject}', '${safeSede}')" style="display:inline-flex; align-items:center; gap:4px; height: 32px; padding: 0 12px;">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8v.5z"/></svg>
                Enviar
            </button>
        </div>` : '';

        // Edit section — editable for admin/post, read-only for academica
        if (canEdit) {
            html += `<div class="divider"></div>
            <div class="detail-edit-row">
                <label style="font-size:12px;font-weight:600;color:var(--text-secondary);white-space:nowrap;">Guión:</label>
                <select class="input select" onchange="Modals.updateAssignmentField('script_status', this.value)" style="max-width:240px;">
                    <option value="not_uploaded" ${data.script_status==='not_uploaded'?'selected':''}>Sin Guión</option>
                    <option value="guion_pendiente" ${data.script_status==='guion_pendiente'?'selected':''}>GUION PENDIENTE</option>
                    <option value="uploaded_hito_v" ${data.script_status==='uploaded_hito_v'?'selected':''}>Cargado (Hito V)</option>
                    <option value="pending_review" ${data.script_status==='pending_review'?'selected':''}>Pendiente de Revisión</option>
                    <option value="in_review" ${data.script_status==='in_review'?'selected':''}>En Revisión</option>
                    <option value="needs_corrections" ${data.script_status==='needs_corrections'?'selected':''}>Requiere Correcciones</option>
                    <option value="approved" ${data.script_status==='approved'?'selected':''}>Revisado ✓</option>
                </select>
                <input type="url" class="input" placeholder="Link de Drive" value="${data.drive_link || ''}" onchange="Modals.updateAssignmentField('drive_link', this.value)" style="max-width:300px;">
            </div>
            ${whatsappHtml}`;
        }

        // Sessions list
        html += `<div class="divider"></div>
        <div class="detail-sessions-title">Sesiones de Grabación (${data.sessions?.length || 0})</div>`;

        if (data.sessions && data.sessions.length > 0) {
            for (const s of data.sessions) {
                const hitoClass = s.hito_reached ? `hito-${s.hito_reached}` : '';
                const hitoText = s.hito_reached ? HITO_LABELS[s.hito_reached] : '';
                const dateParts = s.session_date.split('-');
                const dateF = `${dateParts[2]}/${dateParts[1]}/${dateParts[0]}`;
                html += `<div class="detail-session">
                    <span class="detail-session-date">${dateF}</span>
                    <span class="detail-session-time">${s.start_time?.substring(0,5)} - ${s.end_time?.substring(0,5)}</span>
                    ${hitoText ? `<span class="detail-session-hito ${hitoClass}">${hitoText}</span>` : ''}
                    <span class="detail-session-notes">
                        ${s.staff_1_name ? `<span style="display:inline-block; margin-right:8px; padding:2px 6px; background:var(--bg-tertiary); border-radius:4px; font-size:11px; color:var(--text-secondary);"><svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="vertical-align:-1px; margin-right:3px;"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>${s.staff_1_name}${s.staff_2_name ? ` + ${s.staff_2_name}` : ''}</span>` : ''}
                        ${s.notes || ''}
                    </span>
                    <div style="display:flex;gap:4px;">
                        ${App.user && ['admin','post_productor'].includes(App.user.role) ? `<button class="btn-icon" onclick="Modals.openEditSession(${s.id}, '${s.session_date}', '${s.start_time?.substring(0,5)}', '${s.end_time?.substring(0,5)}', '${s.hito_reached||''}', \`${(s.notes||'').replace(/`/g,"'").replace(/"/g,'&quot;')}\`)" title="Editar sesión" style="color:var(--accent);">
                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 3a2.828 2.828 0 1 1 4 4L7.5 20.5 2 22l1.5-5.5L17 3z"/></svg>
                        </button>` : ''}
                        <button class="btn-icon" onclick="Modals.deleteSession(${s.id})" title="Eliminar sesión">
                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                        </button>
                    </div>
                </div>`;
            }
        } else {
            html += '<p style="color:var(--text-muted);font-size:13px;">No hay sesiones registradas</p>';
        }

        document.getElementById('detail-body').innerHTML = html;

        // Show/hide footer action buttons based on role
        const addSessionBtn = document.getElementById('btn-detail-add-session');
        const completeBtn = document.getElementById('btn-detail-complete');
        const isCanEdit = App.user && ['admin', 'post_productor'].includes(App.user.role);

        addSessionBtn.style.display = isCanEdit ? '' : 'none';
        completeBtn.style.display = (isCanEdit && data.status === 'in_progress') ? '' : 'none';

        this.open('modal-detail');
    },

    async updateAssignmentField(field, value) {
        if (!this.currentAssignmentId) return;
        await API.put(`/assignments/${this.currentAssignmentId}`, { [field]: value });
        showToast('Actualizado', 'success');
        // Refresh detail without closing
        this.showAssignmentDetail(this.currentAssignmentId);
    },

    async deleteSession(sessionId) {
        Calendar.showConfirm({
            title: 'Eliminar Sesión',
            message: '¿Eliminar esta sesión de grabación?'
        }, async () => {
            await API.del(`/sessions/${sessionId}`);
            showToast('Sesión eliminada', 'success');
            this.showAssignmentDetail(this.currentAssignmentId);
            Calendar.render();
        });
    },

    // ===== EDIT SESSION =====

    _editingSessionId: null,

    openEditSession(id, date, start, end, hito, notes) {
        this._editingSessionId = id;
        document.getElementById('input-edit-session-date').value = date || '';
        document.getElementById('input-edit-session-start').value = start || '08:00';
        document.getElementById('input-edit-session-end').value = end || '10:00';
        document.getElementById('input-edit-session-hito').value = hito || '';
        document.getElementById('input-edit-session-notes').value = notes || '';
        // Close detail and open edit session modal
        document.querySelectorAll('.modal.active').forEach(m => m.classList.remove('active'));
        this.open('modal-edit-session');
    },

    async saveEditSession() {
        if (!this._editingSessionId) return;
        const session_date = document.getElementById('input-edit-session-date').value;
        const start_time   = document.getElementById('input-edit-session-start').value;
        const end_time     = document.getElementById('input-edit-session-end').value;
        const hito_reached = document.getElementById('input-edit-session-hito').value;
        const notes        = document.getElementById('input-edit-session-notes').value.trim();

        if (!session_date || !start_time || !end_time) return showToast('Completa fecha y horario', 'error');

        const result = await API.put(`/sessions/${this._editingSessionId}`, { session_date, start_time, end_time, hito_reached, notes });
        if (result.error) return showToast(result.error, 'error');

        showToast('Sesión actualizada', 'success');
        this.closeAll();
        Calendar.render();
        this.showAssignmentDetail(this.currentAssignmentId);
    },

    sendWhatsappTemplate(phone, teacherName, subject, sede) {
        const select = document.getElementById('wa-template-select');
        const templateId = select.value;
        if (!templateId) return showToast('Selecciona una plantilla', 'error');

        let message = '';
        if (templateId === 'coordinacion') {
            message = `Hola ${teacherName}, le escribimos del Estudio de Filmación EDTECH respecto a la materia ${subject}. ¿Podríamos coordinar las fechas de grabación en ${sede}?`;
        } else if (templateId === 'confirmacion') {
            message = `Hola ${teacherName}, le confirmo que se han reservado los días y horas para la grabación de la materia ${subject} en el estudio de ${sede}.`;
        } else if (templateId === 'recordatorio') {
            message = `Hola ${teacherName}, le recordamos que el día de mañana tiene agendada una sesión de grabación para la materia ${subject} en ${sede}. ¡Le esperamos!`;
        }

        const url = `https://wa.me/${phone}?text=${encodeURIComponent(message)}`;
        window.open(url, '_blank');
        
        // As requested by user earlier, might be helpful to update status
        if (templateId === 'coordinacion' || templateId === 'confirmacion') {
            this.updateAssignmentField('status', 'in_progress'); 
        }
    },

    async markComplete() {
        if (!this.currentAssignmentId) return;
        Calendar.showConfirm({
            title: 'Completar Filmación',
            message: '¿Marcar esta filmación como completada?',
            okLabel: 'Completar'
        }, async () => {
            await API.put(`/assignments/${this.currentAssignmentId}`, { status: 'completed' });
            showToast('Filmación marcada como completada', 'success');
            this.closeAll();
            Calendar.render();
            Dashboard.refresh();
            if (App.currentView === 'goals') Goals.refresh();
        });
    },

    // ===== ADD SESSION (to existing) =====

    async openAddSession() {
        if (!this.currentAssignmentId) return;
        // Pre-fill context
        const title = document.getElementById('detail-title').textContent;
        document.getElementById('session-context').innerHTML = `
            <div class="session-context-teacher">${title}</div>
        `;
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('input-new-session-date').value = today;
        document.getElementById('input-new-session-hito').value = '';
        document.getElementById('input-new-session-notes').value = '';

        // Load staff
        const s1 = document.getElementById('input-new-session-staff-1');
        const s2 = document.getElementById('input-new-session-staff-2');
        const staff = await API.get('/staff');
        s1.innerHTML = '<option value="">Seleccionar...</option>';
        s2.innerHTML = '<option value="">Ninguno</option>';
        staff.forEach(u => {
            s1.innerHTML += `<option value="${u.id}">${u.name}</option>`;
            s2.innerHTML += `<option value="${u.id}">${u.name}</option>`;
        });

        this.closeAll();
        this.open('modal-add-session');
    },

    async saveNewSession() {
        const assignment_id = this.currentAssignmentId;
        const session_date = document.getElementById('input-new-session-date').value;
        const start_time = document.getElementById('input-new-session-start').value;
        const end_time = document.getElementById('input-new-session-end').value;
        const hito_reached = document.getElementById('input-new-session-hito').value;
        const notes = document.getElementById('input-new-session-notes').value.trim();
        const staff_1_id = document.getElementById('input-new-session-staff-1').value;
        const staff_2_id = document.getElementById('input-new-session-staff-2').value;

        if (!session_date || !start_time || !end_time) return showToast('Completa fecha y horario', 'error');

        const result = await API.post('/sessions', { assignment_id, session_date, start_time, end_time, hito_reached, notes, staff_1_id, staff_2_id });
        if (result.error) return showToast(result.error, 'error');

        showToast('Sesión agregada', 'success');
        this.closeAll();
        Calendar.render();
        Dashboard.refresh();
        if (App.currentView === 'goals') Goals.refresh();
    }
};
