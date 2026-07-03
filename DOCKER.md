# Ejecución con Docker

Este proyecto se puede levantar completo (app + base de datos) con Docker, sin
afectar el despliegue actual en Vercel.

## Servicios

- **mysql** — MySQL 8.0. En el primer arranque importa automáticamente el dump
  `Data semestre VI.sql` (raíz del proyecto) en la base de datos `edtech`.
- **app** — Node.js 20 con la API Express (`api/index.js`) + el frontend estático,
  servido por `server.js`.

## Uso

```bash
# Construir e iniciar todo
docker compose up -d --build

# Ver logs
docker compose logs -f app
docker compose logs -f mysql
```

- App:            http://localhost:3000
- MySQL (host):   localhost:3307  (usuario: `edtech` / pass: `edtech`, o root/`root`)

## Reimportar la base de datos desde cero

El dump solo se importa cuando el volumen de datos está vacío. Para forzar una
reimportación limpia:

```bash
docker compose down -v   # borra el volumen mysql_data
docker compose up -d --build
```

## Notas

- La conexión de la app a la base se define por variables de entorno en
  `docker-compose.yml` (`DB_HOST=mysql`, etc.), que `src/db.js` ya lee. El archivo
  `.env` local no se usa dentro del contenedor.
- El despliegue en Vercel sigue funcionando igual: usa `api/index.js` y su hosting
  estático. `server.js`, `Dockerfile` y `docker-compose.yml` son solo para Docker.
