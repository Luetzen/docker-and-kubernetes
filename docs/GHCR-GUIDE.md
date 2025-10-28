# GitHub Container Registry (ghcr.io) Guide 📦

## Überblick

GitHub Container Registry (ghcr.io) ermöglicht es dir, Docker-Images direkt bei GitHub zu hosten und zu verwalten.

### Wichtig zu wissen:
- 🔓 **Public Repository**: Jeder kann deine Images **pullen** (herunterladen)
- 🔐 **Push-Zugriff**: Nur du kannst mit deinem Personal Access Token Images **pushen**
- 💰 **Kostenlos**: Für public Repositories unbegrenzt kostenlos
- 🚀 **Schnell**: Gute Performance und weltweit verfügbar

## Setup

### 1. Personal Access Token (PAT) erstellen

1. Gehe zu: https://github.com/settings/tokens
2. Klicke auf **"Generate new token"** → **"Generate new token (classic)"**
3. Gib dem Token einen aussagekräftigen Namen, z.B. `GHCR_TOKEN`
4. Wähle folgende Berechtigungen:
   - ✅ `write:packages` (beinhaltet auch `read:packages`)
   - ✅ `delete:packages` (optional, für Löschungen)
   - ✅ `repo` (wenn Repository private ist)
5. Klicke auf **"Generate token"**
6. **WICHTIG**: Kopiere den Token sofort - er wird nur einmal angezeigt!

### 2. Bei ghcr.io einloggen

```cmd
REM Token als Umgebungsvariable setzen (Session)
set GITHUB_TOKEN=dein_token_hier

REM Bei ghcr.io einloggen
echo %GITHUB_TOKEN% | docker login ghcr.io -u dein-github-username --password-stdin
```

**Alternative (dauerhaft, aber weniger sicher):**
```cmd
docker login ghcr.io -u dein-github-username -p dein_token
```

## Images bauen und pushen

### Backend Image

```cmd
REM 1. In backend Verzeichnis wechseln
cd backend

REM 2. Image bauen mit Tag
docker build -t ghcr.io/dein-username/backend:latest .
docker build -t ghcr.io/dein-username/backend:1.0.0 .

REM 3. Image pushen
docker push ghcr.io/dein-username/backend:latest
docker push ghcr.io/dein-username/backend:1.0.0

REM 4. Multi-Arch Build (optional, für ARM/AMD)
docker buildx build --platform linux/amd64,linux/arm64 \
  -t ghcr.io/dein-username/backend:latest \
  -t ghcr.io/dein-username/backend:1.0.0 \
  --push .
```

### Frontend Image

```cmd
REM 1. In frontend Verzeichnis wechseln
cd frontend

REM 2. Image bauen
docker build -t ghcr.io/dein-username/frontend:latest .
docker build -t ghcr.io/dein-username/frontend:1.0.0 .

REM 3. Image pushen
docker push ghcr.io/dein-username/frontend:latest
docker push ghcr.io/dein-username/frontend:1.0.0
```

### Nginx Proxy Image

```cmd
REM 1. In nginx Verzeichnis wechseln
cd nginx

REM 2. Image bauen
docker build -t ghcr.io/dein-username/nginx-proxy:latest .

REM 3. Image pushen
docker push ghcr.io/dein-username/nginx-proxy:latest
```

## Alle Images auf einmal bauen und pushen

Erstelle ein Script `push-to-ghcr.bat`:

```cmd
@echo off
REM Setze deine Variablen
set GITHUB_USER=dein-username
set VERSION=1.0.0

echo ========================================
echo Building and pushing Backend...
echo ========================================
cd backend
docker build -t ghcr.io/%GITHUB_USER%/backend:latest -t ghcr.io/%GITHUB_USER%/backend:%VERSION% .
docker push ghcr.io/%GITHUB_USER%/backend:latest
docker push ghcr.io/%GITHUB_USER%/backend:%VERSION%
cd ..

echo ========================================
echo Building and pushing Frontend...
echo ========================================
cd frontend
docker build -t ghcr.io/%GITHUB_USER%/frontend:latest -t ghcr.io/%GITHUB_USER%/frontend:%VERSION% .
docker push ghcr.io/%GITHUB_USER%/frontend:latest
docker push ghcr.io/%GITHUB_USER%/frontend:%VERSION%
cd ..

echo ========================================
echo Building and pushing Nginx...
echo ========================================
cd nginx
docker build -t ghcr.io/%GITHUB_USER%/nginx-proxy:latest .
docker push ghcr.io/%GITHUB_USER%/nginx-proxy:latest
cd ..

echo ========================================
echo All images pushed successfully!
echo ========================================
```

## Images verwenden

### Public Images pullen (ohne Login)

Jeder kann deine public Images pullen:

```cmd
REM Ohne Login möglich bei public Images
docker pull ghcr.io/dein-username/backend:latest
docker pull ghcr.io/dein-username/frontend:latest
```

### In docker-compose.yml verwenden

Aktualisiere deine `docker-compose.yml`:

