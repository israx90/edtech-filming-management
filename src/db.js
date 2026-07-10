require('dotenv').config();
const mysql = require('mysql2/promise');

// SQL logging — only in development (avoid disk writes on Vercel/serverless)
const IS_DEV = process.env.NODE_ENV !== 'production';
let fs, path, logFile;
if (IS_DEV) {
  fs = require('fs');
  path = require('path');
  logFile = path.join(__dirname, '..', 'sql_logs.txt');
}

function logQuery(sql, params) {
  if (!IS_DEV || !fs) return;
  const timestamp = new Date().toISOString();
  const logEntry = `[${timestamp}] SQL: ${sql}\nPARAMS: ${JSON.stringify(params)}\n\n`;
  fs.appendFile(logFile, logEntry, err => {
    if (err) {} // Silent — never crash for logging
  });
}

let pool;
function getPool() {
  if (!pool) {
    pool = mysql.createPool({
      host: process.env.DB_HOST || '127.0.0.1',
      port: process.env.DB_PORT || 3306,
      user: process.env.DB_USERNAME || 'usuario',
      password: process.env.DB_PASSWORD || 'contraseña',
      database: process.env.DB_DATABASE || 'mi_base_datos',
      waitForConnections: true,
      connectionLimit: parseInt(process.env.DB_CONNECTION_LIMIT) || 10,
      queueLimit: 0,
      dateStrings: true,
      timezone: process.env.TZ || 'America/La_Paz'
    });
  }
  return pool;
}

async function queryAll(sql, params = []) {
  logQuery(sql, params);
  const client = getPool();
  const [rows] = await client.execute(sql, params);
  return rows;
}

async function queryOne(sql, params = []) {
  const rows = await queryAll(sql, params);
  return rows[0] || null;
}

async function execute(sql, params = []) {
  logQuery(sql, params);
  const client = getPool();
  const [result] = await client.execute(sql, params);
  // Return the insertId for INSERT statements
  return result.insertId;
}

async function logAction(user, action, entityType, entityId, details) {
  try {
    await execute(
      'INSERT INTO activity_log (user_id, user_name, action, entity_type, entity_id, details) VALUES (?, ?, ?, ?, ?, ?)',
      [user?.id || null, user?.name || 'Sistema', action, entityType || null, entityId || null, details || null]
    );
  } catch (e) {
    // Never let logging crash the main operation
    console.error('[logAction error]', e.message);
  }
}

module.exports = { getPool, queryAll, queryOne, execute, logAction };
