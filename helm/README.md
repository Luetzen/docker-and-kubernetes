# Helm Chart für Fullstack Application ⎈

Helm Chart für die komplette Fullstack-Anwendung (Frontend + Backend + Database).

## Installation

### 1. Images bauen und laden

```bash
# Backend Image bauen
cd backend
docker build -t backend:1.0.0 --build-arg APP_VERSION=1.0.0 .

# Frontend Image bauen
cd ../frontend
docker build -t frontend:1.0.0 --build-arg APP_VERSION=1.0.0 .

# Für k3s: Images importieren
docker save backend:1.0.0 | sudo k3s ctr images import -
docker save frontend:1.0.0 | sudo k3s ctr images import -
```

### 2. Mit Helm installieren

```bash
# Chart installieren
helm install myapp ./helm/fullstack-app

# Mit benutzerdefinierten Werten
helm install myapp ./helm/fullstack-app -f custom-values.yaml

# In spezifischem Namespace
helm install myapp ./helm/fullstack-app --namespace my-namespace --create-namespace
```

## Konfiguration

### values.yaml anpassen

Kopiere `values.yaml` und passe die Werte an:

```yaml
# Beispiel: Production Werte
backend:
  replicaCount: 5
  resources:
    requests:
      memory: 1Gi
      cpu: 500m
    limits:
      memory: 2Gi
      cpu: 1000m

ingress:
  enabled: true
  hosts:
    - host: myapp.production.com
      paths:
        - path: /
          pathType: Prefix
          service: frontend
```

Dann installieren:

```bash
helm install myapp ./helm/fullstack-app -f production-values.yaml
```

### Umgebungs-spezifische Values

**Development (values-dev.yaml):**
```yaml
backend:
  replicaCount: 1
  autoscaling:
    enabled: false

frontend:
  replicaCount: 1
  autoscaling:
    enabled: false

database:
  persistence:
    size: 2Gi
```

**Production (values-prod.yaml):**
```yaml
backend:
  replicaCount: 5
  autoscaling:
    enabled: true
    maxReplicas: 20

frontend:
  replicaCount: 3

database:
  persistence:
    size: 10Gi
  resources:
    requests:
      memory: 4Gi
```

## Helm Befehle

### Installation

```bash
# Installieren
helm install myapp ./helm/fullstack-app

# Mit Werten setzen
helm install myapp ./helm/fullstack-app \
  --set backend.replicaCount=3 \
  --set database.password=SecurePassword123

# Dry-run (zeigt generierte YAMLs)
helm install myapp ./helm/fullstack-app --dry-run --debug
```

### Status & Info

```bash
# Status anzeigen
helm status myapp

# Alle Releases
helm list

# In allen Namespaces
helm list -A

# Generierte Werte anzeigen
helm get values myapp

# Generiertes Manifest
helm get manifest myapp
```

### Updates

```bash
# Upgrade
helm upgrade myapp ./helm/fullstack-app

# Upgrade mit neuen Werten
helm upgrade myapp ./helm/fullstack-app -f new-values.yaml

# Install oder Upgrade
helm upgrade --install myapp ./helm/fullstack-app

# History anzeigen
helm history myapp
```

### Rollback

```bash
# Zur vorherigen Version
helm rollback myapp

# Zu spezifischer Revision
helm rollback myapp 2
```

### Deinstallation

```bash
# Release löschen
helm uninstall myapp

# Mit History behalten
helm uninstall myapp --keep-history
```

## Chart Entwicklung

### Chart validieren

```bash
# Lint
helm lint ./helm/fullstack-app

# Template rendern
helm template myapp ./helm/fullstack-app

# Mit Debug
helm template myapp ./helm/fullstack-app --debug
```

### Chart packen

```bash
# Chart packen
helm package ./helm/fullstack-app

# Erzeugt: fullstack-app-1.0.0.tgz
```

## Komponenten ein/ausschalten

```bash
# Nur Backend und Frontend (ohne Database)
helm install myapp ./helm/fullstack-app --set database.enabled=false

# Nur Backend
helm install myapp ./helm/fullstack-app \
  --set frontend.enabled=false \
  --set database.enabled=false
```

## Beispiel: Complete Deployment

```bash
# 1. Images bauen
docker build -t backend:1.0.0 --build-arg APP_VERSION=1.0.0 ./backend
docker build -t frontend:1.0.0 --build-arg APP_VERSION=1.0.0 ./frontend

# 2. Für k3s: Images importieren
docker save backend:1.0.0 | sudo k3s ctr images import -
docker save frontend:1.0.0 | sudo k3s ctr images import -

# 3. Helm Chart installieren
helm install myapp ./helm/fullstack-app \
  --set database.password=MySecurePassword123 \
  --set ingress.hosts[0].host=myapp.local

# 4. Status prüfen
helm status myapp
kubectl get all -n fullstack-app

# 5. Logs anzeigen
kubectl logs -f deployment/backend -n fullstack-app

# 6. Hosts-Datei anpassen
# Windows: C:\Windows\System32\drivers\etc\hosts
# 127.0.0.1 myapp.local

# 7. Im Browser öffnen
# http://myapp.local
```

## Troubleshooting

### Chart rendert nicht

```bash
# Lint-Fehler prüfen
helm lint ./helm/fullstack-app

# Template mit Debug
helm template myapp ./helm/fullstack-app --debug
```

### Pods starten nicht

```bash
# Status prüfen
helm status myapp

# Kubernetes Events
kubectl get events -n fullstack-app --sort-by=.metadata.creationTimestamp

# Pod Logs
kubectl logs deployment/backend -n fullstack-app
```

### Werte werden nicht übernommen

```bash
# Aktuelle Werte anzeigen
helm get values myapp

# Mit allen Werten (inkl. Defaults)
helm get values myapp --all
```

## Best Practices

✅ **Secrets extern verwalten** (nicht in values.yaml)
✅ **Resource Limits** definieren
✅ **Health Checks** konfigurieren
✅ **Umgebungs-spezifische Values** nutzen
✅ **Chart Version** bei Updates erhöhen
✅ **NOTES.txt** für Installations-Hinweise
✅ **Dokumentation** in values.yaml

## Weiterführende Infos

Siehe auch:
- [Helm Dokumentation](../docs/HELM.md)
- [Kubernetes Manifeste](../kubernetes/README.md)
- [Docker Grundlagen](../docs/DOCKER.md)

