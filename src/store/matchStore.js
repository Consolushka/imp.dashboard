import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { mockApi } from '../api/mock'

export const useMatchStore = defineStore('match', () => {
  const matches = ref([])
  const weeklyLeaders = ref([])
  const isLoading = ref(true)
  const selectedTournament = ref(null) // ID выбранного турнира

  const filteredMatches = computed(() => {
    if (!selectedTournament.value) return matches.value
    return matches.value.filter(m => m.tournamentId === selectedTournament.value)
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
    filteredMatches,
    fetchMatchesData
  }
})
