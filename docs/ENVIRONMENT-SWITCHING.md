# Environment Switching Guide 🔄

Anleitung zum Wechseln zwischen Docker Compose und Kubernetes (k3s).

---

## 🐳 Docker Compose Umgebung

### Docker Compose STARTEN

```cmd
# 1. Zum Projekt-Verzeichnis wechseln
cd C:\Users\luetz\projects\docker-and-kubernetes

# 2. Docker Compose starten (nur Frontend, Backend und Database)
docker-compose up -d frontend backend database

# 3. Status prüfen
docker-compose ps

# 4. Logs ansehen (optional)
docker-compose logs -f
```

**Wichtig:** Wir starten **NICHT** den Traefik-Container aus Docker Compose, da wir den Traefik aus Kubernetes nutzen!

### Docker Compose STOPPEN

```cmd
# Alle Container stoppen
docker-compose down

# Container stoppen UND Volumes löschen (⚠️ Datenverlust!)
docker-compose down -v
```

### Verfügbare Endpunkte (Docker)

- Frontend: http://localhost:8090
- Backend: http://myapp.local/api (über Kubernetes Traefik)
- Database: localhost:1521

---

## ☸️ Kubernetes (k3s) Umgebung

### Kubernetes STARTEN

#### Option A: Mit Helm (Empfohlen! ✅)

```cmd
# 1. Zum Projekt-Verzeichnis wechseln
cd C:\Users\luetz\projects\docker-and-kubernetes

# 2. Helm Chart installieren (beim ersten Mal)
# WICHTIG: Unter Windows / statt \ verwenden!
helm install fullstack-app ./helm/fullstack-app --namespace fullstack-app --create-namespace

# ODER mit kubectl (Alternative wenn Helm Probleme macht):
kubectl apply -f kubernetes/

# 3. Status prüfen
kubectl get pods -n fullstack-app
kubectl get services -n fullstack-app
kubectl get ingress -n fullstack-app

# 4. Warten bis alle Pods "Running" sind
kubectl wait --for=condition=ready pod --all -n fullstack-app --timeout=300s
```

#### Option B: Mit kubectl (Alternative)

```cmd
# 1. Namespace erstellen
kubectl create namespace fullstack-app

# 2. Alle Ressourcen deployen
kubectl apply -f kubernetes/

# 3. Status prüfen
kubectl get all -n fullstack-app
```

### Kubernetes STOPPEN/LÖSCHEN

#### Mit Helm

```cmd
# Helm Release löschen
helm uninstall fullstack-app --namespace fullstack-app

# Namespace löschen (optional - entfernt PVCs!)
kubectl delete namespace fullstack-app
```

#### Mit kubectl

```cmd
# Alle Ressourcen löschen
kubectl delete -f kubernetes/

# Namespace löschen
kubectl delete namespace fullstack-app
```

### Kubernetes UPDATEN (nach Code-Änderungen)

```cmd
# 1. Neue Images bauen und pushen
docker build -t ghcr.io/luetzen/docker-and-kubernetes/backend:latest .\backend
docker build -t ghcr.io/luetzen/docker-and-kubernetes/frontend:latest .\frontend
docker push ghcr.io/luetzen/docker-and-kubernetes/backend:latest
docker push ghcr.io/luetzen/docker-and-kubernetes/frontend:latest

# 2. Helm Upgrade ausführen
helm upgrade fullstack-app .\helm\fullstack-app --namespace fullstack-app

# 3. Pods neu starten (forciert Pull der neuen Images)
kubectl rollout restart deployment/backend -n fullstack-app
kubectl rollout restart deployment/frontend -n fullstack-app
```

### Verfügbare Endpunkte (Kubernetes)

- Frontend: http://myapp.local
- Backend API: http://myapp.local/api
- Traefik Dashboard: http://localhost:8080 (nur wenn Port-Forward aktiv)

---

## 🔄 Zwischen Umgebungen wechseln

### Von Docker zu Kubernetes

```cmd
# 1. Docker Compose stoppen
docker-compose down

# 2. Kubernetes starten
helm install fullstack-app .\helm\fullstack-app --namespace fullstack-app --create-namespace

# 3. Warten bis Ready
kubectl wait --for=condition=ready pod --all -n fullstack-app --timeout=300s

# 4. Browser öffnen
start http://myapp.local
```

### Von Kubernetes zu Docker

```cmd
# 1. Kubernetes stoppen
helm uninstall fullstack-app --namespace fullstack-app

# 2. Docker Compose starten
docker-compose up -d frontend backend database

# 3. Warten (Database braucht ~2 Min)
timeout /t 120 /nobreak

# 4. Browser öffnen
start http://localhost:8090
```

---

## 🛠️ Nützliche Befehle

### Docker Compose

```cmd
# Status aller Container
docker-compose ps

# Logs anzeigen (alle Services)
docker-compose logs -f

# Logs eines bestimmten Service
docker-compose logs -f backend

# Container neu starten
docker-compose restart backend

# Nur bestimmte Services starten
docker-compose up -d frontend backend
```

### Kubernetes (Helm)

