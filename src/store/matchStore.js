import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { api } from '../api/index'
import { useTournamentStore } from './tournamentStore'
import { latestOnly } from '../utils/latestOnly'

export const useMatchStore = defineStore('match', () => {
  const matches = ref([])
  const weeklyLeaders = ref([])
  const isLoading = ref(false)
  const isLoadMoreLoading = ref(false)
  
  const currentPage = ref(1)
  const lastPage = ref(1)

  const hasMoreMatches = computed(() => currentPage.value < lastPage.value)

  const startList = latestOnly()
  // Подгрузка следующей страницы относится к тому списку, что был на экране при её запуске
  let isCurrentList = () => true

  /**
   * Загрузить матчи для выбранного турнира и еженедельных лидеров (первая страница)
   */
  async function fetchMatchesData() {
    const isLatest = startList()
    isCurrentList = isLatest
    const tournamentId = useTournamentStore().selectedTournamentId
    if (!tournamentId) {
      matches.value = []
      weeklyLeaders.value = []
      lastPage.value = 1
      isLoading.value = false
      return
    }

    isLoading.value = true
    currentPage.value = 1
    try {
      const [matchesRes, leadersRes] = await Promise.all([
        api.getGamesByTournament(tournamentId, { page: 1 }), 
        api.getWeeklyLeaders(tournamentId)
      ])
      if (!isLatest()) return
      matches.value = matchesRes.data
      weeklyLeaders.value = leadersRes
      
      if (matchesRes.meta) {
        lastPage.value = matchesRes.meta.last_page || 1
      }
    } catch (error) {
      if (!isLatest()) return
      console.error('Failed to fetch matches data:', error)
      // Иначе при смене турнира остались бы матчи и лидеры предыдущего
      matches.value = []
      weeklyLeaders.value = []
      lastPage.value = 1
    } finally {
      if (isLatest()) isLoading.value = false
    }
  }

  /**
   * Подгрузить следующую страницу матчей
   */
  async function fetchMoreMatches() {
    const tournamentId = useTournamentStore().selectedTournamentId
    if (!tournamentId || !hasMoreMatches.value || isLoadMoreLoading.value) return

    isLoadMoreLoading.value = true
    const nextPage = currentPage.value + 1
    const isSameList = isCurrentList

    try {
      const response = await api.getGamesByTournament(tournamentId, { page: nextPage })
      if (!isSameList()) return
      matches.value = [...matches.value, ...response.data]
      currentPage.value = nextPage
      
      if (response.meta) {
        lastPage.value = response.meta.last_page || lastPage.value
      }
    } catch (error) {
      console.error('Failed to fetch more matches:', error)
    } finally {
      isLoadMoreLoading.value = false
    }
  }

  return {
    matches,
    weeklyLeaders,
    isLoading,
    isLoadMoreLoading,
    currentPage,
    lastPage,
    hasMoreMatches,
    fetchMatchesData,
    fetchMoreMatches
  }
})
