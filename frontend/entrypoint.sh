#!/bin/sh

# Entrypoint-Skript für Nginx mit dynamischer Konfiguration

# Setze Default-Werte, falls Umgebungsvariablen nicht gesetzt sind
BACKEND_URL=${BACKEND_URL:-http://backend:8080}

echo "🔧 Konfiguriere Nginx..."
echo "Backend URL: $BACKEND_URL"

# Ersetze Platzhalter in der Nginx-Konfiguration
sed -i "s|\${BACKEND_URL}|$BACKEND_URL|g" /etc/nginx/conf.d/default.conf

echo "✅ Nginx konfiguriert"

# Starte Nginx im Vordergrund
echo "🚀 Starte Nginx..."
exec nginx -g 'daemon off;'

