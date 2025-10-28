# Helm Grundlagen ⎈

## Was ist Helm?

Helm ist der **Package Manager für Kubernetes**. Es vereinfacht die Installation und Verwaltung von Kubernetes-Anwendungen.

Denk an Helm wie:
- **npm** für Node.js
- **apt/yum** für Linux
- **chocolatey** für Windows

## Warum Helm?

### Ohne Helm ❌
```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f ingress.yaml
kubectl apply -f configmap.yaml
kubectl apply -f secret.yaml
# ... und so weiter für jede Umgebung anpassen
```

### Mit Helm ✅
```bash
helm install myapp ./mychart --values production.yaml
```

## Vorteile von Helm

- **Wiederverwendbarkeit**: Charts können geteilt werden
- **Versionierung**: Releases können gerollt werden
- **Templating**: Dynamische Werte per YAML
- **Dependencies**: Charts können andere Charts nutzen
- **Einfache Updates**: `helm upgrade`
- **Rollbacks**: `helm rollback`

## Helm Architektur

```
┌─────────────────────────────────────────┐
│         Helm Client (CLI)               │
│   (helm install, upgrade, etc.)         │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│       Kubernetes API Server             │
│  (erstellt Ressourcen aus Templates)    │
└─────────────────────────────────────────┘
```

**Hinweis**: Helm 3 benötigt kein Tiller mehr (im Gegensatz zu Helm 2)!

## Helm Konzepte

### 1. Chart
Ein **Chart** ist ein Helm-Package. Es enthält alle Kubernetes-Ressourcen-Definitionen.

```
mychart/
├── Chart.yaml          # Metadaten über das Chart
├── values.yaml         # Default-Konfigurationswerte
├── charts/             # Abhängige Charts
└── templates/          # Kubernetes YAML Templates
    ├── deployment.yaml
    ├── service.yaml
    ├── ingress.yaml
    └── _helpers.tpl    # Template Helpers
```

### 2. Release
Ein **Release** ist eine installierte Instanz eines Charts im Cluster.

```bash
# Ein Chart, mehrere Releases möglich:
helm install prod-release ./mychart
helm install staging-release ./mychart
```

### 3. Repository
Ein **Repository** ist ein Server, der Charts hostet.

```bash
# Bekannte Repos hinzufügen:
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add stable https://charts.helm.sh/stable
```

## Helm Chart Struktur

### Chart.yaml

```yaml
apiVersion: v2
name: myapp
description: A Helm chart for my application
type: application
version: 1.0.0        # Chart version
appVersion: "1.0"     # Version der Anwendung
keywords:
  - spring-boot
  - vue
maintainers:
  - name: Your Name
    email: your.email@example.com
dependencies:
  - name: postgresql
    version: 12.x.x
    repository: https://charts.bitnami.com/bitnami
    condition: postgresql.enabled
```

### values.yaml

```yaml
# Default-Werte, können überschrieben werden
replicaCount: 2

image:
  repository: myregistry/myapp
  tag: "1.0"
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: 80

ingress:
  enabled: true
  className: nginx
  host: myapp.example.com

resources:
  limits:
    cpu: 500m
    memory: 512Mi
  requests:
    cpu: 250m
    memory: 256Mi

autoscaling:
  enabled: false
  minReplicas: 2
  maxReplicas: 10
```

### templates/deployment.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "myapp.fullname" . }}
  labels:
    {{- include "myapp.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      {{- include "myapp.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "myapp.selectorLabels" . | nindent 8 }}
    spec:
      containers:
      - name: {{ .Chart.Name }}
        image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
        imagePullPolicy: {{ .Values.image.pullPolicy }}
        ports:
        - name: http
          containerPort: 8080
        resources:
          {{- toYaml .Values.resources | nindent 10 }}
```

## Helm Template-Syntax

### Variablen verwenden

```yaml
# Aus values.yaml
image: {{ .Values.image.repository }}:{{ .Values.image.tag }}

# Chart-Informationen
version: {{ .Chart.Version }}
name: {{ .Chart.Name }}

