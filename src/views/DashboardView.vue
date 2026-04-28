<script setup>
import { onMounted } from 'vue'
import { useMetricStore } from '../store/metricStore'
import RecentMatches from '../components/dashboard/RecentMatches.vue'
import PlayersOfTheDayTable from '../components/dashboard/PlayersOfTheDayTable.vue'
import SeasonLeaders from '../components/dashboard/SeasonLeaders.vue'
import DailyInsight from '../components/dashboard/DailyInsight.vue'
import CustomSelect from '../components/ui/CustomSelect.vue'
import ToggleSwitch from '../components/ui/ToggleSwitch.vue'

const metricStore = useMetricStore()

onMounted(() => {
  metricStore.fetchTournaments()
})
</script>

<template>
  <div class="p-lg lg:p-xl flex flex-col gap-jumbo">
    <!-- Main Dashboard State -->
    <template v-if="!metricStore.isTournamentsLoading">
      <!-- Header with Tournament Selector and Reliability Toggle -->
      <div class="border-b-2 border-border-dark pb-sm">
        <div class="flex justify-between items-center">
          <h2 class="font-h1 text-h1 text-primary uppercase">TODAY'S OVERVIEW</h2>
          
          <!-- Tournament Selector -->
          <CustomSelect 
            v-model="metricStore.selectedTournamentId" 
            :options="metricStore.tournaments" 
            value-key="id"
            label-key="name"
            label="Select Tournament"
          />
        </div>
        
        <div class="flex justify-between items-center mt-xs">
          <p class="font-body-lg text-body-lg text-on-surface-variant">Your daily briefing on top players, latest results, and statistical trends.</p>
          
          <!-- Reliability Toggle -->
          <div class="flex items-center gap-3 bg-surface-white border-2 border-border-dark p-2 shadow-[2px_2px_0px_0px_rgba(0,0,0,1)]">
            <span class="font-label-caps text-label-caps uppercase text-primary text-xs">GLOBAL RELIABILITY MODE</span>
            <ToggleSwitch v-model="metricStore.globalReliabilityOn" />
          </div>
        </div>
      </div>

      <!-- Dashboard Grid -->
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-lg">
        <!-- Left Column (Wider) -->
        <div class="lg:col-span-2 flex flex-col gap-lg">
          <RecentMatches :tournamentId="metricStore.selectedTournamentId" />
          <PlayersOfTheDayTable :tournamentId="metricStore.selectedTournamentId" />
        </div>

        <!-- Right Column (Narrower) -->
        <div class="flex flex-col gap-lg">
          <SeasonLeaders :tournamentId="metricStore.selectedTournamentId" />
          <DailyInsight :tournamentId="metricStore.selectedTournamentId" />
        </div>
      </div>
    </template>

    <!-- Loading State for the whole Dashboard -->
    <div v-else class="flex flex-col items-center justify-center min-h-[400px] gap-4">
      <div class="w-16 h-16 border-4 border-border-dark border-t-secondary-container rounded-full animate-spin"></div>
      <p class="font-data-mono text-data-mono uppercase animate-pulse">Initializing Dashboard Data...</p>
    </div>
  </div>
</template>
