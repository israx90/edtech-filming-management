require('dotenv').config();
const mysql = require('mysql2/promise');

let pool = null;

async function getDb() {
    if (pool) return pool;

    const host = process.env.DB_HOST || 'localhost';
    const user = process.env.DB_USER || 'root';
    const password = process.env.DB_PASSWORD || '';
    const database = process.env.DB_NAME || 'filmaciones';
    const port = process.env.DB_PORT || 3306;

    try {
        pool = mysql.createPool({
            host,
            user,
            password,
            database,
            port,
            waitForConnections: true,
            connectionLimit: 10,
            queueLimit: 0,
            dateStrings: true // To keep date formats consistent with SQLite strings
        });

        // Test connection
        await pool.query('SELECT 1');
        console.log(`📦 Connected to MySQL Database at ${host}:${port}/${database}`);
        return pool;
    } catch (e) {
        console.error('❌ MySQL Connection Failed:', e.message);
        console.log('Ensure you have provided correct DB_HOST, DB_USER, DB_PASSWORD, DB_NAME in .env');
        process.exit(1);
    }
}

function closeDb() {
    if (pool) {
        pool.end();
        pool = null;
    }
}

// No need for saveDb in MySQL
function saveDb() {}

// Helper: run query and return all rows as objects
async function queryAll(sql, params = []) {
    const [rows] = await pool.query(sql, params);
    return rows;
}

// Helper: run query and return first row
async function queryOne(sql, params = []) {
    const [rows] = await pool.query(sql, params);
    return rows.length > 0 ? rows[0] : null;
}

// Helper: run insert/update/delete
async function execute(sql, params = []) {
    const [result] = await pool.execute(sql, params);
    return { lastInsertRowid: result.insertId };
}

module.exports = { getDb, closeDb, saveDb, queryAll, queryOne, execute };
