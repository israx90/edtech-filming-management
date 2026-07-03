require('dotenv').config();
const mysql = require('mysql2/promise');

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
  const client = getPool();
  const [rows] = await client.execute(sql, params);
  return rows;
}

async function queryOne(sql, params = []) {
  const rows = await queryAll(sql, params);
  return rows[0] || null;
}

async function execute(sql, params = []) {
  const client = getPool();
  const [result] = await client.execute(sql, params);
  // Return the insertId for INSERT statements
  return result.insertId;
}

module.exports = { getPool, queryAll, queryOne, execute };
