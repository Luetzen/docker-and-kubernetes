<template>
  <div id="app">
    <header>
      <nav class="navbar">
        <div class="container">
          <h1 class="logo">🐳 Docker & Kubernetes Lernprojekt</h1>
          <div class="nav-links">
            <router-link to="/">Produkte</router-link>
            <router-link to="/about">Info</router-link>
          </div>
        </div>
      </nav>
    </header>

    <main class="container">
      <router-view />
    </main>

    <footer>
      <div class="container">
        <p>Version: {{ version }}</p>
      </div>
    </footer>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

const version = computed(() => {
  return __APP_VERSION__
})
</script>

<style>
/* Siehe assets/main.css */
</style>

