# Docker Grundlagen 🐳

## Was ist Docker?

Docker ist eine Plattform zur Containerisierung von Anwendungen. Container sind leichtgewichtige, eigenständige und ausführbare Softwarepakete, die alles enthalten, was zum Ausführen einer Anwendung erforderlich ist.

## Vorteile von Docker

- **Portabilität**: "Works on my machine" war gestern
- **Isolation**: Jede Anwendung läuft in ihrer eigenen Umgebung
- **Effizienz**: Schnellerer Start als VMs
- **Konsistenz**: Gleiche Umgebung in Dev, Test und Production

## Docker Architektur

```
┌─────────────────────────────────────┐
│         Docker Client               │
│  (docker build, docker run, etc.)   │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│         Docker Daemon               │
│  (dockerd - verwaltet Container)    │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│         Container Runtime           │
│         (containerd, runc)          │
└─────────────────────────────────────┘
```

## Wichtige Docker Konzepte

### 1. Image
Ein **Image** ist eine schreibgeschützte Vorlage mit Anweisungen zum Erstellen eines Containers.

### 2. Container
Ein **Container** ist eine laufende Instanz eines Images.

### 3. Dockerfile
Ein **Dockerfile** ist ein Textdokument mit Anweisungen zum Erstellen eines Images.

### 4. Registry
Eine **Registry** ist ein Repository für Docker Images (z.B. Docker Hub).

## Dockerfile Grundlagen

### Beispiel: Einfaches Dockerfile

```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

### Wichtige Dockerfile Befehle

| Befehl | Beschreibung | Beispiel |
|--------|--------------|----------|
| `FROM` | Basis-Image festlegen | `FROM node:20-alpine` |
| `WORKDIR` | Arbeitsverzeichnis setzen | `WORKDIR /app` |
| `COPY` | Dateien kopieren | `COPY . .` |
| `ADD` | Dateien kopieren + entpacken | `ADD archive.tar.gz /app` |
| `RUN` | Befehl während Build ausführen | `RUN npm install` |
| `CMD` | Standardbefehl beim Start | `CMD ["npm", "start"]` |
| `ENTRYPOINT` | Hauptprozess definieren | `ENTRYPOINT ["node"]` |
| `ENV` | Umgebungsvariable setzen | `ENV NODE_ENV=production` |
| `EXPOSE` | Port dokumentieren | `EXPOSE 8080` |
| `VOLUME` | Mount-Point definieren | `VOLUME /data` |
| `ARG` | Build-Argument | `ARG VERSION=1.0` |

## Multi-Stage Builds

Multi-Stage Builds reduzieren die Image-Größe erheblich:

```dockerfile
# --- BUILDER STAGE ---
FROM maven:3.9.9 as builder
WORKDIR /app
COPY . .
RUN mvn clean package

# --- FINAL STAGE ---
FROM amazoncorretto:21-alpine
COPY --from=builder /app/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]
```

**Vorteile:**
- Kleinere finale Images
- Build-Dependencies nicht im finalen Image
- Schnellere Deployments

## Wichtige Docker CLI Befehle

### Image Verwaltung

```bash
# Image bauen
docker build -t myapp:1.0 .

# Image bauen mit Build-Argument
docker build --build-arg APP_VERSION=v1.0 -t myapp:1.0 .

# Images auflisten
docker images

# Image löschen
docker rmi myapp:1.0

# Image pushen
docker push myregistry.com/myapp:1.0

# Image pullen
docker pull nginx:alpine

# Image inspizieren
docker inspect myapp:1.0

# Image History anzeigen
docker history myapp:1.0
```

### Container Verwaltung

```bash
# Container starten
docker run -d -p 8080:8080 --name mycontainer myapp:1.0

# Container mit Umgebungsvariablen
docker run -e DB_HOST=localhost -e DB_PORT=5432 myapp:1.0

# Container mit Volume
docker run -v /host/path:/container/path myapp:1.0

# Laufende Container anzeigen
docker ps

# Alle Container anzeigen (auch gestoppte)
docker ps -a

# Container stoppen
docker stop mycontainer

# Container starten
docker start mycontainer

# Container neu starten
docker restart mycontainer

