<script setup>
import { onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useMatchStore } from '../store/matchStore'
import { useTournamentStore } from '../store/tournamentStore'
import MatchCard from '../components/matches/MatchCard.vue'
import WeeklyLeaders from '../components/matches/WeeklyLeaders.vue'
import CustomMultiSelect from '../components/ui/CustomMultiSelect.vue'

const matchStore = useMatchStore()
const tournamentStore = useTournamentStore()
const route = useRoute()
const router = useRouter()

onMounted(async () => {
  // Загружаем турниры, если их еще нет (нужны для мультиселекта)
  if (tournamentStore.tournaments.length === 0) {
    await tournamentStore.fetchTournamentsData()
  }
  
  // Загружаем матчи
  await matchStore.fetchMatchesData()

  // Инициализируем фильтр из URL
  initializeFilters()
})

const initializeFilters = () => {
  if (route.query.tournaments) {
    const ids = route.query.tournaments.split(',').map(Number)
    matchStore.selectedTournaments = ids
  } else {
    // По умолчанию выбраны все турниры
    matchStore.selectedTournaments = tournamentStore.tournaments.map(t => t.id)
  }
}

// Следим за внешними изменениями URL
watch(() => route.query.tournaments, initializeFilters)

// Синхронизируем изменения фильтра с URL
watch(() => matchStore.selectedTournaments, (newVal) => {
  const allIds = tournamentStore.tournaments.map(t => t.id)
  const isAllSelected = allIds.length > 0 && newVal.length === allIds.length && allIds.every(id => newVal.includes(id))
  
  if (isAllSelected || newVal.length === 0) {
    router.replace({ query: { ...route.query, tournaments: undefined } })
  } else {
    router.replace({ query: { ...route.query, tournaments: newVal.join(',') } })
  }
}, { deep: true })
</script>

<template>
  <div class="p-lg lg:p-xl flex flex-col gap-jumbo">
    <!-- Header Style matching Dashboard -->
    <div class="border-b-2 border-border-dark pb-sm">
      <div class="flex flex-col md:flex-row md:items-end md:justify-between gap-md">
        <div>
          <h2 class="font-h1 text-h1 text-primary uppercase">MATCH DIRECTORY</h2>
          <p class="font-body-lg text-body-lg text-on-surface-variant mt-xs">
            Review detailed statistical breakdowns and performance data for all recently finalized fixtures.
          </p>
        </div>
        
        <!-- Tournament Filter (Multi-Select with Arrow Icon) -->
        <CustomMultiSelect 
          v-model="matchStore.selectedTournaments"
          :options="tournamentStore.tournaments"
          label-key="name"
          value-key="id"
          label="SELECT TOURNAMENTS"
          icon="expand_more"
        />
      </div>
    </div>

    <!-- Main Content -->
    <template v-if="!matchStore.isLoading">
      <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-xl">
        <MatchCard 
          v-for="match in matchStore.filteredMatches" 
          :key="match.id" 
          :match="match" 
        />
      </div>

      <!-- Weekly Leaders Footer -->
      <WeeklyLeaders :leaders="matchStore.weeklyLeaders" />
    </template>

    <!-- Loading State -->
    <div v-else class="flex flex-col items-center justify-center min-h-[400px] gap-4">
      <div class="w-16 h-16 border-4 border-border-dark border-t-secondary-container rounded-full animate-spin"></div>
      <p class="font-data-mono text-data-mono uppercase animate-pulse">Synchronizing match data...</p>
    </div>
  </div>
</template>