# Release-Informationen
release: {{ .Release.Name }}
namespace: {{ .Release.Namespace }}
```

### Bedingungen (if/else)

```yaml
{{- if .Values.ingress.enabled }}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ .Release.Name }}-ingress
spec:
  # ...
{{- end }}
```

### Schleifen (range)

```yaml
env:
{{- range .Values.env }}
- name: {{ .name }}
  value: {{ .value | quote }}
{{- end }}
```

### Funktionen

```yaml
# String-Funktionen
name: {{ .Values.name | upper }}
name: {{ .Values.name | lower }}
name: {{ .Values.name | quote }}

# Default-Werte
image: {{ .Values.image | default "nginx:alpine" }}

# YAML indentation
labels:
  {{- toYaml .Values.labels | nindent 2 }}
```

### Helper-Templates (_helpers.tpl)

```yaml
{{/*
Expand the name of the chart.
*/}}
{{- define "myapp.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "myapp.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name (include "myapp.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "myapp.labels" -}}
helm.sh/chart: {{ include "myapp.chart" . }}
{{ include "myapp.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
```

## Wichtige Helm Befehle

### Installation & Verwaltung

```bash
# Chart installieren
helm install myrelease ./mychart

# Mit benutzerdefinierten Werten
helm install myrelease ./mychart --values custom-values.yaml

# Werte direkt setzen
helm install myrelease ./mychart --set replicaCount=3

# Mehrere Werte
helm install myrelease ./mychart \
  --set image.tag=2.0 \
  --set service.type=LoadBalancer

# In spezifischem Namespace
helm install myrelease ./mychart --namespace dev --create-namespace

# Dry-run (zeigt generierte YAMLs)
helm install myrelease ./mychart --dry-run --debug

# Chart aus Repository installieren
helm install my-redis bitnami/redis
```

### Releases anzeigen

```bash
# Alle Releases
helm list

# In allen Namespaces
helm list -A

# In spezifischem Namespace
helm list -n dev

# Release-Details
helm status myrelease

# Release-History
helm history myrelease

# Generierte Werte anzeigen
helm get values myrelease

# Alle Infos
helm get all myrelease

# Generiertes Manifest
helm get manifest myrelease
```

### Updates & Rollbacks

```bash
# Release updaten
helm upgrade myrelease ./mychart

# Upgrade mit neuen Werten
helm upgrade myrelease ./mychart --values new-values.yaml

# Install oder Upgrade (wenn nicht existiert, installieren)
helm upgrade --install myrelease ./mychart

# Rollback zur vorherigen Version
helm rollback myrelease

# Rollback zu spezifischer Revision
helm rollback myrelease 3

# Rollback und warten
helm rollback myrelease --wait
```

### Deinstallation

```bash
# Release löschen
helm uninstall myrelease

# Mit History behalten
helm uninstall myrelease --keep-history
```

### Chart-Entwicklung

```bash
# Neues Chart erstellen
helm create mynewchart

# Chart validieren
helm lint ./mychart

# Template-Ausgabe testen
helm template myrelease ./mychart

# Mit spezifischen Werten
helm template myrelease ./mychart --values test-values.yaml

# Chart packen
helm package ./mychart

# Chart-Dependencies aktualisieren
helm dependency update ./mychart
```

### Repositories

```bash
# Repository hinzufügen
helm repo add bitnami https://charts.bitnami.com/bitnami

# Repositories auflisten
helm repo list

# Repository aktualisieren
helm repo update

# Repository entfernen
helm repo remove bitnami

# In Repository suchen
helm search repo nginx

# Hub durchsuchen
helm search hub wordpress
```

### Debugging

```bash
# Dry-run mit Debug-Output
helm install myrelease ./mychart --dry-run --debug

# Template rendern ohne Installation
helm template myrelease ./mychart --debug

# Release-Status prüfen
helm status myrelease

# Logs anzeigen (erfordert Plugin)
helm get manifest myrelease | kubectl apply --dry-run=client -f -
```

## values.yaml überschreiben

### Priorität (höchste zuerst):

1. `--set` Parameter
2. `-f / --values` Dateien (letzte gewinnt)
3. `values.yaml` im Chart

### Beispiele:

```bash
# Eine Datei
helm install myapp ./chart -f prod-values.yaml

# Mehrere Dateien (später überschreibt früher)
helm install myapp ./chart \
  -f base-values.yaml \
  -f prod-values.yaml

# Kombination
helm install myapp ./chart \
  -f prod-values.yaml \
  --set image.tag=v2.0.1
```

## Umgebungs-spezifische Werte

### values-dev.yaml
```yaml
replicaCount: 1
ingress:
  host: dev.myapp.com
resources:
  limits:
    memory: 256Mi
```

### values-prod.yaml
```yaml
replicaCount: 5
ingress:
  host: myapp.com
resources:
  limits:
    memory: 1Gi
autoscaling:
  enabled: true
```

### Deployment:
```bash
# Development
helm install myapp ./chart -f values-dev.yaml

# Production
helm install myapp ./chart -f values-prod.yaml
```

## Abhängigkeiten verwalten

### Chart.yaml
```yaml
dependencies:
  - name: postgresql
    version: "12.1.0"
    repository: https://charts.bitnami.com/bitnami
    condition: postgresql.enabled
  - name: redis
    version: "17.0.0"
    repository: https://charts.bitnami.com/bitnami
    condition: redis.enabled
```

### values.yaml
```yaml
postgresql:
  enabled: true
  auth:
    username: myuser
    password: mypassword
    database: mydb

redis:
  enabled: false
```

### Dependencies installieren:
```bash
helm dependency update ./mychart
```

## Hooks

Helm Hooks erlauben Aktionen zu bestimmten Zeitpunkten:

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ .Release.Name }}-db-migration
  annotations:
    "helm.sh/hook": pre-install,pre-upgrade
    "helm.sh/hook-weight": "0"
    "helm.sh/hook-delete-policy": hook-succeeded
spec:
  template:
    spec:
      containers:
      - name: migration
        image: {{ .Values.migration.image }}
        command: ["./migrate.sh"]
      restartPolicy: Never
```

**Hook-Typen:**
- `pre-install`: Vor Installation
- `post-install`: Nach Installation
- `pre-upgrade`: Vor Upgrade
- `post-upgrade`: Nach Upgrade
- `pre-delete`: Vor Löschung
- `post-delete`: Nach Löschung
- `pre-rollback`: Vor Rollback
- `post-rollback`: Nach Rollback

## Best Practices

### 1. Sinnvolle Defaults in values.yaml

Stelle sicher, dass das Chart mit Default-Werten funktioniert.

### 2. Dokumentation

Kommentiere `values.yaml` ausführlich:

```yaml
# Number of replicas for the deployment
# @default -- 2
replicaCount: 2
```

### 3. NOTES.txt erstellen

```
# templates/NOTES.txt
Thank you for installing {{ .Chart.Name }}.

Your release is named {{ .Release.Name }}.

To access your application:
{{- if .Values.ingress.enabled }}
  http://{{ .Values.ingress.host }}
{{- else }}
  kubectl port-forward svc/{{ include "myapp.fullname" . }} 8080:80
{{- end }}
```

### 4. Validierung mit _helpers.tpl

```yaml
{{- if and .Values.persistence.enabled (not .Values.persistence.storageClass) }}
  {{- fail "persistence.storageClass is required when persistence is enabled" }}
{{- end }}
```

### 5. Semantic Versioning

Chart-Versionen sollten [SemVer](https://semver.org/) folgen.

### 6. .helmignore nutzen

```
# .helmignore
.git/
.idea/
*.tmp
*.bak
```

## Troubleshooting

```bash
# Chart nicht installiert?
helm lint ./mychart

# Template-Fehler?
helm template myrelease ./mychart --debug

# Release fehlgeschlagen?
helm status myrelease
helm get manifest myrelease
kubectl get events

# Werte-Überschreibung funktioniert nicht?
helm get values myrelease

# Dependencies fehlen?
helm dependency update ./mychart
```

## Weiterführende Ressourcen

- [Offizielle Helm Dokumentation](https://helm.sh/docs/)
- [Artifact Hub](https://artifacthub.io/) - Chart Repository
- [Helm Best Practices](https://helm.sh/docs/chart_best_practices/)
# IDEs
.idea/
.vscode/
*.iml
*.iws
*.ipr

# OS
.DS_Store
Thumbs.db

# Build outputs
target/
dist/
build/
out/

# Dependencies
node_modules/
.pnpm-store/

# Environment files
.env
.env.local
.env.*.local

# Logs
*.log
logs/

# Temporary files
*.tmp
*.temp
*.swp
*.swo
*~

# Docker
.dockerignore

# Maven
.mvn/
!.mvn/wrapper/maven-wrapper.jar

# npm
package-lock.json
yarn.lock
pnpm-lock.yaml

