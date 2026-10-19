import { defineStore } from 'pinia'
import { ref, computed, watch } from 'vue'
import { api } from '../api/index'

export const useTournamentStore = defineStore('tournament', () => {
  // Список для селекторов: summary, дополненный полями из basic
  const tournaments = ref([])
  const isTournamentsLoading = ref(true)
  // Выбор общий для всех страниц и переживает перезагрузку
  const selectedTournamentId = ref(Number(localStorage.getItem('selectedTournamentId')) || null)

  // Турниры одной лиги для страницы Tournaments
  const leagueTournaments = ref([])
  const summaryStats = ref(null)
  const isLoading = ref(false)
  const selectedLeague = ref(null) // ID выбранной лиги

  const filteredTournaments = computed(() => {
    // Фильтрация по лиге происходит на бэкенде
    return leagueTournaments.value
  })

  watch(selectedTournamentId, (newValue) => {
    if (newValue) {
      localStorage.setItem('selectedTournamentId', newValue.toString())
    }
  })

  // Турнир с лучшим тиром (наименьшее число); без тира — в конец
  function pickDefaultTournament(list) {
    return [...list].sort((a, b) => (a.tier || 99) - (b.tier || 99))[0]
  }

  /**
   * Загрузить список турниров для селекторов и выбрать турнир по умолчанию
   */
  async function fetchTournaments() {
    // Список общий для всех страниц — второй раз не грузим
    if (tournaments.value.length > 0) return

    isTournamentsLoading.value = true
    try {
      // regulation_duration есть только в basic, teams_count/games_count — только в summary
      const [basicRes, summaryRes] = await Promise.all([
        api.getTournaments(),
        api.getTournamentsSummary()
      ])

      const basicMap = new Map(basicRes.data.map(t => [t.id, t]))

      tournaments.value = summaryRes.data.map(summaryTournament => {
        const basic = basicMap.get(Number(summaryTournament.id))
        if (basic) {
          summaryTournament.regulationDuration = basic.regulationDuration
          summaryTournament.startAt = basic.startAt
          summaryTournament.endAt = basic.endAt
          summaryTournament.leagueId = basic.leagueId
        }
        return summaryTournament
      })

      // Сохранённый турнир мог пропасть из списка
      const exists = tournaments.value.some(t => t.id === selectedTournamentId.value)
      if (!exists && tournaments.value.length > 0) {
        selectedTournamentId.value = pickDefaultTournament(tournaments.value).id
      }
    } catch (error) {
      console.error('Failed to fetch tournaments:', error)
    } finally {
      isTournamentsLoading.value = false
    }
  }

  function setTournament(id) {
    selectedTournamentId.value = id
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
      leagueTournaments.value = response.data
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
    isTournamentsLoading,
    selectedTournamentId,
    fetchTournaments,
    setTournament,
    leagueTournaments,
    summaryStats,
    isLoading,
    selectedLeague,
    filteredTournaments,
    fetchTournamentsData,
    fetchGlobalSummary
  }
})
