import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { mockApi } from '../api/mock'

export const useTournamentStore = defineStore('tournament', () => {
  const tournaments = ref([])
  const summaryStats = ref(null)
  const isLoading = ref(true)
  const selectedLeague = ref(null) // ID выбранной лиги

  const filteredTournaments = computed(() => {
    if (!selectedLeague.value) return tournaments.value
    return tournaments.value.filter(t => t.leagueId === selectedLeague.value)
  })

  async function fetchTournamentsData() {
    isLoading.value = true
    try {
      const [tournamentsRes, statsRes] = await Promise.all([
        mockApi.getTournaments(),
        mockApi.getTournamentSummaryStats()
      ])
      tournaments.value = tournamentsRes.data
      summaryStats.value = statsRes
    } catch (error) {
      console.error('Failed to fetch tournaments data:', error)
    } finally {
      isLoading.value = false
    }
  }

  return {
    tournaments,
    summaryStats,
    isLoading,
    selectedLeague,
    filteredTournaments,
    fetchTournamentsData
  }
})
