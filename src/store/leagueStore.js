import { defineStore } from 'pinia'
import { ref } from 'vue'
import { api } from '../api/index'

export const useLeagueStore = defineStore('league', () => {
  const leagues = ref([])
  const summaryStats = ref(null)
  const isLoading = ref(false)

  /**
   * Загрузить простой список лиг (для селекторов)
   */
  async function fetchLeagues() {
    isLoading.value = true
    try {
      const response = await api.getLeagues()
      leagues.value = response.data
    } catch (error) {
      console.error('Failed to fetch leagues list:', error)
    } finally {
      isLoading.value = false
    }
  }

  /**
   * Загрузить лиги с агрегатами и глобальную статистику (для Leagues View)
   */
  async function fetchLeaguesWithSummary() {
    isLoading.value = true
    try {
      const [leaguesRes, statsRes] = await Promise.all([
        api.getLeaguesSummary(),
        api.getGlobalSummary()
      ])
      leagues.value = leaguesRes.data
      summaryStats.value = statsRes
    } catch (error) {
      console.error('Failed to fetch leagues summary data:', error)
    } finally {
      isLoading.value = false
    }
  }

  return {
    leagues,
    summaryStats,
    isLoading,
    fetchLeagues,
    fetchLeaguesWithSummary
  }
})
