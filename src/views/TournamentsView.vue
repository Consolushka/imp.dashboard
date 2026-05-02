<script setup>
import { onMounted, computed, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useTournamentStore } from '../store/tournamentStore'
import { useLeagueStore } from '../store/leagueStore'
import TournamentCard from '../components/tournaments/TournamentCard.vue'
import PrimaryMultiselector from '../components/ui/forms/PrimaryMultiselector.vue'
import SummaryStatistics from '../components/leagues/SummaryStatistics.vue'

const tournamentStore = useTournamentStore()
const leagueStore = useLeagueStore()
const route = useRoute()
const router = useRouter()

const summaryItems = computed(() => {
  if (!tournamentStore.summaryStats) return []
  return [
    { label: 'Total Data Points', value: tournamentStore.summaryStats.totalDataPoints },
    { label: 'Active Tournaments', value: tournamentStore.summaryStats.activeTournaments },
    { label: 'Tracked Players', value: tournamentStore.summaryStats.trackedPlayers },
    { label: 'Total Matches', value: tournamentStore.summaryStats.totalMatches }
  ]
})

onMounted(async () => {
  // Загружаем лиги, если их еще нет в сторе
  if (leagueStore.leagues.length === 0) {
    await leagueStore.fetchLeagues()
  }
  
  // Загружаем данные турниров
  await tournamentStore.fetchTournamentsData()

  // Инициализируем фильтр из query параметров
  initializeFilters()
})

const initializeFilters = () => {
  if (route.query.leagues) {
    const ids = route.query.leagues.split(',').map(Number)
    tournamentStore.selectedLeagues = ids
  } else {
    // Если параметра нет — показываем все (выделяем все чекбоксы)
    tournamentStore.selectedLeagues = leagueStore.leagues.map(l => l.id)
  }
}

// Следим за внешними изменениями URL (например, при переходе с другой страницы)
watch(() => route.query.leagues, () => {
  initializeFilters()
})

// Синхронизируем изменения фильтра с URL
watch(() => tournamentStore.selectedLeagues, (newVal) => {
  const allIds = leagueStore.leagues.map(l => l.id)
  
  // Если выбраны все лиги или список пуст (что тоже трактуем как "все"), убираем query параметр
  const isAllSelected = allIds.length > 0 && newVal.length === allIds.length && allIds.every(id => newVal.includes(id))
  
  if (isAllSelected || newVal.length === 0) {
    router.replace({ query: { ...route.query, leagues: undefined } })
  } else {
    router.replace({ query: { ...route.query, leagues: newVal.join(',') } })
  }
}, { deep: true })
</script>

<template>
  <div class="p-lg lg:p-xl flex flex-col gap-jumbo">
    <!-- Header matching Dashboard/Leagues Style -->
    <div class="border-b-2 border-border-dark pb-sm">
      <div class="flex flex-col md:flex-row md:items-end md:justify-between gap-md">
        <div>
          <h2 class="font-h1 text-h1 text-primary uppercase">TOURNAMENTS</h2>
          <p class="font-body-lg text-body-lg text-on-surface-variant mt-xs">
            Browse and filter active basketball tournaments from all tracked leagues.
          </p>
        </div>
        
        <!-- Leagues Filter (Multi-Select) -->
        <PrimaryMultiselector 
          v-model="tournamentStore.selectedLeagues"
          :options="leagueStore.leagues"
          label-key="name"
          value-key="id"
          label="SELECT LEAGUES"
        />
      </div>
    </div>

    <!-- Main Content State -->
    <template v-if="!tournamentStore.isLoading">
      <!-- Tournament Grid -->
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-lg">
        <TournamentCard 
          v-for="tournament in tournamentStore.filteredTournaments" 
          :key="tournament.id" 
          :tournament="tournament" 
        />
      </div>

      <!-- Footer Statistics -->
      <SummaryStatistics 
        v-if="summaryItems.length > 0" 
        :items="summaryItems" 
      />
    </template>

    <!-- Loading State -->
    <div v-else class="flex flex-col items-center justify-center min-h-[400px] gap-4">
      <div class="w-16 h-16 border-4 border-border-dark border-t-secondary-container rounded-full animate-spin"></div>
      <p class="font-data-mono text-data-mono uppercase animate-pulse">Scanning tournament clusters...</p>
    </div>
  </div>
</template>
