# Docker multi-stage build

# --- BUILDER STAGE ---
# Nutzt Maven Image zum Bauen der Anwendung
FROM maven:3.9.9-eclipse-temurin-21 as builder

# Build-Argument für die Version
ARG APP_VERSION=1.0.0

# Arbeitsverzeichnis setzen
WORKDIR /build

# pom.xml zuerst kopieren (für besseres Layer Caching)
COPY pom.xml .

# Dependencies downloaden (wird gecacht, wenn pom.xml sich nicht ändert)
RUN mvn dependency:go-offline -B

# Source Code kopieren
COPY src ./src

# Anwendung bauen
RUN mvn clean package -DskipTests -Drevision=${APP_VERSION}

# --- FINAL STAGE ---
# Nutzt schlankes JRE Image für die Laufzeit
FROM amazoncorretto:21-alpine

# Metadaten
LABEL maintainer="luetzen.nahne@gmail.com"
LABEL description="Spring Boot Backend für Docker & Kubernetes Lernprojekt"

# Arbeitsverzeichnis
WORKDIR /app

# JAR aus Builder Stage kopieren
COPY --from=builder /build/target/*.jar app.jar

# Non-root User erstellen (Sicherheit)
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup && \
    chown -R appuser:appgroup /app

# Als Non-root User ausführen
USER appuser

# Port expose (Dokumentation)
EXPOSE 8080

# Health Check
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/api/health || exit 1

# Umgebungsvariablen für JVM
ENV JAVA_OPTS="-Xms256m -Xmx512m"

# Anwendung starten
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app/app.jar"]

