# Projekt-Übersicht 📋

## Struktur

```
docker-and-kubernetes/
│
├── backend/                    # Spring Boot Backend
│   ├── src/                   # Java Source Code
│   ├── Dockerfile             # Standard Docker Image
│   ├── Dockerfile.distroless  # Minimales Image (sicherer)
│   ├── pom.xml                # Maven Dependencies
│   └── README.md              # Backend Dokumentation
│
├── frontend/                   # Vue.js 3 Frontend
│   ├── src/                   # TypeScript Source Code
│   ├── Dockerfile             # Docker Image mit Nginx
│   ├── default.conf           # Nginx Konfiguration
│   ├── entrypoint.sh          # Container Startskript
│   ├── package.json           # npm Dependencies
│   └── README.md              # Frontend Dokumentation
│
├── database/                   # Datenbank Setup
│   ├── init.sql               # Initialisierungs-Skript
│   └── README.md              # Database Dokumentation
│
├── kubernetes/                 # Kubernetes Manifeste
│   ├── namespace.yaml         # Namespace
│   ├── configmap.yaml         # Konfiguration
│   ├── secret.yaml            # Secrets
│   ├── pvc.yaml               # Persistent Volume Claim
│   ├── *-deployment.yaml      # Deployments
│   ├── service.yaml           # Services
│   ├── ingress.yaml           # Ingress
│   ├── hpa.yaml               # Horizontal Pod Autoscaler
│   └── README.md              # Kubernetes Dokumentation
│
├── helm/                       # Helm Charts
│   └── fullstack-app/         # Haupt-Chart
│       ├── Chart.yaml         # Chart Metadaten
│       ├── values.yaml        # Default-Werte
│       ├── templates/         # Kubernetes Templates
│       └── README.md          # Helm Dokumentation
│
├── docs/                       # Dokumentation
│   ├── DOCKER.md              # Docker Grundlagen
│   ├── KUBERNETES.md          # Kubernetes Grundlagen
│   ├── HELM.md                # Helm Grundlagen
│   ├── DOCKER-COMMANDS.md     # Docker Befehle
│   ├── KUBERNETES-COMMANDS.md # Kubernetes Befehle
│   └── HELM-COMMANDS.md       # Helm Befehle
│
├── docker-compose.yml          # Docker Compose Konfiguration
├── QUICKSTART.md               # Quick Start Guide
├── README.md                   # Haupt-README
└── .gitignore                  # Git Ignore Rules
```

## Komponenten

### Backend (Spring Boot)
- **Technologie:** Java 21, Spring Boot 3.2.5
- **Features:** REST API, JPA, Oracle DB Anbindung
- **Endpoints:** `/api/products`, `/api/health`, `/api/info`
- **Images:** Standard (Alpine) + Distroless (Minimal)

### Frontend (Vue.js 3)
- **Technologie:** Vue 3, TypeScript, Vite 7
- **Features:** SPA, Pinia Store, Vue Router
- **Server:** Nginx (im Container)

### Database (Oracle)
- **Technologie:** Oracle Database Express 21c
- **Persistenz:** Volume für Datenbeständigkeit
- **Init:** SQL-Skript mit Beispieldaten

## Deployment-Optionen

### 1. Docker Compose (Lokal)
```cmd
docker-compose up -d
```
**Vorteile:**
- ✅ Schneller Einstieg
- ✅ Alle Services auf einmal
- ✅ Ideal für lokale Entwicklung

### 2. Kubernetes YAML Manifeste
```bash
kubectl apply -f kubernetes/
```
**Vorteile:**
- ✅ Granulare Kontrolle
- ✅ Lernzwecke (zeigt alle Details)
- ✅ Produktionsreif

### 3. Helm Chart
```bash
helm install myapp ./helm/fullstack-app
```
**Vorteile:**
- ✅ Einfachste Kubernetes-Installation
- ✅ Wiederverwendbar
- ✅ Versionierung & Rollback
- ✅ Umgebungs-spezifische Konfiguration

## Lernpfad

### Phase 1: Docker Basics
1. README und [DOCKER.md](docs/DOCKER.md) lesen
2. Backend Dockerfile analysieren
3. Frontend Dockerfile analysieren
4. Images bauen und lokal testen
5. Docker Compose verwenden

### Phase 2: Docker Advanced
1. Distroless Image vergleichen
2. Multi-stage Builds verstehen
3. Image-Größen optimieren
4. Security Best Practices

### Phase 3: Kubernetes Basics
1. [KUBERNETES.md](docs/KUBERNETES.md) lesen
2. Kubernetes Konzepte verstehen
3. YAMLs analysieren (Deployment, Service, Ingress)
4. Manuell mit kubectl deployen

### Phase 4: Kubernetes Advanced
1. ConfigMaps & Secrets verwenden
2. Persistent Volumes verstehen
3. Health Checks konfigurieren
4. Horizontal Pod Autoscaling

### Phase 5: Helm
1. [HELM.md](docs/HELM.md) lesen
2. Helm Chart Struktur verstehen
3. Templates analysieren
4. values.yaml anpassen
5. Helm Deploy durchführen

## Präsentation für Kollegen

### Struktur-Vorschlag:

**1. Einführung (10 Min)**
- Warum Docker & Kubernetes?
- Projekt-Übersicht zeigen

**2. Docker Demo (20 Min)**
- Dockerfile erklären
- Multi-stage Build zeigen
- Image bauen
- Container starten
- Docker Compose Demo

**3. Docker Advanced (15 Min)**
- Standard vs. Distroless vergleichen
- Security Best Practices
- Image-Optimierung

**4. Kubernetes Demo (25 Min)**
- Kubernetes Architektur erklären
- YAML Manifeste durchgehen
- kubectl Befehle zeigen
- Live-Deployment

**5. Helm Demo (15 Min)**
- Warum Helm?
- Chart-Struktur erklären
- Helm Install Demo
- Values anpassen

**6. Q&A (15 Min)**
- Fragen beantworten
- Troubleshooting zeigen

## Wichtige URLs (nach Deployment)

### Mit Docker Compose:
- Frontend: http://localhost:8081
- Backend: http://localhost:8080
- API Docs: http://localhost:8080/api/health

### Mit Kubernetes (Ingress):
- Application: http://myapp.local

### Mit Port-Forwarding:
```bash
kubectl port-forward svc/frontend-service 8081:80 -n fullstack-app
```

## Nächste Schritte

- [ ] Monitoring hinzufügen (Prometheus, Grafana)
- [ ] Logging-Stack (ELK/EFK)
- [ ] CI/CD Pipeline (GitHub Actions, GitLab CI)
- [ ] Service Mesh (Istio, Linkerd)
- [ ] Security Scanning (Trivy, Falco)

## Ressourcen

- [Docker Docs](https://docs.docker.com/)
- [Kubernetes Docs](https://kubernetes.io/docs/)
- [Helm Docs](https://helm.sh/docs/)
- [k3s Docs](https://docs.k3s.io/)
- [Spring Boot Docs](https://spring.io/projects/spring-boot)
- [Vue.js Docs](https://vuejs.org/)

