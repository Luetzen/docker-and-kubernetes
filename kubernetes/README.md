# Kubernetes Manifeste 📄

Kubernetes YAML Manifeste für die Fullstack-Anwendung.

## Dateien

| Datei | Beschreibung |
|-------|--------------|
| `namespace.yaml` | Namespace für die Anwendung |
| `configmap.yaml` | Konfigurationsdaten (nicht-sensitiv) |
| `secret.yaml` | Sensible Daten (Passwörter) |
| `pvc.yaml` | PersistentVolumeClaim für Datenbank |
| `database-deployment.yaml` | Oracle Database Deployment |
| `backend-deployment.yaml` | Spring Boot Backend Deployment |
| `frontend-deployment.yaml` | Vue.js Frontend Deployment |
| `service.yaml` | Alle Services (Database, Backend, Frontend) |
| `ingress.yaml` | Ingress für externen Zugriff |
| `hpa.yaml` | Horizontal Pod Autoscaler |

## Deployment

### Alle Ressourcen deployen

```bash
# Alles auf einmal
kubectl apply -f kubernetes/

# Oder Schritt für Schritt
kubectl apply -f kubernetes/namespace.yaml
kubectl apply -f kubernetes/configmap.yaml
kubectl apply -f kubernetes/secret.yaml
kubectl apply -f kubernetes/pvc.yaml
kubectl apply -f kubernetes/database-deployment.yaml
kubectl apply -f kubernetes/backend-deployment.yaml
kubectl apply -f kubernetes/frontend-deployment.yaml
kubectl apply -f kubernetes/service.yaml
kubectl apply -f kubernetes/ingress.yaml
kubectl apply -f kubernetes/hpa.yaml
```

### Status prüfen

```bash
# Alle Ressourcen im Namespace anzeigen
kubectl get all -n fullstack-app

# Pods anzeigen
kubectl get pods -n fullstack-app

# Services anzeigen
kubectl get svc -n fullstack-app

# Ingress anzeigen
kubectl get ingress -n fullstack-app

# PVC Status
kubectl get pvc -n fullstack-app
```

### Logs anzeigen

```bash
# Backend Logs
kubectl logs -f deployment/backend -n fullstack-app

# Frontend Logs
kubectl logs -f deployment/frontend -n fullstack-app

# Database Logs
kubectl logs -f deployment/database -n fullstack-app
```

### In Pod einsteigen

```bash
# Backend
kubectl exec -it deployment/backend -n fullstack-app -- /bin/sh

# Frontend
kubectl exec -it deployment/frontend -n fullstack-app -- /bin/sh
```

### Port-Forwarding (für lokalen Zugriff)

```bash
# Frontend
kubectl port-forward -n fullstack-app svc/frontend-service 8081:80

# Backend
kubectl port-forward -n fullstack-app svc/backend-service 8080:8080

# Database
kubectl port-forward -n fullstack-app svc/database-service 1521:1521
```

## Ingress Setup

### Für k3s (Traefik)

k3s kommt mit Traefik Ingress Controller. Füge `myapp.local` zu deiner hosts-Datei hinzu:

**Windows:** `C:\Windows\System32\drivers\etc\hosts`
```
127.0.0.1 myapp.local
```

**Linux/Mac:** `/etc/hosts`
```
127.0.0.1 myapp.local
```

Dann öffne: http://myapp.local

### Für andere Kubernetes Cluster

Installiere einen Ingress Controller (z.B. Nginx):

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.1/deploy/static/provider/cloud/deploy.yaml
```

## Images in Cluster laden

### Docker Images bauen

```bash
# Backend
docker build -t backend:1.0.0 --build-arg APP_VERSION=1.0.0 ./backend

# Frontend
docker build -t frontend:1.0.0 --build-arg APP_VERSION=1.0.0 ./frontend
```

### Für k3s: Images importieren

```bash
# Images speichern
docker save backend:1.0.0 -o backend.tar
docker save frontend:1.0.0 -o frontend.tar

# In k3s importieren
sudo k3s ctr images import backend.tar
sudo k3s ctr images import frontend.tar

# Oder direkt (wenn Docker und k3s auf gleichem Host):
docker save backend:1.0.0 | sudo k3s ctr images import -
docker save frontend:1.0.0 | sudo k3s ctr images import -
```

### Für andere Cluster: Registry nutzen

```bash
# Images taggen
docker tag backend:1.0.0 myregistry.com/backend:1.0.0
docker tag frontend:1.0.0 myregistry.com/frontend:1.0.0

# Pushen
docker push myregistry.com/backend:1.0.0
docker push myregistry.com/frontend:1.0.0

# In Deployment YAML: image: myregistry.com/backend:1.0.0
```

## Skalierung

### Manuell skalieren

```bash
# Backend auf 5 Replicas
kubectl scale deployment/backend --replicas=5 -n fullstack-app

# Frontend auf 3 Replicas
kubectl scale deployment/frontend --replicas=3 -n fullstack-app
```

### Auto-Scaling

HPA ist bereits konfiguriert in `hpa.yaml`.

Status prüfen:
```bash
kubectl get hpa -n fullstack-app
```

## Updates

### Rolling Update

```bash
# Neues Image setzen
kubectl set image deployment/backend backend=backend:2.0.0 -n fullstack-app

# Rollout Status
kubectl rollout status deployment/backend -n fullstack-app

# Rollout History
kubectl rollout history deployment/backend -n fullstack-app
```

### Rollback

```bash
# Zu vorheriger Version
kubectl rollout undo deployment/backend -n fullstack-app

# Zu spezifischer Revision
kubectl rollout undo deployment/backend --to-revision=2 -n fullstack-app
```

## Cleanup

```bash
# Alles löschen
kubectl delete namespace fullstack-app

# Oder einzelne Ressourcen
kubectl delete -f kubernetes/
```

## Troubleshooting

### Pods starten nicht

```bash
# Pod Details
kubectl describe pod <pod-name> -n fullstack-app

# Events anzeigen
kubectl get events -n fullstack-app --sort-by=.metadata.creationTimestamp

# Logs prüfen
kubectl logs <pod-name> -n fullstack-app
```

### Database Connection Error

1. Prüfe ob Database Pod läuft: `kubectl get pods -n fullstack-app`
2. Prüfe Database Logs: `kubectl logs deployment/database -n fullstack-app`
3. Warte 1-2 Minuten nach Database-Start
4. Prüfe Service: `kubectl get svc database-service -n fullstack-app`

### Ingress nicht erreichbar

1. Prüfe Ingress: `kubectl describe ingress app-ingress -n fullstack-app`
2. Prüfe Ingress Controller läuft
3. Prüfe hosts-Datei Eintrag
4. Nutze Port-Forward als Workaround

## Best Practices

✅ **Resource Limits** definiert
✅ **Health Checks** (Liveness & Readiness)
✅ **Rolling Updates** konfiguriert
✅ **Secrets** für sensible Daten
✅ **ConfigMaps** für Konfiguration
✅ **Labels** für Organisation
✅ **Namespaces** für Isolation
✅ **HPA** für Auto-Scaling

