import { defineStore } from 'pinia'
import { ref, watch } from 'vue'

export const useMetricStore = defineStore('metric', () => {
  // Инициализируем из localStorage. Если там сохранено 'true', значит режим включен.
  const savedValue = localStorage.getItem('globalReliabilityOn')
  const globalReliabilityOn = ref(savedValue === 'true')

  // Следим за изменениями и сохраняем в localStorage
  watch(globalReliabilityOn, (newValue) => {
    localStorage.setItem('globalReliabilityOn', newValue.toString())
  })

  function toggleReliability() {
    globalReliabilityOn.value = !globalReliabilityOn.value
  }

  function setReliability(value) {
    globalReliabilityOn.value = !!value
  }

  return { 
    globalReliabilityOn, 
    toggleReliability, 
    setReliability 
  }
})
