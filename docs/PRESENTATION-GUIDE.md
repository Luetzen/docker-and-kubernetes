# Projekt-Präsentation: Schritt-für-Schritt 🎓

Diese Datei zeigt die **empfohlene Reihenfolge**, um das Docker & Kubernetes Projekt vorzustellen.

---

## 📋 Übersicht: Was zeige ich wann?

### Phase 1: Docker Basics
### Phase 2: Docker Compose
### Phase 3: Container Registry & CI/CD
### Phase 4: Kubernetes Basics
### Phase 5: Helm Charts

---

## Phase 1: Docker Basics 🐳

### 1.1 Projektstruktur zeigen

```cmd
REM Zeige die Projektstruktur
tree /F /A
```

**Erkläre:**
- Backend (Spring Boot + Oracle)
- Frontend (Vue.js + TypeScript)
- Database (Oracle Initialisierung)
- Traefik (Reverse Proxy)
- Kubernetes & Helm Konfigurationen

### 1.2 Dockerfile Backend

**Datei:** `backend/Dockerfile`

```cmd
cd backend
type Dockerfile
```

**Zeige:**
1. **Multi-Stage Build**
   - Stage 1: Maven Build
   - Stage 2: Runtime mit JRE
2. **Vorteile:**
   - Kleinere Images (nur Runtime, kein Build-Tools)
   - Sicherheit (weniger Attack Surface)
3. **Build Argument** `APP_VERSION`

**Demo:**
```cmd
REM Image bauen
docker build -t backend-demo:1.0.0 --build-arg APP_VERSION=1.0.0 .

REM Image-Größe prüfen
docker images backend-demo

REM Image inspizieren
docker history backend-demo:1.0.0
```

### 1.3 Dockerfile.distroless Backend

**Datei:** `backend/Dockerfile.distroless`

```cmd
type Dockerfile.distroless
```

**Zeige:**
- **Distroless Base Image** (gcr.io/distroless/java21-debian12)
- Noch kleiner und sicherer
- Keine Shell, kein Package Manager
- Perfekt für Production

**Demo:**
```cmd
REM Distroless Image bauen
docker build -f Dockerfile.distroless -t backend-distroless:1.0.0 .

REM Größenvergleich
docker images | findstr backend
```

**Vergleich zeigen:**
- Standard JRE: ~400-500 MB
- Distroless: ~250-300 MB

### 1.4 Dockerfile Frontend

**Datei:** `frontend/Dockerfile`

```cmd
cd ..\frontend
type Dockerfile
```

**Zeige:**
1. **Multi-Stage Build**
   - Stage 1: Node Build (npm install, vite build)
   - Stage 2: Nginx Runtime
2. **Statische Files** werden in Nginx serviert
3. **Runtime Environment Variables** via entrypoint.sh

**Demo:**
```cmd
docker build -t frontend-demo:1.0.0 .
docker images frontend-demo
```

### 1.5 Container einzeln starten

**Database starten:**
```cmd
cd ..
docker run -d ^
  --name oracle-db ^
  -p 1521:1521 ^
  -e ORACLE_PASSWORD=Oracle123 ^
  -e APP_USER=appuser ^
  -e APP_USER_PASSWORD=Oracle123 ^
  gvenzl/oracle-free:latest

REM Logs verfolgen
docker logs -f oracle-db
```

**Backend starten:**
```cmd
docker run -d ^
  --name backend ^
  -p 8080:8080 ^
  -e DB_HOST=host.docker.internal ^
  -e DB_PORT=1521 ^
  -e DB_SERVICE=FREEPDB1 ^
  -e DB_USER=appuser ^
  -e DB_PASSWORD=Oracle123 ^
  ghcr.io/luetzen/docker-and-kubernetes/backend:latest

REM Health Check testen
curl http://localhost:8080/api/health
```

**Frontend starten:**
```cmd
docker run -d ^
  --name frontend ^
  -p 8081:80 ^
  -e BACKEND_URL=http://host.docker.internal:8080 ^
  ghcr.io/luetzen/docker-and-kubernetes/frontend:latest

REM Im Browser öffnen
start http://localhost:8081
```

**Cleanup:**
```cmd
docker stop oracle-db backend frontend
docker rm oracle-db backend frontend
```