# Container löschen
docker rm mycontainer

# Container Logs anzeigen
docker logs mycontainer

# Container Logs folgen
docker logs -f mycontainer

# In Container einsteigen
docker exec -it mycontainer /bin/sh

# Container inspizieren
docker inspect mycontainer

# Container Ressourcenverbrauch
docker stats mycontainer
```

### System Verwaltung

```bash
# Gesamtsystem Info
docker info

# Disk-Usage anzeigen
docker system df

# Ungenutzte Ressourcen aufräumen
docker system prune

# Alles aufräumen (inkl. Volumes)
docker system prune -a --volumes

# Nur ungenutzte Images löschen
docker image prune

# Nur gestoppte Container löschen
docker container prune

# Nur ungenutzte Volumes löschen
docker volume prune
```

## Docker Compose

Docker Compose ermöglicht die Definition von Multi-Container-Anwendungen.

### docker-compose.yml Beispiel

```yaml
version: '3.8'

services:
  backend:
    build: ./backend
    ports:
      - "8080:8080"
    environment:
      - DB_HOST=database
      - DB_PORT=1521
    depends_on:
      - database

  frontend:
    build: ./frontend
    ports:
      - "8081:80"
    depends_on:
      - backend

  database:
    image: container-registry.oracle.com/database/express:21.3.0-xe
    ports:
      - "1521:1521"
    environment:
      - ORACLE_PWD=MyPassword123
    volumes:
      - db-data:/opt/oracle/oradata

volumes:
  db-data:
```

### Docker Compose Befehle

```bash
# Services starten
docker-compose up -d

# Services stoppen
docker-compose down

# Services neu bauen
docker-compose build

# Services neu bauen und starten
docker-compose up -d --build

# Logs anzeigen
docker-compose logs -f

# Logs eines Services
docker-compose logs -f backend

# Services auflisten
docker-compose ps

# Service skalieren
docker-compose up -d --scale backend=3

# In Service einsteigen
docker-compose exec backend /bin/sh
```

## Best Practices

### 1. Kleinste Basis-Images verwenden

```dockerfile
# ❌ Schlecht: 200+ MB
FROM node:20

# ✅ Gut: ~50 MB
FROM node:20-alpine
```

### 2. .dockerignore nutzen

Verhindert, dass unnötige Dateien ins Image kopiert werden:

```
node_modules
.git
.env
*.log
```

### 3. Layer Caching optimieren

```dockerfile
# ✅ Dependencies zuerst (ändern sich selten)
COPY package.json package-lock.json ./
RUN npm install

# Code danach (ändert sich oft)
COPY . .
```

### 4. Nicht als Root laufen

```dockerfile
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

USER appuser
```

### 5. Multi-Stage Builds nutzen

Siehe Beispiel oben.

### 6. Health Checks definieren

```dockerfile
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:8080/health || exit 1
```

### 7. Build-Argumente für Flexibilität

```dockerfile
ARG NODE_VERSION=20
FROM node:${NODE_VERSION}-alpine
```

## Sicherheit

### Image-Sicherheit prüfen

```bash
# Mit Docker Scout
docker scout cves myapp:1.0

# Mit Trivy
trivy image myapp:1.0
```

### Sicherheits-Best-Practices

1. **Distroless Images** verwenden (nur Runtime, kein Package Manager)
2. **Nicht als Root** laufen
3. **Secrets nicht im Image** speichern
4. **Images regelmäßig aktualisieren**
5. **Nur vertrauenswürdige Base Images** nutzen
6. **Image Scanning** in CI/CD Pipeline

## Troubleshooting

```bash
# Container startet nicht? Logs prüfen:
docker logs mycontainer

# Container-Details anzeigen:
docker inspect mycontainer

# In Container einsteigen (Debug):
docker run -it --entrypoint /bin/sh myapp:1.0

# Ressourcen-Probleme?
docker stats

# Netzwerk-Probleme?
docker network inspect bridge

# Volume-Probleme?
docker volume ls
docker volume inspect myvolume
```

## Weiterführende Ressourcen

- [Offizielle Docker Dokumentation](https://docs.docker.com/)
- [Docker Hub](https://hub.docker.com/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)

