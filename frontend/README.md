# Vue.js 3 Frontend 🎨

Ein modernes Vue.js 3 Frontend mit TypeScript und Vite für das Docker & Kubernetes Lernprojekt.

## Technologien

- **Vue.js 3** - Composition API
- **TypeScript** - Type Safety
- **Vite 5** - Ultra-schneller Build
- **Pinia** - State Management
- **Vue Router** - Routing
- **Axios** - HTTP Client

## Features

- ✅ Produktverwaltung (CRUD)
- ✅ TypeScript für Type Safety
- ✅ Responsive Design
- ✅ State Management mit Pinia
- ✅ API Integration
- ✅ Health Check Anzeige

## Projekt-Setup

### Voraussetzungen

- Node.js 20+
- npm oder yarn

### Installation

```bash
# Dependencies installieren
npm install

# Development Server starten (mit Hot-Reload)
npm run dev

# Production Build
npm run build

# Production Build Preview
npm run preview
```

Die Anwendung läuft dann auf: http://localhost:8081

## Umgebungsvariablen

Erstelle eine `.env` Datei (siehe `.env.example`):

```env
VITE_API_URL=http://localhost:8080/api
VITE_APP_VERSION=1.0.0
```

| Variable | Beschreibung | Default |
|----------|--------------|---------|
| `VITE_API_URL` | Backend API URL | `http://localhost:8080/api` |
| `VITE_APP_VERSION` | App Version | `1.0.0` |

## Docker

### Image bauen

```bash
docker build -t frontend:1.0.0 --build-arg APP_VERSION=1.0.0 .
```

**Image Größe:** ~45-50 MB (Nginx + gebündelte App)

### Container starten

```bash
# Standalone
docker run -d \
  -p 8081:80 \
  -e BACKEND_URL=http://backend:8080 \
  --name frontend \
  frontend:1.0.0

# Windows (cmd)
docker run -d ^
  -p 8081:80 ^
  -e BACKEND_URL=http://host.docker.internal:8080 ^
  --name frontend ^
  frontend:1.0.0
```

### Umgebungsvariablen (Container)

| Variable | Beschreibung | Default |
|----------|--------------|---------|
| `BACKEND_URL` | Backend URL für Nginx Proxy | `http://backend:8080` |

## Projekt-Struktur

```
frontend/
├── src/
│   ├── assets/           # CSS, Bilder
│   ├── components/       # Vue Komponenten
│   ├── router/           # Vue Router Konfiguration
│   ├── services/         # API Services
│   ├── stores/           # Pinia Stores
│   ├── types/            # TypeScript Types
│   ├── views/            # Seiten-Komponenten
│   ├── App.vue           # Root Komponente
│   └── main.ts           # Entry Point
├── public/               # Statische Dateien
├── Dockerfile            # Docker Build
├── default.conf          # Nginx Konfiguration
├── entrypoint.sh         # Container Startskript
├── vite.config.ts        # Vite Konfiguration
└── package.json          # Dependencies
```

## Entwicklung

### Neuen Service hinzufügen

```typescript
// src/services/myService.ts
import apiClient from './api'

export const myService = {
  async getData() {
    const response = await apiClient.get('/endpoint')
    return response.data
  }
}
```

### Neuen Store hinzufügen

```typescript
// src/stores/myStore.ts
import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useMyStore = defineStore('my', () => {
  const data = ref([])
  
  async function fetchData() {
    // ...
  }
  
  return { data, fetchData }
})
```

### Neue Route hinzufügen

```typescript
// src/router/index.ts
{
  path: '/my-route',
  name: 'myRoute',
  component: () => import('../views/MyView.vue')
}
```

## Build Optimierungen

### Vite Build

- ✅ Code Splitting
- ✅ Tree Shaking
- ✅ Minification
- ✅ Asset Optimization

### Nginx

- ✅ Gzip Compression
- ✅ Static Asset Caching
- ✅ Security Headers
- ✅ SPA Routing Support

## API Integration

Das Frontend kommuniziert mit dem Backend über REST API:

```typescript
// services/productService.ts
import apiClient from './api'

export const productService = {
  async getAll() {
    const response = await apiClient.get('/products')
    return response.data
  },
  // ...
}
```

## Debugging

### Development

```bash
# Mit Logs
npm run dev

# Browser DevTools nutzen
# Vue DevTools Extension installieren
```

### Production (Docker)

```bash
# Container Logs
docker logs -f frontend

# In Container einsteigen
docker exec -it frontend /bin/sh

# Nginx Config prüfen
docker exec frontend cat /etc/nginx/conf.d/default.conf
```

## Deployment

### Mit Docker Compose

Siehe `docker-compose.yml` im Root-Verzeichnis.

### Mit Kubernetes

Siehe `kubernetes/` und `helm/` Verzeichnisse.

## Browser-Unterstützung

- Chrome (letzte 2 Versionen)
- Firefox (letzte 2 Versionen)
- Safari (letzte 2 Versionen)
- Edge (letzte 2 Versionen)

## Performance

- Lighthouse Score: 90+
- First Contentful Paint: < 1s
- Time to Interactive: < 2s
- Bundle Size: < 200KB (gzipped)

## Sicherheit

- ✅ XSS Protection Headers
- ✅ CORS konfiguriert
- ✅ Content Security Policy
- ✅ No sensitive data in frontend
- ✅ Environment-based configuration

## Nächste Schritte

1. Backend verbinden
2. In Docker Compose integrieren
3. In Kubernetes deployen
4. Monitoring hinzufügen