```yaml
services:
  backend:
    image: ghcr.io/dein-username/backend:latest
    # Kein 'build' mehr nötig, da Image von ghcr.io geholt wird
    container_name: backend
    ports:
      - "8080:8080"
    # ... rest der config

  frontend:
    image: ghcr.io/dein-username/frontend:latest
    container_name: frontend
    # ... rest der config

  nginx:
    image: ghcr.io/dein-username/nginx-proxy:latest
    container_name: nginx-proxy
    ports:
      - "80:80"
    # ... rest der config
```

Dann einfach starten:
```cmd
docker-compose up -d
```

### In Kubernetes verwenden

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
spec:
  template:
    spec:
      containers:
      - name: backend
        image: ghcr.io/dein-username/backend:1.0.0
        # Für public images kein imagePullSecret nötig
```

## Image Verwaltung

### Images auflisten

Besuche: `https://github.com/dein-username?tab=packages`

### Image Sichtbarkeit ändern

1. Gehe zu deinem Package
2. Klicke auf **"Package settings"**
3. Unter **"Danger Zone"** → **"Change visibility"**
4. Wähle **Public** oder **Private**

### Image löschen

```cmd
REM Lokales Image löschen
docker rmi ghcr.io/dein-username/backend:1.0.0

REM Remote Image löschen (nur über GitHub Web UI möglich)
REM Gehe zu: Package → Package settings → Delete package
```

### Tags verwalten

```cmd
REM Neuen Tag erstellen
docker tag ghcr.io/dein-username/backend:latest ghcr.io/dein-username/backend:v2.0.0
docker push ghcr.io/dein-username/backend:v2.0.0

REM Tag löschen (über GitHub Web UI)
```

## Best Practices

### Tagging-Strategie

```cmd
REM Immer mehrere Tags verwenden
docker build -t ghcr.io/user/app:latest \
  -t ghcr.io/user/app:1.0.0 \
  -t ghcr.io/user/app:1.0 \
  -t ghcr.io/user/app:1 .

REM Alle pushen
docker push ghcr.io/user/app:latest
docker push ghcr.io/user/app:1.0.0
docker push ghcr.io/user/app:1.0
docker push ghcr.io/user/app:1
```

### Versioning

- `latest` - Neueste Version (für Entwicklung)
- `1.0.0` - Spezifische Version (für Production)
- `1.0` - Minor-Version
- `1` - Major-Version
- `dev` - Development-Build
- `staging` - Staging-Build

### Multi-Stage Builds optimieren

Nutze `.dockerignore` um Build-Zeit zu reduzieren:

```dockerignore
# Bereits in .gitignore, aber gut zu wiederholen
.git
.gitignore
README.md
node_modules
target
*.log
.env
```

## Troubleshooting

### "unauthorized: unauthenticated"

```cmd
REM Neu einloggen
echo %GITHUB_TOKEN% | docker login ghcr.io -u username --password-stdin
```

### "denied: permission_denied"

- Prüfe, ob dein Token die richtigen Berechtigungen hat (`write:packages`)
- Token könnte abgelaufen sein → Neuen Token erstellen

### Image zu groß

```cmd
REM Distroless Image verwenden (Backend)
docker build -f Dockerfile.distroless -t ghcr.io/user/backend:latest .

REM Image-Größe prüfen
docker images ghcr.io/user/backend

REM Layer-Größen analysieren
docker history ghcr.io/user/backend:latest
```

### Push dauert zu lange

```cmd
REM Kompression optimieren
docker build --compress -t ghcr.io/user/app:latest .

REM Oder buildkit verwenden (schneller)
set DOCKER_BUILDKIT=1
docker build -t ghcr.io/user/app:latest .
```

## Sicherheit

### ✅ Empfohlen

- Token sicher aufbewahren (z.B. in Password Manager)
- Token als Umgebungsvariable nutzen (nicht hardcoded)
- Minimale Berechtigungen vergeben
- Token regelmäßig rotieren
- Multi-Stage Builds verwenden
- Keine Secrets in Images einbauen

### ❌ Nicht empfohlen

- Token in Code committen
- Token mit anderen teilen
- Token in Dockerfile schreiben
- Produktions-Secrets in Images

## GitHub Actions (CI/CD)

Automatisches Pushen bei jedem Release:

`.github/workflows/docker-publish.yml`:

```yaml
name: Build and Push Docker Images

on:
  push:
    branches: [ main ]
    tags: [ 'v*' ]
  pull_request:
    branches: [ main ]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Log in to Container Registry
        uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}

      - name: Build and push Backend
        uses: docker/build-push-action@v5
        with:
          context: ./backend
          push: ${{ github.event_name != 'pull_request' }}
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
```

## Weitere Ressourcen

- 📚 [GitHub Packages Documentation](https://docs.github.com/en/packages)
- 🐳 [Docker Documentation](https://docs.docker.com/)
- 🔐 [GitHub Token Documentation](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)

## Quick Reference

```cmd
REM Login
echo %GITHUB_TOKEN% | docker login ghcr.io -u username --password-stdin

REM Build & Push
docker build -t ghcr.io/username/app:latest .
docker push ghcr.io/username/app:latest

REM Pull (public, kein Login nötig)
docker pull ghcr.io/username/app:latest

REM Logout
docker logout ghcr.io
```