```cmd
# Installierte Releases anzeigen
helm list -n fullstack-app

# Release-Details anzeigen
helm status fullstack-app -n fullstack-app

# Values anzeigen
helm get values fullstack-app -n fullstack-app

# Upgrade mit neuen Values
helm upgrade fullstack-app .\helm\fullstack-app -f custom-values.yaml -n fullstack-app

# Rollback zu vorheriger Version
helm rollback fullstack-app -n fullstack-app
```

### Kubernetes (kubectl)

```cmd
# Alle Ressourcen im Namespace anzeigen
kubectl get all -n fullstack-app

# Pod-Details anzeigen
kubectl describe pod <pod-name> -n fullstack-app

# Logs eines Pods
kubectl logs <pod-name> -n fullstack-app

# In Pod einloggen
kubectl exec -it <pod-name> -n fullstack-app -- /bin/sh

# Port-Forwarding (z.B. für Traefik Dashboard)
kubectl port-forward -n kube-system service/traefik 8080:8080

# Deployment skalieren
kubectl scale deployment backend --replicas=3 -n fullstack-app

# Rolling Update erzwingen
kubectl rollout restart deployment/backend -n fullstack-app

# Update-Status prüfen
kubectl rollout status deployment/backend -n fullstack-app
```

---

## 📊 Monitoring & Debugging

### Docker Compose

```cmd
# Ressourcenverbrauch anzeigen
docker stats

# Container inspizieren
docker inspect <container-name>

# In Container einloggen
docker exec -it <container-name> /bin/sh

# Netzwerk prüfen
docker network ls
docker network inspect docker-and-kubernetes_app-network
```

### Kubernetes

```cmd
# Pod-Status überwachen
kubectl get pods -n fullstack-app -w

# Events anzeigen
kubectl get events -n fullstack-app --sort-by='.lastTimestamp'

# Ressourcenverbrauch
kubectl top pods -n fullstack-app
kubectl top nodes

# Service-Endpoints prüfen
kubectl get endpoints -n fullstack-app

# Ingress-Details
kubectl describe ingress app-ingress -n fullstack-app
```

---

## ⚠️ Wichtige Hinweise

### Traefik

- **Docker Compose:** Wir nutzen den Traefik aus Kubernetes, daher starten wir den Traefik-Container aus docker-compose.yml NICHT
- **Kubernetes:** Traefik läuft automatisch in k3s im Namespace `kube-system`

### Datenbank

- **Docker:** Die Datenbank läuft als Docker-Container und nutzt ein Docker-Volume
- **Kubernetes:** Die Datenbank nutzt ein PersistentVolumeClaim (PVC)
- **⚠️ Wichtig:** Daten werden NICHT zwischen Docker und Kubernetes geteilt!

### Hosts-Datei

Stelle sicher, dass deine `C:\Windows\System32\drivers\etc\hosts` folgendes enthält:

```
127.0.0.1 myapp.local
```

### Ports

| Service | Docker | Kubernetes |
|---------|--------|------------|
| Frontend | :8090 | :80 (über Ingress) |
| Backend | :8080 (direkt) | :8080 (über Ingress /api) |
| Database | :1521 | :1521 (intern) |
| Traefik Dashboard | - | :8080 (Port-Forward) |

---

## 🚨 Troubleshooting

### Problem: "Pods bleiben in Pending"

```cmd
# Prüfen was fehlt
kubectl describe pod <pod-name> -n fullstack-app

# Oft: Warten auf PVC oder Image-Pull
kubectl get pvc -n fullstack-app
```

### Problem: "Cannot connect to database"

```cmd
# Kubernetes: Prüfe ob Database-Pod läuft
kubectl get pods -n fullstack-app | findstr database

# Logs prüfen
kubectl logs <database-pod> -n fullstack-app

# Docker: Warte 2-3 Minuten nach Start
docker logs oracle-db
```

### Problem: "myapp.local not found"

```cmd
# Hosts-Datei prüfen
type C:\Windows\System32\drivers\etc\hosts | findstr myapp.local

# Traefik-Ingress prüfen
kubectl get ingress -n fullstack-app
```

### Problem: "Image pull errors"

```cmd
# Kubernetes: Images manuell pullen
docker pull ghcr.io/luetzen/docker-and-kubernetes/backend:latest
docker pull ghcr.io/luetzen/docker-and-kubernetes/frontend:latest

# k3s Images importieren
docker save ghcr.io/luetzen/docker-and-kubernetes/backend:latest | sudo k3s ctr images import -
```

---

## 🎯 Best Practices

1. **Entwicklung:** Nutze Docker Compose für schnelle Iterationen
2. **Testing:** Nutze Kubernetes um Production-Setup zu testen
3. **Immer nur eine Umgebung:** Stoppe Docker bevor du Kubernetes startest (und umgekehrt)
4. **Logs prüfen:** Bei Problemen immer zuerst die Logs anschauen
5. **Datensicherung:** Vor `docker-compose down -v` oder `kubectl delete namespace` Daten sichern!

---

## 📚 Weiterführende Dokumentation

- [Docker Commands](DOCKER-COMMANDS.md)
- [Kubernetes Commands](KUBERNETES-COMMANDS.md)
- [Helm Commands](HELM-COMMANDS.md)
- [Quick Start](../QUICKSTART.md)

