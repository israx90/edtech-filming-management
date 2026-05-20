const express = require('express');
const path = require('path');
const { getDb, closeDb } = require('./db/database');
const apiRoutes = require('./routes/api');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

// Init DB then mount routes
async function start() {
    await getDb();

    app.use('/api', apiRoutes);

    app.get('*', (req, res) => {
        res.sendFile(path.join(__dirname, 'public', 'index.html'));
    });

    const server = app.listen(PORT, () => {
        console.log(`\n🎞️  ESTUDIO DE FILMACIÓN EDTECH`);
        console.log(`   http://localhost:${PORT}\n`);
    });

    process.on('SIGINT', () => { closeDb(); server.close(() => process.exit(0)); });
    process.on('SIGTERM', () => { closeDb(); server.close(() => process.exit(0)); });
}

start().catch(err => { console.error('Failed to start:', err); process.exit(1); });
