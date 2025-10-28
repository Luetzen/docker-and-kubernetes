# Docker & Kubernetes Lernprojekt 🚀

Dieses Projekt dient als praktisches Beispiel für die Arbeit mit **Docker** und **Kubernetes (k3s)**.
Es zeigt eine vollständige Microservice-Architektur mit:

- **Backend**: Spring Boot REST API mit Oracle Datenbankanbindung
- **Frontend**: Vue.js 3 + TypeScript + Vite
- **Datenbank**: Oracle Database
- **Reverse Proxy**: Traefik

## 🐳 Vorgefertigte Docker Images

Die Anwendung ist als fertige Docker Images auf GitHub Container Registry verfügbar:

```bash
# Backend
docker pull ghcr.io/luetzen/docker-and-kubernetes/backend:latest

# Frontend
docker pull ghcr.io/luetzen/docker-and-kubernetes/frontend:latest
```

**Alle Images sind öffentlich** - kein Login erforderlich! 🎉

## 📁 Projektstruktur

```
docker-and-kubernetes/
├── backend/              # Spring Boot Anwendung
├── frontend/             # Vue.js 3 Anwendung
├── database/             # Datenbank Initialisierung
├── kubernetes/           # Kubernetes YAML Manifeste
├── helm/                 # Helm Charts
├── docs/                 # Dokumentation
└── docker-compose.yml    # Produktions-Setup (nutzt ghcr.io)
```

## 🎯 Lernziele

### Docker
- Multi-stage Builds erstellen
- Images optimieren (Standard vs. Distroless)
- Container-Sicherheit verstehen
- Docker Compose nutzen
- Images in GitHub Container Registry publizieren

### Kubernetes
- Deployments, Services, Ingress konfigurieren
- ConfigMaps und Secrets verwalten
- Persistent Volumes nutzen
- Helm Charts erstellen und deployen

## 🚀 Quick Start

### Voraussetzungen
- Docker Desktop installiert

### Mit Docker Compose starten (empfohlen!)

```bash
# Klone das Repository
git clone https://github.com/luetzen/docker-and-kubernetes.git
cd docker-and-kubernetes

# Starte alle Services
docker-compose up -d
```

**Das war's!** Die Anwendung lädt automatisch die fertigen Images und startet:
- 🌐 Frontend: http://localhost
- 🔧 Backend API: http://localhost:8080
- 💾 Database: localhost:1521

> **Hinweis:** Beim ersten Start dauert es 2-3 Minuten, da die Oracle-Datenbank initialisiert wird.

### Für lokale Entwicklung

Wenn du am Code arbeiten willst:

```bash
docker-compose -f docker-compose.dev.yml up -d --build
```

### Mit Kubernetes deployen

```bash
# Alle Ressourcen deployen
kubectl apply -f kubernetes/

# ODER mit Helm
helm install myapp ./helm/fullstack-app
```

## 📚 Dokumentation

Detaillierte Anleitungen findest du in:
- [Quick Start Guide](QUICKSTART.md) - Schnelleinstieg
- [Docker Grundlagen](docs/DOCKER.md)
- [Docker Commands](docs/DOCKER-COMMANDS.md)
- [GitHub Container Registry Guide](docs/GHCR-GUIDE.md) - Images publizieren
- [Kubernetes Grundlagen](docs/KUBERNETES.md)
- [Kubernetes Commands](docs/KUBERNETES-COMMANDS.md)
- [Helm Grundlagen](docs/HELM.md)
- [Helm Commands](docs/HELM-COMMANDS.md)
- [Backend Setup](backend/README.md)
- [Frontend Setup](frontend/README.md)

## 🛠️ Entwicklung

Siehe die individuellen README Dateien in den jeweiligen Unterverzeichnissen für detaillierte Entwicklungsanleitungen.

## 🔄 Images aktualisieren

Wenn du das Projekt forkst und eigene Images bauen möchtest:

1. Erstelle ein Personal Access Token auf GitHub
2. Logge dich ein: `.\login-ghcr.bat`
3. Passe `push-to-ghcr.bat` an (Username ändern)
4. Pushe die Images: `.\push-to-ghcr.bat`

Details siehe [GHCR-GUIDE.md](docs/GHCR-GUIDE.md)

## 📝 Lizenz

Dieses Projekt dient ausschließlich zu Lernzwecken.

