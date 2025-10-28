# Kubernetes Grundlagen ☸️

## Was ist Kubernetes?

Kubernetes (K8s) ist ein Open-Source-System zur Automatisierung der Bereitstellung, Skalierung und Verwaltung von containerisierten Anwendungen.

## Warum Kubernetes?

- **Automatische Skalierung**: Horizontal Pod Autoscaling
- **Self-Healing**: Automatischer Neustart fehlgeschlagener Container
- **Load Balancing**: Intelligente Verkehrsverteilung
- **Rollouts & Rollbacks**: Sichere Deployments
- **Service Discovery**: Automatische DNS-Einträge
- **Secret Management**: Sichere Verwaltung sensibler Daten

## Kubernetes Architektur

```
┌─────────────────────────────────────────────────────┐
│                 CONTROL PLANE                        │
│  ┌──────────┐  ┌──────────┐  ┌───────────────────┐ │
│  │   API    │  │ Scheduler│  │ Controller Manager│ │
│  │  Server  │  │          │  │                   │ │
│  └──────────┘  └──────────┘  └───────────────────┘ │
│  ┌──────────┐                                       │
│  │   etcd   │ (Datenspeicher)                       │
│  └──────────┘                                       │
└─────────────────────────────────────────────────────┘
                       │
        ┌──────────────┼──────────────┐
        ▼              ▼              ▼
┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│   NODE 1     │ │   NODE 2     │ │   NODE 3     │
│ ┌──────────┐ │ │ ┌──────────┐ │ │ ┌──────────┐ │
│ │ kubelet  │ │ │ │ kubelet  │ │ │ │ kubelet  │ │
│ └──────────┘ │ │ └──────────┘ │ │ └──────────┘ │
│ ┌──────────┐ │ │ ┌──────────┐ │ │ ┌──────────┐ │
│ │kube-proxy│ │ │ │kube-proxy│ │ │ │kube-proxy│ │
│ └──────────┘ │ │ └──────────┘ │ │ └──────────┘ │
│   [Pods]     │ │   [Pods]     │ │   [Pods]     │
└──────────────┘ └──────────────┘ └──────────────┘
```

## Wichtige Kubernetes Ressourcen

### 1. Pod
Der kleinste deploybare Einheit in Kubernetes.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: app
    image: nginx:alpine
    ports:
    - containerPort: 80
```

### 2. Deployment
Verwaltet ReplicaSets und ermöglicht deklarative Updates.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: app
        image: myapp:1.0
        ports:
        - containerPort: 8080
```

### 3. Service
Macht Pods im Cluster oder extern erreichbar.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  type: ClusterIP  # oder NodePort, LoadBalancer
  selector:
    app: myapp
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8080
```

**Service Types:**
- **ClusterIP**: Nur innerhalb des Clusters erreichbar
- **NodePort**: Über Node-IP:Port erreichbar
- **LoadBalancer**: Externer Load Balancer (Cloud Provider)
- **ExternalName**: DNS CNAME Record

### 4. Ingress
HTTP(S) Routing zu Services.

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-ingress
spec:
  rules:
  - host: myapp.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: frontend-service
            port:
              number: 80
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: backend-service
            port:
              number: 8080
```

### 5. ConfigMap
Konfigurationsdaten als Key-Value Paare.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  database.host: "db-service"
  database.port: "1521"
  log.level: "INFO"
```

**Nutzung in Pods:**

```yaml
# Als Umgebungsvariable
env:
- name: DB_HOST
  valueFrom:
    configMapKeyRef:
      name: app-config
      key: database.host

# Als Volume
volumes:
- name: config
  configMap:
    name: app-config
```

### 6. Secret
Sensible Daten (Passwörter, Tokens, Keys).

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
type: Opaque
data:
  password: cGFzc3dvcmQxMjM=  # base64 encoded
stringData:
  username: admin  # wird automatisch encoded
```

**Nutzung:**

```yaml
env:
- name: DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: app-secret
      key: password
```

### 7. PersistentVolume & PersistentVolumeClaim
Persistente Speicherung.

```yaml
# PersistentVolumeClaim
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: database-pvc
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
```

