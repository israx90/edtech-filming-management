// Entrypoint para ejecutar el proyecto en Docker (o localmente con `node server.js`).
//
// Reutiliza EXACTAMENTE el mismo Express app que usa Vercel (api/index.js), sin
// modificar la lógica de la API. Solo añade:
//   1. Servido de los archivos estáticos del frontend (index.html, css/, js/, ...).
//   2. Un app.listen() para poder correr fuera del entorno serverless de Vercel.
//
// El despliegue en Vercel sigue usando api/index.js + su hosting estático, así que
// este archivo no afecta la funcionalidad actual.
const path = require('path');
const express = require('express');

const app = require('./api/index.js');

// Servir el frontend estático desde la raíz del proyecto.
app.use(express.static(path.join(__dirname)));

const port = process.env.APP_PORT || process.env.PORT || 3000;
app.listen(port, '0.0.0.0', () => {
  console.log(`[server] Calendario escuchando en http://0.0.0.0:${port}`);
});
