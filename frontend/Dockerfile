# --- STAGE 1: Build-Umgebung ---
FROM docker.io/library/node:22-alpine as builder

ARG APP_VERSION=1.0.0

WORKDIR /app

# Package files zuerst (für besseres Caching)
COPY package*.json ./

# Dependencies installieren (inkl. dev für Build)
RUN npm install

# Source Code kopieren
COPY . .

# Production Build mit Version (ohne TypeScript Check für schnelleren Build)
RUN VITE_APP_VERSION=$APP_VERSION npm run build -- --mode production

# --- STAGE 2: Produktions-Umgebung mit Nginx ---
FROM docker.io/library/nginx:1.27-alpine

LABEL maintainer="your-email@example.com"
LABEL description="Vue.js 3 Frontend für Docker & Kubernetes Lernprojekt"

# Gebaute Dateien aus Builder kopieren
COPY --from=builder /app/dist /usr/share/nginx/html

# Nginx-Konfiguration kopieren
COPY default.conf /etc/nginx/conf.d/default.conf

# Entrypoint-Skript kopieren
COPY entrypoint.sh /entrypoint.sh

# Skript ausführbar machen
RUN chmod +x /entrypoint.sh && \
    # Non-root User (nginx bereits vorhanden in nginx:alpine)
    chown -R nginx:nginx /usr/share/nginx/html && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    chown -R nginx:nginx /etc/nginx/conf.d && \
    touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid

# Als nginx User ausführen
USER nginx

EXPOSE 80

# Health Check
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:80/ || exit 1

# Starte mit Entrypoint-Skript
CMD ["/entrypoint.sh"]

