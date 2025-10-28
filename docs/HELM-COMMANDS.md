# Helm Befehls-Referenz ⎈

## Installation

```bash
# Chart installieren
helm install myapp ./helm/fullstack-app

# Mit Werten
helm install myapp ./helm/fullstack-app -f values.yaml

# Werte direkt setzen
helm install myapp ./helm/fullstack-app --set backend.replicaCount=3

# Dry-run
helm install myapp ./helm/fullstack-app --dry-run --debug

# In Namespace
helm install myapp ./helm/fullstack-app -n my-namespace --create-namespace
```

## Status & Info

```bash
# Status anzeigen
helm status myapp

# Alle Releases
helm list

# In allen Namespaces
helm list -A

# Werte anzeigen
helm get values myapp

# Alle Werte (inkl. Defaults)
helm get values myapp --all

# Manifest anzeigen
helm get manifest myapp
```

## Updates

```bash
# Upgrade
helm upgrade myapp ./helm/fullstack-app

# Install oder Upgrade
helm upgrade --install myapp ./helm/fullstack-app

# Mit neuen Werten
helm upgrade myapp ./helm/fullstack-app -f new-values.yaml

# History
helm history myapp
```

## Rollback

```bash
# Zur vorherigen Version
helm rollback myapp

# Zu spezifischer Revision
helm rollback myapp 2
```

## Deinstallation

```bash
# Release löschen
helm uninstall myapp

# Mit History behalten
helm uninstall myapp --keep-history
```

## Chart-Entwicklung

```bash
# Neues Chart erstellen
helm create mychart

# Chart validieren
helm lint ./helm/fullstack-app

# Template rendern
helm template myapp ./helm/fullstack-app

# Chart packen
helm package ./helm/fullstack-app
```

## Repositories

```bash
# Repository hinzufügen
helm repo add bitnami https://charts.bitnami.com/bitnami

# Repositories aktualisieren
helm repo update

# Repositories auflisten
helm repo list

# In Repository suchen
helm search repo nginx
```

