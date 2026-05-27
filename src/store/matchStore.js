import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { api } from '../api/index'

export const useMatchStore = defineStore('match', () => {
  const matches = ref([])
  const weeklyLeaders = ref([])
  const isLoading = ref(false)
  const isLoadMoreLoading = ref(false)
  const selectedTournament = ref(null) // ID выбранного турнира
  
  const currentPage = ref(1)
  const lastPage = ref(1)

  const hasMoreMatches = computed(() => currentPage.value < lastPage.value)

  /**
   * Загрузить матчи для выбранного турнира и еженедельных лидеров (первая страница)
   */
  async function fetchMatchesData() {
    if (!selectedTournament.value) {
      matches.value = []
      weeklyLeaders.value = []
      return
    }

    isLoading.value = true
    currentPage.value = 1
    try {
      const [matchesRes, leadersRes] = await Promise.all([
        api.getGamesByTournament(selectedTournament.value, { page: 1 }), 
        api.getWeeklyLeaders(selectedTournament.value)
      ])
      matches.value = matchesRes.data
      weeklyLeaders.value = leadersRes
      
      if (matchesRes.meta) {
        lastPage.value = matchesRes.meta.last_page || 1
      }
    } catch (error) {
      console.error('Failed to fetch matches data:', error)
    } finally {
      isLoading.value = false
    }
  }

  /**
   * Подгрузить следующую страницу матчей
   */
  async function fetchMoreMatches() {
    if (!selectedTournament.value || !hasMoreMatches.value || isLoadMoreLoading.value) return

    isLoadMoreLoading.value = true
    const nextPage = currentPage.value + 1
    
    try {
      const response = await api.getGamesByTournament(selectedTournament.value, { page: nextPage })
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
    selectedTournament,
    currentPage,
    lastPage,
    hasMoreMatches,
    fetchMatchesData,
    fetchMoreMatches
  }
})
