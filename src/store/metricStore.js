import { defineStore } from 'pinia'
import { ref, watch } from 'vue'

export const useMetricStore = defineStore('metric', () => {
  // Инициализируем из localStorage.
  const savedValue = localStorage.getItem('globalReliabilityOn')
  const globalReliabilityOn = ref(savedValue === 'true')

  // Следим за изменениями и сохраняем в localStorage
  watch(globalReliabilityOn, (newValue) => {
    localStorage.setItem('globalReliabilityOn', newValue.toString())
  })

  return {
    globalReliabilityOn
  }
})
