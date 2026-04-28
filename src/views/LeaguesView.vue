<script setup>
import { onMounted, computed } from 'vue'
import { useLeagueStore } from '../store/leagueStore'
import LeagueCard from '../components/leagues/LeagueCard.vue'
import SummaryStatistics from '../components/leagues/SummaryStatistics.vue'

const leagueStore = useLeagueStore()

const summaryItems = computed(() => {
  if (!leagueStore.summaryStats) return []
  return [
    { label: 'Total Data Points', value: leagueStore.summaryStats.totalDataPoints },
    { label: 'Active Leagues', value: leagueStore.summaryStats.activeLeagues },
    { label: 'Tracked Players', value: leagueStore.summaryStats.trackedPlayers },
    { label: 'Total Matches', value: leagueStore.summaryStats.totalMatches }
  ]
})

onMounted(() => {
  leagueStore.fetchLeagues()
})
</script>

<template>
  <div class="p-lg lg:p-xl flex flex-col gap-jumbo">
    <!-- Header matching Dashboard Style -->
    <div class="border-b-2 border-border-dark pb-sm">
      <div class="flex justify-between items-center">
        <h2 class="font-h1 text-h1 text-primary uppercase">LEAGUES</h2>
        
        <!-- Action Buttons matching leagues.html but with neo-brutalist style -->
        <div class="hidden sm:flex gap-4">
          <button class="px-4 py-2 bg-primary text-white border-2 border-border-dark shadow-[4px_4px_0px_0px_rgba(254,106,52,1)] font-label-caps uppercase text-sm hover:translate-x-[-2px] hover:translate-y-[-2px] transition-all cursor-pointer">
            ALL REGIONS
          </button>
          <button class="px-4 py-2 bg-surface-white text-primary border-2 border-border-dark font-label-caps uppercase text-sm hover:bg-ghost-gray transition-all cursor-pointer">
            FILTERS
          </button>
        </div>
      </div>
      
      <div class="mt-xs">
        <p class="font-body-lg text-body-lg text-on-surface-variant">
          Explore our comprehensive directory of tracked professional and collegiate basketball leagues.
        </p>
      </div>
    </div>

    <!-- Main Content State -->
    <template v-if="!leagueStore.isLoading">
      <!-- 4-COLUMN BENTO GRID -->
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-lg">
        <LeagueCard 
          v-for="league in leagueStore.leagues" 
          :key="league.id" 
          :league="league" 
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
      <p class="font-data-mono text-data-mono uppercase animate-pulse">Loading league directory...</p>
    </div>
  </div>
</template>
