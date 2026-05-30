<script setup>
import { onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useMatchStore } from '../store/matchStore'
import { useTournamentStore } from '../store/tournamentStore'
import MatchCard from '../components/matches/MatchCard.vue'
import WeeklyLeaders from '../components/matches/WeeklyLeaders.vue'
import PrimarySelector from '../components/ui/forms/PrimarySelector.vue'

const matchStore = useMatchStore()
const tournamentStore = useTournamentStore()
const route = useRoute()
const router = useRouter()

onMounted(async () => {
  // Всегда загружаем ПОЛНЫЙ список турниров для селектора,
  // сбрасывая возможные фильтры по лиге, оставшиеся от других страниц
  await tournamentStore.fetchTournaments()
  
  // Инициализируем фильтр из URL
  initializeFilters()

  // Загружаем матчи для выбранного турнира
  if (matchStore.selectedTournament) {
    await matchStore.fetchMatchesData()
  }
})

const initializeFilters = () => {
  if (route.query.tournament) {
    matchStore.selectedTournament = Number(route.query.tournament)
  } else if (tournamentStore.tournaments.length > 0) {
    // По умолчанию выбран первый турнир
    matchStore.selectedTournament = tournamentStore.tournaments[0].id
  }
}

// При смене турнира в селекторе — перезагружаем данные
watch(() => matchStore.selectedTournament, async (newVal) => {
  if (newVal) {
    router.replace({ query: { ...route.query, tournament: newVal } })
    await matchStore.fetchMatchesData()
  } else {
    router.replace({ query: { ...route.query, tournament: undefined } })
  }
})

// Следим за внешними изменениями URL
watch(() => route.query.tournament, (newVal) => {
  if (newVal && Number(newVal) !== matchStore.selectedTournament) {
    matchStore.selectedTournament = Number(newVal)
  }
})
</script>

<template>
  <div class="p-lg lg:p-xl flex flex-col gap-jumbo">
    <!-- Header Style matching Dashboard -->
    <div class="border-b-2 border-border-dark pb-sm">
      <div class="flex flex-col md:flex-row md:items-end md:justify-between gap-md">
        <div>
          <h2 class="font-h1 text-h1 text-primary uppercase">MATCHES</h2>
          <p class="font-body-lg text-body-lg text-on-surface-variant mt-xs">
            Review detailed statistical breakdowns and performance data for all recently finalized fixtures.
          </p>
        </div>
        
        <!-- Tournament Filter (Single-Select) -->
        <PrimarySelector 
          v-model="matchStore.selectedTournament"
          :options="tournamentStore.tournaments"
          label-key="name"
          value-key="id"
          label="SELECT TOURNAMENT"
        />
      </div>
    </div>

    <!-- Main Content -->
    <template v-if="!matchStore.isLoading">
      <div v-if="matchStore.matches.length > 0" class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-xl">
        <MatchCard 
          v-for="match in matchStore.matches" 
          :key="match.id" 
          :match="match" 
        />
      </div>

      <!-- Load More Button -->
      <div v-if="matchStore.hasMoreMatches" class="flex justify-center mt-xl">
        <button 
          @click="matchStore.fetchMoreMatches"
          :disabled="matchStore.isLoadMoreLoading"
          class="px-jumbo py-md bg-white border-4 border-primary shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] font-h3 text-h3 uppercase hover:translate-x-[-4px] hover:translate-y-[-4px] hover:shadow-[12px_12px_0px_0px_rgba(0,0,0,1)] active:translate-x-0 active:translate-y-0 active:shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] transition-all cursor-pointer disabled:opacity-50 disabled:cursor-not-allowed flex items-center gap-4"
        >
          <span v-if="matchStore.isLoadMoreLoading" class="w-6 h-6 border-4 border-primary border-t-secondary-container rounded-full animate-spin"></span>
          {{ matchStore.isLoadMoreLoading ? 'SYNCING...' : 'LOAD MORE FIXTURES' }}
        </button>
      </div>

      <!-- Empty State -->
      <div v-else class="flex flex-col items-center justify-center min-h-[300px] border-2 border-dashed border-border-dark bg-ghost-gray">
        <span class="material-symbols-outlined text-6xl text-neutral-medium mb-4">sports_basketball</span>
        <p class="font-h3 text-h3 uppercase text-neutral-medium">No matches found for this tournament</p>
      </div>

      <!-- Weekly Leaders Footer -->
      <WeeklyLeaders 
        v-if="matchStore.weeklyLeaders && matchStore.weeklyLeaders.length > 0"
        :leaders="matchStore.weeklyLeaders" 
      />
    </template>

    <!-- Loading State -->
    <div v-else class="flex flex-col items-center justify-center min-h-[400px] gap-4">
      <div class="w-16 h-16 border-4 border-border-dark border-t-secondary-container rounded-full animate-spin"></div>
      <p class="font-data-mono text-data-mono uppercase animate-pulse">Synchronizing match data...</p>
    </div>
  </div>
</template>
