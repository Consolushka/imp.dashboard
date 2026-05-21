import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { api } from '../api/index'

export const useMatchStore = defineStore('match', () => {
  const matches = ref([])
  const weeklyLeaders = ref([])
  const isLoading = ref(false)
  const selectedTournament = ref(null) // ID выбранного турнира

  /**
   * Загрузить матчи для выбранного турнира и еженедельных лидеров
   */
  async function fetchMatchesData() {
    if (!selectedTournament.value) {
      matches.value = []
      weeklyLeaders.value = []
      return
    }

    isLoading.value = true
    try {
      const [matchesRes, leadersRes] = await Promise.all([
        api.getGamesByTournament(selectedTournament.value), 
        api.getWeeklyLeaders(selectedTournament.value)
      ])
      matches.value = matchesRes.data
      weeklyLeaders.value = leadersRes
    } catch (error) {
      console.error('Failed to fetch matches data:', error)
    } finally {
      isLoading.value = false
    }
  }

  return {
    matches,
    weeklyLeaders,
    isLoading,
    selectedTournament,
    fetchMatchesData
  }
})
