# Imagen de la aplicación Node.js (API Express + frontend estático)
FROM node:20-alpine

WORKDIR /app

# Instalar dependencias primero para aprovechar la cache de capas
COPY package.json package-lock.json ./
RUN npm ci --omit=dev

# Copiar el resto del código (respetando .dockerignore)
COPY . .

ENV NODE_ENV=production
ENV APP_PORT=3000
EXPOSE 3000

CMD ["node", "server.js"]
