import { defineStore } from 'pinia'
import { ref } from 'vue'
import { mockApi } from '../api/mock'

export const useLeagueStore = defineStore('league', () => {
  const leagues = ref([])
  const summaryStats = ref(null)
  const isLoading = ref(true)

  async function fetchLeagues() {
    isLoading.value = true
    try {
      const [leaguesRes, statsRes] = await Promise.all([
        mockApi.getLeagues(),
        mockApi.getLeagueSummaryStats()
      ])
      leagues.value = leaguesRes.data
      summaryStats.value = statsRes
    } catch (error) {
      console.error('Failed to fetch leagues data:', error)
    } finally {
      isLoading.value = false
    }
  }

  return {
    leagues,
    summaryStats,
    isLoading,
    fetchLeagues
  }
})
