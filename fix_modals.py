import re

with open('public/js/modals.js', 'r') as f:
    content = f.read()

# Fix saveSubject which was corrupted
save_subject_corrupted = """    async saveSubject() {
        const name = document.getElementById('input-subject-name').value.trim();
        const subject_type = document.getElementById('input-subject-type-select')?.value || 'Teórica';
        if (!name) return showToast('Ingresa el nombre o materia', 'error');
        const res = await API.post('/subjects/bulk', { subjects, semester_id: App.activeSemester.id });
        if (res.error) return showToast(res.error, 'error');
        let msg = '';
        if (res.results) msg += `${res.results} agregadas. `;
        if (res.deleted) msg += `${res.deleted} borradas (reemplazo).`;
    },"""

save_subject_fixed = """    async saveSubject() {
        const name = document.getElementById('input-subject-name').value.trim();
        const subject_type = document.getElementById('input-subject-type-select')?.value || 'Teórica';
        if (!name) return showToast('Ingresa el nombre o materia', 'error');
        const result = await API.post('/subjects', { name, subject_type, semester_id: App.activeSemester.id });
        if (result.error) return showToast(result.error, 'error');
        showToast(`Materia agregada`, 'success');
        this.closeAll();
        Goals.refresh();
        Dashboard.refresh();
    },"""

content = content.replace(save_subject_corrupted, save_subject_fixed)

# Remove checkmark
content = content.replace("let msg = '✅ ';", "let msg = '';")

with open('public/js/modals.js', 'w') as f:
    f.write(content)