---

## Phase 2: Docker Compose 🐙

### 2.1 docker-compose.yml erklären

**Datei:** `docker-compose.yml`

```cmd
type docker-compose.yml
```

**Zeige:**
1. **Services-Definition** (database, backend, frontend, traefik)
2. **Networking** (alle im gleichen app-network)
3. **Dependencies** (depends_on mit health checks)
4. **Environment Variables**
5. **Volumes** (Datenbank-Persistierung)
6. **Health Checks** für alle Services
7. **Traefik Labels** für automatisches Routing

**Besonderheit:**
- Nutzt **fertige Images von ghcr.io** → kein Build nötig!
- **Traefik** routet automatisch via Docker Labels

### 2.2 docker-compose.dev.yml zeigen

**Datei:** `docker-compose.dev.yml`

```cmd
type docker-compose.dev.yml
```

**Erkläre den Unterschied:**
- `docker-compose.yml` → **Production** (nutzt ghcr.io Images)
- `docker-compose.dev.yml` → **Development** (baut lokal mit `build:`)

**Wann welche nutzen:**
- Production/Demo: `docker-compose up -d`
- Development: `docker-compose -f docker-compose.dev.yml up -d --build`

### 2.3 Mit Docker Compose starten

```cmd
REM Alles starten
docker-compose up -d

REM Status prüfen
docker-compose ps

REM Logs verfolgen
docker-compose logs -f

REM Einzelne Service-Logs
docker-compose logs -f backend

REM Im Browser testen
start http://localhost
start http://localhost:8080/api/health
start http://localhost:8080  REM Traefik Dashboard
```

**Zeige:**
- Traefik Proxy auf Port 80
- Traefik Dashboard auf Port 8080
- Backend API über Traefik: http://localhost/api/
- Frontend über Traefik: http://localhost/
- Datenbank auf Port 1521

**Traefik Labels erklären:**
```yaml
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.backend.rule=PathPrefix(`/api`)"
  - "traefik.http.services.backend.loadbalancer.server.port=8080"
```

