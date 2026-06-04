import { defineStore } from 'pinia'
import { ref, watch } from 'vue'
import { api } from '../api/index'

export const useMetricStore = defineStore('metric', () => {
  // Инициализируем из localStorage.
  const savedValue = localStorage.getItem('globalReliabilityOn')
  const globalReliabilityOn = ref(savedValue === 'true')

  // Турниры
  const tournaments = ref([])
  const isTournamentsLoading = ref(true)
  const selectedTournamentId = ref(Number(localStorage.getItem('selectedTournamentId')) || null)

  // Следим за изменениями и сохраняем в localStorage
  watch(globalReliabilityOn, (newValue) => {
    localStorage.setItem('globalReliabilityOn', newValue.toString())
  })

  watch(selectedTournamentId, (newValue) => {
    if (newValue) {
      localStorage.setItem('selectedTournamentId', newValue.toString())
    }
  })

  async function fetchTournaments() {
    isTournamentsLoading.value = true
    try {
      // Загружаем основные данные (с regulation_duration) и саммари (с teams_count/games_count) параллельно
      const [basicRes, summaryRes] = await Promise.all([
        api.getTournaments(),
        api.getTournamentsSummary()
      ])

      const basicMap = new Map(basicRes.data.map(t => [t.id, t]))
      
      // Мержим данные из basic в объекты из summary
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
      
      // Проверяем, существует ли сохраненный ID в загруженном списке
      const exists = tournaments.value.some(t => t.id === selectedTournamentId.value)
      if (!exists && tournaments.value.length > 0) {
        // Выбираем турнир с лучшим тиром (наименьшее число)
        const bestTournament = [...tournaments.value].sort((a, b) => (a.tier || 99) - (b.tier || 99))[0]
        selectedTournamentId.value = bestTournament.id
      }
    } catch (error) {
      console.error('Failed to fetch tournaments:', error)
    } finally {
      isTournamentsLoading.value = false
    }
  }

  function toggleReliability() {
    globalReliabilityOn.value = !globalReliabilityOn.value
  }

  function setReliability(value) {
    globalReliabilityOn.value = !!value
  }

  function setTournament(id) {
    selectedTournamentId.value = id
  }

  return { 
    globalReliabilityOn, 
    tournaments,
    isTournamentsLoading,
    selectedTournamentId,
    fetchTournaments,
    toggleReliability, 
    setReliability,
    setTournament
  }
})
