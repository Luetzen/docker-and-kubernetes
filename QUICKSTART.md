# Quick Start Guide 🚀

Schnelleinstieg für das Docker & Kubernetes Lernprojekt.

## Option 1: Mit Docker Compose (Am einfachsten!)

### Schritt 1: Repository klonen (falls noch nicht geschehen)

```cmd
cd C:\Users\luetz\projects\docker-and-kubernetes
```

### Schritt 2: Umgebungsvariablen kopieren

```cmd
copy .env.example .env
```

### Schritt 3: Mit Docker Compose starten

```cmd
docker-compose up -d
```

**Das war's!** Die Anwendung startet jetzt:
- Frontend: http://localhost:8081
- Backend: http://localhost:8080
- Database: localhost:1521

### Logs anzeigen

```cmd
docker-compose logs -f
```

### Stoppen

```cmd
docker-compose down
```

---

## Option 2: Mit Kubernetes (k3s)

### Voraussetzungen

- k3s installiert
- kubectl konfiguriert

### Schritt 1: Docker Images bauen

```cmd
cd backend
docker build -t backend:1.0.0 --build-arg APP_VERSION=1.0.0 .

cd ..\frontend
docker build -t frontend:1.0.0 --build-arg APP_VERSION=1.0.0 .

cd ..
```

### Schritt 2: Images in k3s laden

```cmd
docker save backend:1.0.0 -o backend.tar
docker save frontend:1.0.0 -o frontend.tar

REM Auf Linux/k3s Server:
REM sudo k3s ctr images import backend.tar
REM sudo k3s ctr images import frontend.tar
```

### Schritt 3A: Mit Kubernetes YAMLs deployen

```cmd
kubectl apply -f kubernetes/
```

### Schritt 3B: ODER mit Helm deployen (empfohlen!)

```cmd
helm install myapp .\helm\fullstack-app
```

### Schritt 4: Hosts-Datei anpassen

Öffne `C:\Windows\System32\drivers\etc\hosts` als Administrator und füge hinzu:

```
127.0.0.1 myapp.local
```

### Schritt 5: Im Browser öffnen

http://myapp.local

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

