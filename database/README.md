# Oracle Database für Docker & Kubernetes

Oracle Database Express Edition für das Lernprojekt.

## Setup

### Mit Docker starten

```bash
docker run -d \
  --name oracle-db \
  -p 1521:1521 \
  -e ORACLE_PWD=Oracle123 \
  -v oracle-data:/opt/oracle/oradata \
  container-registry.oracle.com/database/express:21.3.0-xe
```

Windows (cmd):
```cmd
docker run -d ^
  --name oracle-db ^
  -p 1521:1521 ^
  -e ORACLE_PWD=Oracle123 ^
  -v oracle-data:/opt/oracle/oradata ^
  container-registry.oracle.com/database/express:21.3.0-xe
```

### Verbindungsdaten

- **Host:** localhost
- **Port:** 1521
- **Service Name:** FREEPDB1 (Pluggable DB)
- **User:** appuser
- **Password:** Oracle123

### Initialisierung

Nach dem Start des Containers kann das Init-Skript ausgeführt werden:

```bash
# In Container einsteigen
docker exec -it oracle-db bash

# Als appuser verbinden
sqlplus appuser/Oracle123@FREEPDB1

# Init-Skript ausführen
@/opt/oracle/scripts/init.sql
```

Oder direkt:

```bash
docker exec -i oracle-db sqlplus -s appuser/Oracle123@FREEPDB1 < init.sql
```

### Health Check

```bash
docker exec oracle-db healthcheck.sh
```

## Mit Docker Compose

Siehe `docker-compose.yml` im Root-Verzeichnis.

## Persistente Daten

Daten werden im Volume `oracle-data` gespeichert und bleiben auch nach Neustart erhalten.

## Troubleshooting

### Container startet nicht

```bash
# Logs prüfen
docker logs oracle-db

# Container entfernen und neu starten
docker rm -f oracle-db
```

### Verbindung fehlgeschlagen

1. Warte 1-2 Minuten nach Container-Start (Initialisierung)
2. Prüfe, ob Port 1521 erreichbar ist
3. Prüfe Service Name: FREEPDB1 (für gvenzl/oracle-free Image!)

### Daten zurücksetzen

```bash
# Container und Volume löschen
docker rm -f oracle-db
docker volume rm oracle-data

# Neu starten
docker run ...
```

