import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { mockApi } from '../api/mock'

export const useMatchStore = defineStore('match', () => {
  const matches = ref([])
  const weeklyLeaders = ref([])
  const isLoading = ref(true)
  const selectedTournaments = ref([]) // Массив выбранных ID турниров

  const filteredMatches = computed(() => {
    if (selectedTournaments.value.length === 0) return matches.value
    return matches.value.filter(m => selectedTournaments.value.includes(m.tournamentId))
  })

  async function fetchMatchesData() {
    isLoading.value = true
    try {
      const [matchesRes, leadersRes] = await Promise.all([
        // В реальном апи мы бы передавали сюда массив ID турниров
        // Но пока мокаем все игры, которые есть, и фильтруем на фронте
        mockApi.getTournamentGames(null), 
        mockApi.getWeeklyLeaders()
      ])
      matches.value = matchesRes.data.filter(m => m.isFinal) // Только завершенные
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
    selectedTournaments,
    filteredMatches,
    fetchMatchesData
  }
})
