# Kubernetes Befehls-Referenz ☸️

## Ressourcen anzeigen

```bash
# Alle Ressourcen im Namespace
kubectl get all -n fullstack-app

# Pods
kubectl get pods -n fullstack-app

# Mit mehr Details
kubectl get pods -o wide -n fullstack-app

# Services
kubectl get svc -n fullstack-app

# Deployments
kubectl get deployments -n fullstack-app

# Ingress
kubectl get ingress -n fullstack-app

# PVC
kubectl get pvc -n fullstack-app
```

## Ressourcen deployen

```bash
# Einzelne Datei
kubectl apply -f deployment.yaml

# Verzeichnis
kubectl apply -f kubernetes/

# Löschen
kubectl delete -f kubernetes/
```

## Logs & Debugging

```bash
# Pod Logs
kubectl logs <pod-name> -n fullstack-app

# Logs folgen
kubectl logs -f deployment/backend -n fullstack-app

# Pod beschreiben
kubectl describe pod <pod-name> -n fullstack-app

# In Pod einsteigen
kubectl exec -it <pod-name> -n fullstack-app -- /bin/sh

# Events anzeigen
kubectl get events -n fullstack-app --sort-by=.metadata.creationTimestamp
```

## Skalierung

```bash
# Manuell skalieren
kubectl scale deployment/backend --replicas=5 -n fullstack-app

# Autoscaling Status
kubectl get hpa -n fullstack-app
```

## Updates & Rollbacks

```bash
# Image updaten
kubectl set image deployment/backend backend=backend:2.0.0 -n fullstack-app

# Rollout Status
kubectl rollout status deployment/backend -n fullstack-app

# Rollout History
kubectl rollout history deployment/backend -n fullstack-app

# Rollback
kubectl rollout undo deployment/backend -n fullstack-app
```

## Port-Forwarding

```bash
# Service
kubectl port-forward svc/frontend-service 8081:80 -n fullstack-app

# Pod
kubectl port-forward pod/<pod-name> 8080:8080 -n fullstack-app
```

## Nützliche Befehle

```bash
# Namespace erstellen
kubectl create namespace dev

# ConfigMap aus Datei
kubectl create configmap app-config --from-file=config.properties -n fullstack-app

# Secret erstellen
kubectl create secret generic app-secret --from-literal=password=secret123 -n fullstack-app

# Ressourcen-Nutzung
kubectl top nodes
kubectl top pods -n fullstack-app

# YAML generieren (ohne erstellen)
kubectl create deployment my-dep --image=nginx --dry-run=client -o yaml
```

## Cleanup

```bash
# Namespace löschen (löscht alle Ressourcen darin)
kubectl delete namespace fullstack-app

# Einzelne Ressourcen
kubectl delete deployment backend -n fullstack-app
```

