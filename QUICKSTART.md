# Quick Start Guide 🚀

Schnelleinstieg für das Docker & Kubernetes Lernprojekt.

## Option 1: Mit Docker Compose (Am einfachsten! ⚡)

### Voraussetzungen

- Docker Desktop installiert und gestartet

### Schritt 1: Repository klonen

```cmd
git clone https://github.com/luetzen/docker-and-kubernetes.git
cd docker-and-kubernetes
```

### Schritt 2: Mit Docker Compose starten

```cmd
docker-compose up -d
```

**Das war's!** Docker lädt automatisch die fertigen Images von GitHub Container Registry herunter und startet die Anwendung:
- 🌐 Frontend: http://localhost (Nginx Proxy)
- 🔧 Backend API: http://localhost:8080
- 💾 Database: localhost:1521

> **Hinweis:** Beim ersten Start dauert es ca. 2-3 Minuten, da die Oracle-Datenbank initialisiert werden muss.

### Logs anzeigen

```cmd
docker-compose logs -f
```

### Stoppen

```cmd
docker-compose down
```

---

## Option 2: Lokale Entwicklung mit Build

Wenn du am Code arbeiten möchtest und lokale Änderungen testen willst:

```cmd
docker-compose -f docker-compose.dev.yml up -d --build
```

Dies baut die Images lokal aus deinem Sourcecode.

---

## Option 3: Mit Kubernetes (k3s)

### Voraussetzungen

- k3s installiert
- kubectl konfiguriert

### Schritt 1: Images verwenden

Die Images sind öffentlich verfügbar auf ghcr.io:
- `ghcr.io/luetzen/docker-and-kubernetes/backend:latest`
- `ghcr.io/luetzen/docker-and-kubernetes/frontend:latest`
- `ghcr.io/luetzen/docker-and-kubernetes/nginx-proxy:latest`

### Schritt 2A: Mit Kubernetes YAMLs deployen

```cmd
kubectl apply -f kubernetes/
```

### Schritt 2B: ODER mit Helm deployen (empfohlen!)

```cmd
helm install myapp .\helm\fullstack-app
```

### Schritt 3: Hosts-Datei anpassen

Öffne `C:\Windows\System32\drivers\etc\hosts` als Administrator und füge hinzu:

```
127.0.0.1 myapp.local
```

### Schritt 4: Im Browser öffnen

http://myapp.local

---

## Verfügbare Endpunkte

Nach dem Start sind folgende Endpunkte verfügbar:

### Frontend (Vue.js)
- http://localhost - Hauptanwendung
- http://localhost/products - Produktliste

### Backend (Spring Boot)
- http://localhost:8080/api/health - Health Check
- http://localhost:8080/api/products - REST API für Produkte

### Datenbank (Oracle)
- Host: localhost
- Port: 1521
- Service: FREEPDB1
- User: appuser
- Password: Oracle123

---

## Troubleshooting

### "Cannot connect to database"

Warte 2-3 Minuten nach dem Start. Die Oracle-Datenbank braucht etwas Zeit zum Initialisieren.

```cmd
REM Status prüfen
docker-compose ps
docker logs oracle-db
```

### Port bereits belegt

Falls Port 80 oder 8080 bereits belegt ist:

```cmd
REM Stoppe den laufenden Service oder ändere die Ports in docker-compose.yml
```

### Images nicht gefunden

Prüfe deine Internetverbindung. Docker muss die Images von ghcr.io herunterladen können.

```cmd
REM Manuell pullen
docker pull ghcr.io/luetzen/docker-and-kubernetes/backend:latest
docker pull ghcr.io/luetzen/docker-and-kubernetes/frontend:latest
docker pull ghcr.io/luetzen/docker-and-kubernetes/nginx-proxy:latest
```

---

## Nächste Schritte

1. **Dokumentation lesen:**
   - [Docker Grundlagen](docs/DOCKER.md)
   - [Kubernetes Grundlagen](docs/KUBERNETES.md)
   - [Helm Grundlagen](docs/HELM.md)

2. **Backend erkunden:**
   - [Backend README](backend/README.md)
   - REST API testen: http://localhost:8080/api/products

3. **Frontend erkunden:**
   - [Frontend README](frontend/README.md)
   - Vue.js Code analysieren

4. **Experimentieren:**
   - Images optimieren (Distroless ausprobieren)
   - Kubernetes Deployments skalieren
   - Helm Values anpassen

## Troubleshooting

### Docker Compose startet nicht?

```cmd
REM Alte Container entfernen
docker-compose down -v

REM Neu starten
docker-compose up -d --build
```

### Kubernetes Pods starten nicht?

```cmd
kubectl get pods -n fullstack-app
kubectl describe pod <pod-name> -n fullstack-app
kubectl logs <pod-name> -n fullstack-app
```

### Database Connection Error?

Warte 1-2 Minuten nach Start - Oracle DB braucht Zeit zum Initialisieren!

## Wichtige Befehle

### Docker Compose

```cmd
docker-compose up -d          REM Starten
docker-compose down           REM Stoppen
docker-compose logs -f        REM Logs anzeigen
docker-compose ps             REM Status anzeigen
docker-compose restart        REM Neu starten
```

### Kubernetes

```cmd
kubectl get all -n fullstack-app           REM Alle Ressourcen anzeigen
kubectl logs -f deployment/backend -n fullstack-app   REM Backend Logs
kubectl port-forward svc/frontend-service 8081:80 -n fullstack-app   REM Port-Forwarding
```

### Helm

```cmd
helm list                     REM Alle Releases
helm status myapp             REM Status anzeigen
helm upgrade myapp .\helm\fullstack-app   REM Upgrade
helm uninstall myapp          REM Deinstallieren
```

## Viel Erfolg beim Lernen! 🎉

