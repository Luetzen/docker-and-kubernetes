import axios from 'axios'

// Dynamische Backend-URL:
// - Auf Laptop (localhost): http://localhost:8080
// - Auf Handy (192.168.x.x): http://192.168.x.x:8080
// - In Docker (frontend.local): http://backend.local
const getBackendUrl = () => {
  // Wenn VITE_API_URL gesetzt ist, nutze das
  if (import.meta.env.VITE_API_URL) {
    return import.meta.env.VITE_API_URL
  }

  // Sonst: Dynamisch basierend auf dem aktuellen Hostname
  const hostname = window.location.hostname

  // Wenn über localhost zugegriffen wird
  if (hostname === 'localhost' || hostname === '127.0.0.1') {
    return 'http://localhost:8081'
  }

  // Wenn über frontend.local zugegriffen wird (Docker Compose)
  if (hostname === 'frontend.local') {
    return 'http://backend.local:8081'
  }

  // Wenn über myapp.local zugegriffen wird (Kubernetes)
  if (hostname === 'myapp.local') {
    return 'http://myapp.local'
  }

  // Sonst: Nutze die gleiche IP wie das Frontend, aber Port 8080
  return `http://${hostname}:8080`
}

const apiClient = axios.create({
  baseURL: getBackendUrl(),
  headers: {
    'Content-Type': 'application/json'
  },
  timeout: 10000
})

// Request Interceptor
apiClient.interceptors.request.use(
  (config) => {
    console.log(`[API] ${config.method?.toUpperCase()} ${config.url}`)
    return config
  },
  (error) => {
    return Promise.reject(error)
  }
)

// Response Interceptor
apiClient.interceptors.response.use(
  (response) => {
    return response
  },
  (error) => {
    console.error('[API Error]', error.response?.data || error.message)
    return Promise.reject(error)
  }
)

export default apiClient