**Nutzung in Pod:**

```yaml
volumes:
- name: data
  persistentVolumeClaim:
    claimName: database-pvc
```

## Wichtige kubectl Befehle

### Cluster Info

```bash
# Cluster-Info anzeigen
kubectl cluster-info

# Nodes anzeigen
kubectl get nodes

# Node-Details
kubectl describe node <node-name>

# Cluster-Version
kubectl version
```

### Ressourcen verwalten

```bash
# Ressourcen erstellen
kubectl apply -f deployment.yaml

# Mehrere Dateien
kubectl apply -f kubernetes/

# Aus einem Verzeichnis rekursiv
kubectl apply -f kubernetes/ -R

# Ressourcen löschen
kubectl delete -f deployment.yaml

# Ressource nach Name löschen
kubectl delete deployment my-deployment

# Alle Ressourcen in Namespace löschen
kubectl delete all --all -n mynamespace
```

### Ressourcen anzeigen

```bash
# Alle Pods anzeigen
kubectl get pods

# Pods in allen Namespaces
kubectl get pods -A

# Pods mit mehr Details
kubectl get pods -o wide

# Pod-Details
kubectl describe pod <pod-name>

# Alle Ressourcen anzeigen
kubectl get all

# Spezifische Ressourcen
kubectl get deployments
kubectl get services
kubectl get ingress
kubectl get configmaps
kubectl get secrets
kubectl get pvc

# Als YAML ausgeben
kubectl get deployment my-deployment -o yaml

# Als JSON ausgeben
kubectl get pod my-pod -o json
```

### Logs & Debugging

```bash
# Pod Logs anzeigen
kubectl logs <pod-name>

# Logs folgen (tail -f)
kubectl logs -f <pod-name>

# Logs von einem Container in Multi-Container Pod
kubectl logs <pod-name> -c <container-name>

# Letzte X Zeilen
kubectl logs --tail=100 <pod-name>

# In Pod einsteigen
kubectl exec -it <pod-name> -- /bin/sh

# In spezifischen Container einsteigen
kubectl exec -it <pod-name> -c <container-name> -- /bin/sh

# Befehl in Pod ausführen
kubectl exec <pod-name> -- ls /app

# Port-Forwarding (für lokales Testing)
kubectl port-forward pod/<pod-name> 8080:8080
kubectl port-forward service/<service-name> 8080:80

# Events anzeigen
kubectl get events --sort-by=.metadata.creationTimestamp

# Ressourcen-Nutzung
kubectl top nodes
kubectl top pods
```

### Deployments verwalten

```bash
# Deployment erstellen/updaten
kubectl apply -f deployment.yaml

# Image updaten
kubectl set image deployment/my-deployment app=myapp:2.0

# Rollout-Status prüfen
kubectl rollout status deployment/my-deployment

# Rollout-History anzeigen
kubectl rollout history deployment/my-deployment

# Zu vorheriger Version zurück
kubectl rollout undo deployment/my-deployment

# Zu spezifischer Revision
kubectl rollout undo deployment/my-deployment --to-revision=2

# Deployment skalieren
kubectl scale deployment/my-deployment --replicas=5

# Autoscaling einrichten
kubectl autoscale deployment/my-deployment --min=2 --max=10 --cpu-percent=80

# Deployment pausieren
kubectl rollout pause deployment/my-deployment

# Deployment fortsetzen
kubectl rollout resume deployment/my-deployment

# Deployment neu starten
kubectl rollout restart deployment/my-deployment
```

### Namespaces

```bash
# Namespaces anzeigen
kubectl get namespaces

# Namespace erstellen
kubectl create namespace dev

# Namespace löschen
kubectl delete namespace dev

# In Namespace arbeiten
kubectl get pods -n dev

# Standard-Namespace setzen
kubectl config set-context --current --namespace=dev
```

### ConfigMaps & Secrets

