# Spring Boot Backend 🍃

Eine Spring Boot REST API mit Oracle Datenbankanbindung für das Docker & Kubernetes Lernprojekt.

## Technologien

- **Java 21**
- **Spring Boot 3.2.5**
- **Spring Data JPA**
- **Oracle Database**
- **Maven**
- **Lombok**

## Features

- ✅ REST API für Produktverwaltung
- ✅ CRUD Operationen (Create, Read, Update, Delete)
- ✅ Oracle Datenbankanbindung
- ✅ Validation
- ✅ Health Checks
- ✅ Cross-Origin Support (CORS)

## API Endpoints

### Products

| Method | Endpoint | Beschreibung |
|--------|----------|--------------|
| GET | `/api/products` | Alle Produkte abrufen |
| GET | `/api/products/{id}` | Produkt nach ID abrufen |
| POST | `/api/products` | Neues Produkt erstellen |
| PUT | `/api/products/{id}` | Produkt aktualisieren |
| DELETE | `/api/products/{id}` | Produkt löschen |
| GET | `/api/products/search?name={name}` | Produkte nach Name suchen |

### Health & Info

| Method | Endpoint | Beschreibung |
|--------|----------|--------------|
| GET | `/api/health` | Health Status |
| GET | `/api/info` | Anwendungsinformationen |
| GET | `/actuator/health` | Spring Actuator Health |

## Beispiel Requests

### Produkt erstellen (POST)

```json
{
  "name": "Laptop",
  "description": "Gaming Laptop mit RTX 4080",
  "price": 1999.99,
  "stock": 10
}
```

### Produkt aktualisieren (PUT)

```json
{
  "name": "Laptop",
  "description": "Gaming Laptop mit RTX 4090",
  "price": 2499.99,
  "stock": 5
}
```

## Lokale Entwicklung

### Voraussetzungen

- Java 21
- Maven 3.9+
- Oracle Database (oder Docker Container)

### Oracle Database mit Docker starten

```bash
docker run -d ^
  --name oracle-db ^
  -p 1521:1521 ^
  -e ORACLE_PWD=Oracle123 ^
  container-registry.oracle.com/database/express:21.3.0-xe
```

### Anwendung starten

```bash
# Dependencies installieren und bauen
mvn clean install

# Anwendung starten
mvn spring-boot:run

# Mit spezifischem Profil
mvn spring-boot:run -Dspring-boot.run.profiles=docker
```

Die Anwendung läuft dann auf: http://localhost:8080

## Umgebungsvariablen

| Variable | Beschreibung | Default |
|----------|--------------|---------|
| `DB_HOST` | Database Host | `localhost` |
| `DB_PORT` | Database Port | `1521` |
| `DB_SERVICE` | Database Service Name | `FREEPDB1` |
| `DB_USER` | Database User | `appuser` |
| `DB_PASSWORD` | Database Passwort | `Oracle123` |
| `SHOW_SQL` | SQL Queries loggen | `false` |

## Docker

### Standard Image bauen

```bash
docker build -t backend:1.0.0 --build-arg APP_VERSION=1.0.0 .
```

**Image Größe:** ~300-400 MB

### Distroless Image bauen (Minimal & Sicher)

```bash
docker build -f Dockerfile.distroless -t backend:1.0.0-distroless --build-arg APP_VERSION=1.0.0 .
```

**Image Größe:** ~200-250 MB

**Vorteile Distroless:**
- ✅ Kleinere Image-Größe
- ✅ Keine Shell (keine Angriffsfläche)
- ✅ Kein Package Manager
- ✅ Nur Runtime Dependencies
- ✅ Bessere Sicherheit

### Container starten

```bash
# Standard Image
docker run -d ^
  -p 8080:8080 ^
  -e DB_HOST=host.docker.internal ^
  -e DB_PASSWORD=Oracle123 ^
  --name backend ^
  backend:1.0.0

# Distroless Image
docker run -d ^
  -p 8080:8080 ^
  -e DB_HOST=host.docker.internal ^
  -e DB_PASSWORD=Oracle123 ^
  --name backend-distroless ^
  backend:1.0.0-distroless
```

### Logs anzeigen

```bash
docker logs -f backend
```

### In Container einsteigen (nur bei Standard Image)

```bash
docker exec -it backend /bin/sh
```

**Hinweis:** Bei Distroless Image ist kein Shell vorhanden (Sicherheitsfeature)!

## Image Vergleich

### Standard Alpine Image
- **Basis:** `amazoncorretto:21-alpine`
- **Größe:** ~300-400 MB
- **Shell:** ✅ Ja (sh)
- **Package Manager:** ✅ Ja (apk)
- **Debug:** ✅ Einfach
- **Sicherheit:** ⚠️ Mehr Angriffsfläche

### Distroless Image
- **Basis:** `gcr.io/distroless/java21-debian12`
- **Größe:** ~200-250 MB
- **Shell:** ❌ Nein
- **Package Manager:** ❌ Nein
- **Debug:** ⚠️ Schwieriger
- **Sicherheit:** ✅ Minimal Attack Surface

## Testing

```bash
# Unit Tests
mvn test

# Integration Tests
mvn verify

# Mit Coverage
mvn clean test jacoco:report
```

## Produktionsbereite Features

- ✅ Health Checks für Kubernetes
- ✅ Non-root User
- ✅ Environment-based Configuration
- ✅ Graceful Shutdown
- ✅ Actuator Endpoints
- ✅ CORS Configuration
- ✅ Validation
- ✅ Exception Handling
- ✅ Logging

## Nächste Schritte

1. Datenbank initialisieren
2. Mit Frontend verbinden
3. In Kubernetes deployen
4. Monitoring & Logging konfigurieren