- `traefik.enable=true` → Traefik soll diesen Service routen
- `rule=PathPrefix(\`/api\`)` → Alle /api/* Requests gehen zum Backend
- `loadbalancer.server.port=8080` → Backend läuft intern auf Port 8080

```cmd
REM Stoppen
docker-compose down
```

---

## Phase 3: Container Registry & CI/CD 🚀

### 3.1 GitHub Container Registry (ghcr.io)

**Erkläre:**
- **Öffentliche Images** auf ghcr.io
- Jeder kann pullen, nur du kannst pushen
- Integration mit GitHub

**Zeige:**
```cmd
REM Images pullen (ohne Login!)
docker pull ghcr.io/luetzen/docker-and-kubernetes/backend:latest
docker pull ghcr.io/luetzen/docker-and-kubernetes/frontend:latest

REM Im Browser zeigen
start https://github.com/luetzen?tab=packages
```

### 3.2 Images pushen (Demo)

**Datei:** `docs/GHCR-GUIDE.md`

```cmd
type docs\GHCR-GUIDE.md
```

**Demo (wenn Token vorhanden):**
```cmd
REM Login
.\login-ghcr.bat

REM Alle Images pushen
.\push-to-ghcr.bat
```

**Zeige das Script:**
```cmd
type push-to-ghcr.bat
```

**Erkläre:**
- Tagging Strategy (latest + Version)
- Multi-Service Push
- Error Handling

### 3.3 Unterschied: Production vs Development

**docker-compose.yml (Production):**
```yaml
backend:
  image: ghcr.io/luetzen/docker-and-kubernetes/backend:latest
  # Kein build! → Fast startup
```

**docker-compose.dev.yml (Development):**
```yaml
backend:
  build:
    context: ./backend
    dockerfile: Dockerfile
  # Baut lokal → Für Entwicklung
```

**Demo:**
```cmd
REM Production
docker-compose up -d

REM Development
docker-compose -f docker-compose.dev.yml up -d --build
```

### 3.4 Workflow zusammenfassen

**Entwicklungs-Workflow:**
```
1. Code ändern
2. Lokal testen: docker-compose -f docker-compose.dev.yml up -d --build
3. Wenn OK: Images bauen und pushen (push-to-ghcr.bat)
4. In Kubernetes/Helm deployen
5. Testen auf myapp.local
```

---

## Phase 4: Kubernetes Basics ☸️

### 4.1 Kubernetes-Konzepte erklären

**Zeige auf Whiteboard/Slides:**
1. **Pods** - Kleinste Deployment-Einheit
2. **Deployments** - Verwaltet Pods, Rolling Updates
3. **Services** - Netzwerk-Abstraction, Load Balancing
4. **ConfigMaps** - Konfiguration
5. **Secrets** - Sensitive Daten
6. **Ingress** - Externe Zugriffe
7. **PersistentVolumes** - Storage

### 4.2 Namespace erstellen

**Datei:** `kubernetes/namespace.yaml`

```cmd
cd kubernetes
type namespace.yaml
kubectl apply -f namespace.yaml
kubectl get namespaces
```

### 4.3 ConfigMap & Secret

**ConfigMap:**
```cmd
type configmap.yaml
kubectl apply -f configmap.yaml
kubectl get configmap -n fullstack-app
kubectl describe configmap backend-config -n fullstack-app
```

**Secret:**
```cmd
type secret.yaml
kubectl apply -f secret.yaml
kubectl get secrets -n fullstack-app
kubectl describe secret app-secrets -n fullstack-app
```

**Erkläre:**
- ConfigMap für nicht-sensitive Daten
- Secret für Passwörter (Base64-encoded)
- Werden als Environment Variables in Pods injiziert

### 4.4 Database Deployment

**PVC:**
```cmd
type pvc.yaml
kubectl apply -f pvc.yaml
kubectl get pvc -n fullstack-app
```

**Database Deployment:**
```cmd
type database-deployment.yaml
kubectl apply -f database-deployment.yaml
kubectl get pods -n fullstack-app
kubectl logs -f deployment/database -n fullstack-app
```

**Zeige:**
- PersistentVolumeClaim für Daten-Persistierung
- Health Checks
- Resource Limits

### 4.5 Backend & Frontend Deployments

```cmd
type backend-deployment.yaml
kubectl apply -f backend-deployment.yaml

type frontend-deployment.yaml
kubectl apply -f frontend-deployment.yaml

REM Alle Pods anzeigen
kubectl get pods -n fullstack-app -o wide

REM Pod Details
kubectl describe pod <backend-pod-name> -n fullstack-app
```

**Zeige:**
- **replicas: 2** für High Availability
- **RollingUpdate** Strategy
- **Liveness & Readiness Probes**
- **Resource Requests & Limits**
- **Images von ghcr.io** (öffentlich verfügbar!)

### 4.6 Services erstellen

```cmd
type service.yaml
kubectl apply -f service.yaml
kubectl get services -n fullstack-app
```

**Erkläre:**
- **ClusterIP** für interne Services
- Service Discovery (DNS)
- Load Balancing über Pods

### 4.7 Ingress konfigurieren

```cmd
type ingress.yaml
kubectl apply -f ingress.yaml
kubectl get ingress -n fullstack-app
```

**Hosts-Datei anpassen:**
```cmd
REM Als Administrator: C:\Windows\System32\drivers\etc\hosts
REM Zeile hinzufügen:
REM 127.0.0.1 myapp.local
```

**Im Browser öffnen:**
```
http://myapp.local
```

### 4.8 Horizontal Pod Autoscaler

```cmd
type hpa.yaml
kubectl apply -f hpa.yaml
kubectl get hpa -n fullstack-app

REM Autoscaling beobachten
kubectl get hpa -n fullstack-app -w
```

**Erkläre:**
- Auto-Skalierung basierend auf CPU/Memory
- Min/Max Replicas
- Target Utilization

---

## Phase 5: Helm Charts 📦

### 5.1 Helm-Konzepte erklären

**Erkläre:**
- **Charts** = Kubernetes Package
- **Templates** = Parametrisierte YAML Files
- **Values** = Konfigurationswerte
- **Releases** = Deployment-Instanz

**Vorteile:**
- Wiederverwendbar
- Versionierung
- Einfache Updates
- Package Management

### 5.2 Chart-Struktur zeigen

```cmd
cd ..\helm\fullstack-app
tree /F /A

type Chart.yaml
```

**Zeige:**
- `Chart.yaml` - Metadata
- `values.yaml` - Default-Werte
- `templates/` - Kubernetes Manifeste
- `_helpers.tpl` - Template-Funktionen

### 5.3 values.yaml erklären

```cmd
type values.yaml
```

**Zeige:**
- Strukturierte Konfiguration
- Image Repositories (jetzt ghcr.io!)
- Resource Limits
- Autoscaling Settings
- Feature Flags (enabled: true/false)

### 5.4 Templates anschauen

```cmd
type templates\backend-deployment.yaml
```

**Zeige:**
- **Template-Syntax** `{{ .Values.backend.image.repository }}`
- **Conditionals** `{{ if .Values.backend.enabled }}`
- **Helpers** `{{ include "fullstack-app.name" . }}`

### 5.5 Helm installieren

```cmd
REM Chart validieren
helm lint .

REM Dry-run (zeigt was deployt würde)
helm install myapp . --dry-run --debug

REM Tatsächlich installieren
helm install myapp .

REM Status prüfen
helm status myapp
helm list

REM Alle Ressourcen anzeigen
kubectl get all -n fullstack-app
```

### 5.6 Helm Upgrade & Rollback

```cmd
REM Werte ändern und upgraden
helm upgrade myapp . --set backend.replicaCount=3

REM History anzeigen
helm history myapp

REM Rollback
helm rollback myapp 1

REM Deinstallieren
helm uninstall myapp
```

---

## 🎯 Empfohlene Präsentations-Reihenfolge

### Kurze Präsentation:
1. Projektstruktur
2. Docker Compose Demo
3. GHCR Images zeigen
4. Kubernetes Deploy mit fertigen Images
5. Helm Installation

### Mittlere Präsentation:
1. Projektübersicht
2. Docker Basics (Multi-Stage Builds)
3. Docker Compose (Production vs Dev)
4. GHCR Demo (Images pushen)
5. Kubernetes Deploy
6. Helm Charts

### Ausführliche Präsentation:
Alle Phasen 1-5 komplett durchgehen mit allen Details

---

## 📝 Cheat Sheet für Live-Demo

### Schnell-Start für Demo:
```cmd
REM 1. Alles mit Docker Compose starten
docker-compose up -d

REM 2. Warten bis ready
docker-compose logs -f

REM 3. Browser öffnen
start http://localhost
start http://localhost:8080/api/health

REM 4. Kubernetes zeigen
kubectl get all -n fullstack-app

REM 5. Helm zeigen
helm list
helm status myapp
```

### Cleanup nach Demo:
```cmd
docker-compose down -v
helm uninstall myapp
kubectl delete namespace fullstack-app
docker system prune -f
```

---

## 💡 Tipps für die Präsentation

### ✅ Do's:
- **Live-Demo** vorbereiten (Images vorher pullen!)
- **Terminals** vorbereitet haben
- **Browser-Tabs** vorher öffnen
- **Code** in IDE zeigen (nicht nur cat/type)
- **Logs** in separatem Terminal laufen lassen
- **Pausen** einbauen für Fragen

### ❌ Don'ts:
- Nicht während Demo builden (zu langsam!)
- Nicht zu tief in Code-Details gehen
- Nicht alle YAML-Files komplett vorlesen
- Nicht ohne Backup-Plan (Images offline haben!)

### 🔥 Pro-Tipps:
- Terminal mit großer Schrift
- `bat` statt `cat` für Syntax Highlighting
- `k9s` für interaktive Kubernetes-Demo
- Postman/curl für API-Tests vorbereitet haben

---

## 🎬 Fazit-Folie

**Was haben wir gelernt:**
- ✅ Docker Multi-Stage Builds
- ✅ Docker Compose für Multi-Container Apps
- ✅ GitHub Container Registry für Image-Verteilung
- ✅ Kubernetes Deployments, Services, Ingress
- ✅ Helm Charts für Package Management
- ✅ Production vs Development Setup

**Nächste Schritte:**
- CI/CD Pipeline mit GitHub Actions
- Monitoring mit Prometheus/Grafana
- Logging mit ELK Stack
- Service Mesh mit Istio

