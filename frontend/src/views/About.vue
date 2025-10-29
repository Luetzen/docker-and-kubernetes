<template>
  <div class="about">
    <h2>Docker & Kubernetes Lernprojekt</h2>

    <div class="info-card">
      <h3>🎯 Über dieses Projekt</h3>
      <p>
        Dieses Projekt demonstriert eine vollständige Microservice-Architektur
        mit Docker und Kubernetes (k3s).
      </p>
    </div>

    <div class="info-card">
      <h3>🛠️ Technologie-Stack</h3>
      <div class="tech-grid">
        <div class="tech-item">
          <strong>Frontend</strong>
          <ul>
            <li>Vue.js 3</li>
            <li>TypeScript</li>
            <li>Vite 5</li>
            <li>Pinia</li>
          </ul>
        </div>
        <div class="tech-item">
          <strong>Backend</strong>
          <ul>
            <li>Spring Boot 3</li>
            <li>Java 21</li>
            <li>Spring Data JPA</li>
            <li>REST API</li>
          </ul>
        </div>
        <div class="tech-item">
          <strong>Datenbank</strong>
          <ul>
            <li>Oracle Database</li>
            <li>Express Edition</li>
          </ul>
        </div>
        <div class="tech-item">
          <strong>DevOps</strong>
          <ul>
            <li>Docker</li>
            <li>Kubernetes (k3s)</li>
            <li>Helm Charts</li>
          </ul>
        </div>
      </div>
    </div>

    <div class="info-card">
      <h3>📚 Lernziele</h3>
      <ul>
        <li>Multi-stage Docker Builds erstellen</li>
        <li>Container-Sicherheit mit Distroless Images</li>
        <li>Kubernetes Deployments, Services und Ingress</li>
        <li>ConfigMaps und Secrets verwalten</li>
        <li>Helm Charts für einfache Deployments</li>
        <li>Health Checks und Monitoring</li>
      </ul>
    </div>

    <div class="info-card" v-if="backendInfo">
      <h3>ℹ️ Backend Information</h3>
      <div class="backend-info">
        <p><strong>Application:</strong> {{ backendInfo.application }}</p>
        <p><strong>Version:</strong> {{ backendInfo.version }}</p>
        <p><strong>Description:</strong> {{ backendInfo.description }}</p>
      </div>
    </div>

    <div class="info-card" v-if="health">
      <h3>💚 Health Status</h3>
      <div class="health-status" :class="health.status.toLowerCase()">
        <p><strong>Status:</strong> {{ health.status }}</p>
        <p><strong>Service:</strong> {{ health.service }}</p>
        <p><strong>Timestamp:</strong> {{ formatTimestamp(health.timestamp) }}</p>
      </div>
    </div>

    <div v-if="error" class="alert alert-error">
      {{ error }}
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
import apiClient from '@/services/api'
import type { HealthResponse, InfoResponse } from '@/types'

const health = ref<HealthResponse | null>(null)
const backendInfo = ref<InfoResponse | null>(null)
const error = ref<string | null>(null)

onMounted(async () => {
  try {
    const [healthRes, infoRes] = await Promise.all([
      apiClient.get('/api/health'),
      apiClient.get('/api/info')
    ])
    health.value = healthRes.data
    backendInfo.value = infoRes.data
  } catch (e: any) {
    error.value = 'Backend nicht erreichbar. Stelle sicher, dass der Backend-Service läuft.'
    console.error(e)
  }
})

function formatTimestamp(timestamp: number): string {
  return new Date(timestamp).toLocaleString('de-DE')
}
</script>

<style scoped>
.about {
  padding: 2rem 0;
  max-width: 900px;
  margin: 0 auto;
}

h2 {
  margin-bottom: 2rem;
  color: #2c3e50;
}

.info-card {
  background: white;
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  padding: 1.5rem;
  margin-bottom: 1.5rem;
}

.info-card h3 {
  margin-top: 0;
  color: #2c3e50;
  margin-bottom: 1rem;
}

.info-card ul {
  margin: 0;
  padding-left: 1.5rem;
}

.info-card li {
  margin-bottom: 0.5rem;
}

.tech-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1.5rem;
  margin-top: 1rem;
}

.tech-item strong {
  display: block;
  margin-bottom: 0.5rem;
  color: #3498db;
}

.tech-item ul {
  margin: 0;
  padding-left: 1.25rem;
}

.backend-info p {
  margin: 0.5rem 0;
}

.health-status {
  padding: 1rem;
  border-radius: 4px;
  background: #d4edda;
  border: 1px solid #c3e6cb;
}

.health-status.up {
  background: #d4edda;
  border-color: #c3e6cb;
}

.health-status.down {
  background: #f8d7da;
  border-color: #f5c6cb;
}

.health-status p {
  margin: 0.5rem 0;
}
</style>

