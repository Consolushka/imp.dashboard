import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { mockApi } from '../api/mock'

export const useTournamentStore = defineStore('tournament', () => {
  const tournaments = ref([])
  const summaryStats = ref(null)
  const isLoading = ref(true)
  const selectedLeagues = ref([]) // Массив выбранных ID лиг

  const filteredTournaments = computed(() => {
    if (selectedLeagues.value.length === 0) return tournaments.value
    return tournaments.value.filter(t => selectedLeagues.value.includes(t.leagueId))
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

  function toggleLeague(leagueId) {
    const index = selectedLeagues.value.indexOf(leagueId)
    if (index > -1) {
      selectedLeagues.value.splice(index, 1)
    } else {
      selectedLeagues.value.push(leagueId)
    }
  }

  return {
    tournaments,
    summaryStats,
    isLoading,
    selectedLeagues,
    filteredTournaments,
    fetchTournamentsData,
    toggleLeague
  }
})
