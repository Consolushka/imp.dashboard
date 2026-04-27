import { defineStore } from 'pinia'
import { ref, watch } from 'vue'
import { mockApi } from '../api/mock'

export const useMetricStore = defineStore('metric', () => {
  // Инициализируем из localStorage.
  const savedValue = localStorage.getItem('globalReliabilityOn')
  const globalReliabilityOn = ref(savedValue === 'true')

  // Турниры
  const tournaments = ref([])
  const isTournamentsLoading = ref(true)
  const selectedTournamentId = ref(Number(localStorage.getItem('selectedTournamentId')) || null)

  // Следим за изменениями и сохраняем в localStorage
  watch(globalReliabilityOn, (newValue) => {
    localStorage.setItem('globalReliabilityOn', newValue.toString())
  })

  watch(selectedTournamentId, (newValue) => {
    if (newValue) {
      localStorage.setItem('selectedTournamentId', newValue.toString())
    }
  })

  async function fetchTournaments() {
    isTournamentsLoading.value = true
    try {
      const response = await mockApi.getTournaments()
      tournaments.value = response.data
      
      // Проверяем, существует ли сохраненный ID в загруженном списке
      const exists = tournaments.value.some(t => t.id === selectedTournamentId.value)
      if (!exists && tournaments.value.length > 0) {
        selectedTournamentId.value = tournaments.value[0].id
      }
    } catch (error) {
      console.error('Failed to fetch tournaments:', error)
    } finally {
      isTournamentsLoading.value = false
    }
  }

  function toggleReliability() {
    globalReliabilityOn.value = !globalReliabilityOn.value
  }

  function setReliability(value) {
    globalReliabilityOn.value = !!value
  }

  function setTournament(id) {
    selectedTournamentId.value = id
  }

  return { 
    globalReliabilityOn, 
    tournaments,
    isTournamentsLoading,
    selectedTournamentId,
    fetchTournaments,
    toggleReliability, 
    setReliability,
    setTournament
  }
})
