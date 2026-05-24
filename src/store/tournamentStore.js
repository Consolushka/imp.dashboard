import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { api } from '../api/index'

export const useTournamentStore = defineStore('tournament', () => {
  const tournaments = ref([])
  const summaryStats = ref(null)
  const isLoading = ref(false)
  const selectedLeague = ref(null) // ID выбранной лиги

  const filteredTournaments = computed(() => {
    // Теперь фильтрация происходит на бэкенде, 
    // поэтому просто возвращаем загруженные данные.
    return tournaments.value
  })

  /**
   * Загрузить простой список турниров (для селекторов)
   */
  async function fetchTournaments() {
    isLoading.value = true
    try {
      const response = await api.getTournaments()
      tournaments.value = response.data
    } catch (error) {
      console.error('Failed to fetch tournaments list:', error)
    } finally {
      isLoading.value = false
    }
  }

  /**
   * Загрузить турниры со статистикой (для Tournaments View)
   */
  async function fetchTournamentsData() {
    isLoading.value = true
    try {
      const params = {}
      if (selectedLeague.value) {
        params.league_id = selectedLeague.value
      }
      const response = await api.getTournamentsSummary(params)
      tournaments.value = response.data
    } catch (error) {
      console.error('Failed to fetch tournaments summary:', error)
    } finally {
      isLoading.value = false
    }
  }

  /**
   * Загрузить глобальную статистику системы
   */
  async function fetchGlobalSummary() {
    try {
      summaryStats.value = await api.getGlobalSummary()
    } catch (error) {
      console.error('Failed to fetch global summary:', error)
    }
  }

  return {
    tournaments,
    summaryStats,
    isLoading,
    selectedLeague,
    filteredTournaments,
    fetchTournaments,
    fetchTournamentsData,
    fetchGlobalSummary
  }
})
