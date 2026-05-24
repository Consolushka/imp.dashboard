<script setup>
import { onMounted, computed, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useTournamentStore } from '../store/tournamentStore'
import { useLeagueStore } from '../store/leagueStore'
import TournamentCard from '../components/tournaments/TournamentCard.vue'
import PrimarySelector from '../components/ui/forms/PrimarySelector.vue'
import SummaryStatistics from '../components/leagues/SummaryStatistics.vue'

const tournamentStore = useTournamentStore()
const leagueStore = useLeagueStore()
const route = useRoute()
const router = useRouter()

const summaryItems = computed(() => {
  if (!tournamentStore.summaryStats) return []
  return [
    { label: 'Total Data Points', value: tournamentStore.summaryStats.totalDataPoints },
    { label: 'Active Leagues', value: tournamentStore.summaryStats.activeLeagues || 'N/A' },
    { label: 'Tracked Players', value: tournamentStore.summaryStats.trackedPlayers },
    { label: 'Total Matches', value: tournamentStore.summaryStats.totalMatches }
  ]
})

onMounted(async () => {
  // Загружаем лиги (только список для селектора), если их еще нет
  if (leagueStore.leagues.length === 0) {
    await leagueStore.fetchLeagues()
  }
  
  // Инициализируем фильтр из query параметров ПЕРЕД загрузкой данных
  initializeFilters()

  // Загружаем данные турниров и общую стату параллельно
  await Promise.all([
    tournamentStore.fetchTournamentsData(),
    tournamentStore.fetchGlobalSummary()
  ])
})

const initializeFilters = () => {
  if (route.query.league) {
    tournamentStore.selectedLeague = Number(route.query.league)
  } else if (leagueStore.leagues.length > 0) {
    // По умолчанию выбрана первая лига
    tournamentStore.selectedLeague = leagueStore.leagues[0].id
  }
}

// Следим за внешними изменениями URL (например, при переходе с другой страницы)
watch(() => route.query.league, (newVal) => {
  if (newVal) {
    tournamentStore.selectedLeague = Number(newVal)
  }
})

// Синхронизируем изменения фильтра с URL и перезагружаем данные
watch(() => tournamentStore.selectedLeague, (newVal, oldVal) => {
  // Синхронизация с URL
  if (newVal) {
    router.replace({ query: { ...route.query, league: newVal } })
  } else {
    router.replace({ query: { ...route.query, league: undefined } })
  }

  // Перезагрузка данных, если значение реально изменилось (и это не первый запуск)
  if (newVal !== oldVal && oldVal !== undefined) {
    tournamentStore.fetchTournamentsData()
  }
})
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
        
        <!-- Leagues Filter (Single-Select) -->
        <PrimarySelector 
          v-model="tournamentStore.selectedLeague"
          :options="leagueStore.leagues"
          label-key="name"
          value-key="id"
          label="SELECT LEAGUE"
        />
      </div>
    </div>

    <!-- Main Content State -->
    <template v-if="!tournamentStore.isLoading">
      <!-- Tournament Grid -->
      <div v-if="tournamentStore.filteredTournaments.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-lg">
        <TournamentCard 
          v-for="tournament in tournamentStore.filteredTournaments" 
          :key="tournament.id" 
          :tournament="tournament" 
        />
      </div>
      
      <!-- Empty State -->
      <div v-else class="flex flex-col items-center justify-center min-h-[300px] border-2 border-dashed border-border-dark bg-ghost-gray">
        <span class="material-symbols-outlined text-6xl text-neutral-medium mb-4">search_off</span>
        <p class="font-h3 text-h3 uppercase text-neutral-medium">No tournaments found for this league</p>
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
