# Docker & Kubernetes Lernprojekt 🚀

Dieses Projekt dient als praktisches Beispiel für die Arbeit mit **Docker** und **Kubernetes (k3s)**.
Es zeigt eine vollständige Microservice-Architektur mit:

- **Backend**: Spring Boot REST API mit Oracle Datenbankanbindung
- **Frontend**: Vue.js 3 + TypeScript + Vite
- **Datenbank**: Oracle Database

## 📁 Projektstruktur

```
docker-and-kubernetes/
├── backend/              # Spring Boot Anwendung
├── frontend/             # Vue.js 3 Anwendung
├── database/             # Datenbank Initialisierung
├── kubernetes/           # Kubernetes YAML Manifeste
├── helm/                 # Helm Charts
└── docs/                 # Dokumentation
```

## 🎯 Lernziele

### Docker
- Multi-stage Builds erstellen
- Images optimieren (Standard vs. Minimal)
- Container-Sicherheit verstehen
- Docker Compose nutzen

### Kubernetes
- Deployments, Services, Ingress konfigurieren
- ConfigMaps und Secrets verwalten
- Persistent Volumes nutzen
- Helm Charts erstellen und deployen

## 🚀 Quick Start

### Voraussetzungen
- Docker Desktop installiert
- kubectl installiert
- k3s oder ein anderer Kubernetes Cluster
- Helm 3 installiert (optional)

### Mit Docker Compose starten

```bash
docker-compose up -d
```

Die Anwendung ist dann erreichbar unter:
- Frontend: http://localhost:8081
- Backend: http://localhost:8080

### Mit Kubernetes deployen

```bash
# Alle Ressourcen deployen
kubectl apply -f kubernetes/

# ODER mit Helm
helm install myapp ./helm/fullstack-app
```

## 📚 Dokumentation

Detaillierte Anleitungen findest du in:
- [Docker Grundlagen](docs/DOCKER.md)
- [Kubernetes Grundlagen](docs/KUBERNETES.md)
- [Helm Grundlagen](docs/HELM.md)
- [Backend Setup](backend/README.md)
- [Frontend Setup](frontend/README.md)

## 🛠️ Entwicklung

Siehe die individuellen README Dateien in den jeweiligen Unterverzeichnissen für detaillierte Entwicklungsanleitungen.

## 📝 Lizenz

Dieses Projekt dient ausschließlich zu Lernzwecken.

