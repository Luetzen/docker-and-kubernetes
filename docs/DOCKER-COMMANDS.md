# Docker Befehls-Referenz 🐳

## Image Verwaltung

```cmd
REM Image bauen
docker build -t backend:1.0.0 .

REM Mit Build-Argument
docker build -t backend:1.0.0 --build-arg APP_VERSION=1.0.0 .

REM Images auflisten
docker images

REM Image löschen
docker rmi backend:1.0.0

REM Alle ungenutzten Images löschen
docker image prune -a
```

## Container Verwaltung

```cmd
REM Container starten
docker run -d -p 8080:8080 --name backend backend:1.0.0

REM Mit Umgebungsvariablen
docker run -d -p 8080:8080 ^
  -e DB_HOST=localhost ^
  -e DB_PASSWORD=secret ^
  --name backend backend:1.0.0

REM Laufende Container anzeigen
docker ps

REM Alle Container anzeigen
docker ps -a

REM Container stoppen
docker stop backend

REM Container starten
docker start backend

REM Container löschen
docker rm backend

REM Container Logs
docker logs -f backend

REM In Container einsteigen
docker exec -it backend /bin/sh
```

## Docker Compose

```cmd
REM Services starten
docker-compose up -d

REM Mit Rebuild
docker-compose up -d --build

REM Stoppen
docker-compose down

REM Stoppen und Volumes löschen
docker-compose down -v

REM Logs anzeigen
docker-compose logs -f

REM Logs eines Services
docker-compose logs -f backend

REM Status
docker-compose ps

REM Service neu starten
docker-compose restart backend
```

## Aufräumen

```cmd
REM Gestoppte Container löschen
docker container prune

REM Ungenutzte Images löschen
docker image prune -a

REM Volumes löschen
docker volume prune

REM Alles aufräumen
docker system prune -a --volumes
```

## Nützliche Befehle

```cmd
REM Disk Usage
docker system df

REM Image inspizieren
docker inspect backend:1.0.0

REM Container Ressourcen
docker stats

REM Image History
docker history backend:1.0.0

REM Image speichern
docker save backend:1.0.0 -o backend.tar

REM Image laden
docker load -i backend.tar
```