```bash
# ConfigMap aus Datei erstellen
kubectl create configmap app-config --from-file=config.properties

# ConfigMap aus Literal
kubectl create configmap app-config --from-literal=key1=value1

# Secret erstellen
kubectl create secret generic app-secret --from-literal=password=secret123

# Secret aus Datei
kubectl create secret generic app-secret --from-file=./credentials.txt

# Secret anzeigen (base64 decoded)
kubectl get secret app-secret -o jsonpath='{.data.password}' | base64 --decode
```

### Nützliche Befehle

```bash
# YAML-Vorlage generieren (ohne anzulegen)
kubectl create deployment my-dep --image=nginx --dry-run=client -o yaml > deployment.yaml

# Ressource editieren
kubectl edit deployment my-deployment

# Ressource patchen
kubectl patch deployment my-deployment -p '{"spec":{"replicas":3}}'

# Label hinzufügen
kubectl label pods my-pod env=production

# Label entfernen
kubectl label pods my-pod env-

# Annotation hinzufügen
kubectl annotate pods my-pod description="My description"

# Pods nach Label filtern
kubectl get pods -l app=myapp

# Mehrere Labels
kubectl get pods -l 'app=myapp,env=prod'

# Kopieren von/zu Pod
kubectl cp /local/file <pod-name>:/remote/path
kubectl cp <pod-name>:/remote/file /local/path
```

## k3s Spezifische Befehle

k3s ist eine leichtgewichtige Kubernetes Distribution.

```bash
# k3s installieren (Linux)
curl -sfL https://get.k3s.io | sh -

# k3s Status prüfen
sudo systemctl status k3s

# kubectl nutzen (in k3s)
sudo k3s kubectl get pods

# kubeconfig exportieren
sudo cat /etc/rancher/k3s/k3s.yaml > ~/.kube/config

# k3s deinstallieren
/usr/local/bin/k3s-uninstall.sh
```

## Best Practices

### 1. Ressourcen Limits setzen

```yaml
resources:
  requests:
    memory: "64Mi"
    cpu: "250m"
  limits:
    memory: "128Mi"
    cpu: "500m"
```

### 2. Liveness & Readiness Probes

```yaml
livenessProbe:
  httpGet:
    path: /health
    port: 8080
  initialDelaySeconds: 30
  periodSeconds: 10

readinessProbe:
  httpGet:
    path: /ready
    port: 8080
  initialDelaySeconds: 5
  periodSeconds: 5
```

### 3. Labels & Selectors konsistent verwenden

```yaml
metadata:
  labels:
    app: myapp
    component: backend
    version: v1.0
    environment: production
```

### 4. Namespaces für Isolation

Trenne Umgebungen: `dev`, `staging`, `production`

### 5. SecurityContext nutzen

```yaml
securityContext:
  runAsNonRoot: true
  runAsUser: 1000
  readOnlyRootFilesystem: true
  capabilities:
    drop:
    - ALL
```

### 6. ConfigMaps & Secrets nicht hardcoden

Nutze externe Konfiguration statt Werte im Code.

## Deployment Strategien

### Rolling Update (Standard)

```yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 0
```

### Recreate

```yaml
strategy:
  type: Recreate
```

### Blue-Green mit Services

Zwei Deployments, Service zeigt auf eins.

### Canary Deployments

Schrittweise Traffic-Umleitung zu neuer Version.

## Troubleshooting

```bash
# Pod startet nicht?
kubectl describe pod <pod-name>
kubectl logs <pod-name>

# ImagePullBackOff?
# -> Image-Name prüfen, Registry-Credentials?

# CrashLoopBackOff?
# -> Logs prüfen, Liveness-Probe korrekt?

# Service nicht erreichbar?
kubectl get endpoints <service-name>
# -> Selector korrekt? Pods laufen?

# Ingress funktioniert nicht?
kubectl describe ingress <ingress-name>
# -> Ingress Controller installiert?

# DNS Probleme?
kubectl run -it --rm debug --image=busybox --restart=Never -- nslookup my-service
```

## Weiterführende Ressourcen

- [Offizielle Kubernetes Dokumentation](https://kubernetes.io/docs/)
- [k3s Dokumentation](https://docs.k3s.io/)
- [Kubernetes Best Practices](https://kubernetes.io/docs/concepts/configuration/overview/)

