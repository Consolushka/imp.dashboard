<script setup>
import { useMetricStore } from '../store/metricStore'
import { RouterLink } from 'vue-router'

const metricStore = useMetricStore()
</script>

<template>
  <nav class="main-nav">
    <div class="nav-links">
      <RouterLink to="/">Dashboard</RouterLink>
      <RouterLink to="/ideology">Ideology</RouterLink>
    </div>
    
    <div class="metric-switcher">
      <span>Active Metric: <strong>{{ metricStore.activeMetric }}</strong></span>
      <button @click="metricStore.toggleMetric()">Toggle to {{ metricStore.activeMetric === 'IMP' ? 'Reliability' : 'IMP' }}</button>
    </div>
  </nav>
</template>

<style scoped>
.main-nav {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.nav-links {
  display: flex;
  gap: 20px;
}

.nav-links a {
  text-decoration: none;
  color: #333;
  font-weight: 500;
}

.nav-links a.router-link-active {
  color: #000;
  border-bottom: 2px solid #000;
}

.metric-switcher {
  display: flex;
  align-items: center;
  gap: 15px;
  background: #eee;
  padding: 5px 15px;
  border-radius: 20px;
  font-size: 0.9rem;
}

button {
  cursor: pointer;
  padding: 3px 10px;
  border-radius: 5px;
  border: 1px solid #ccc;
}
</style>
