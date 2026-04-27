<script setup>
import { useMetricStore } from '../store/metricStore'
import RecentMatches from '../components/dashboard/RecentMatches.vue'
import PlayersOfTheDayTable from '../components/dashboard/PlayersOfTheDayTable.vue'
import SeasonLeaders from '../components/dashboard/SeasonLeaders.vue'
import DailyInsight from '../components/dashboard/DailyInsight.vue'

const metricStore = useMetricStore()

// Обработчик изменения чекбокса
const onToggleChange = (event) => {
  metricStore.setReliability(event.target.checked)
}
</script>

<template>
  <div class="p-lg lg:p-xl flex flex-col gap-jumbo">
    <!-- Reliability Toggle Header -->
    <div class="flex justify-between items-end border-b-2 border-border-dark pb-sm">
      <div>
        <h2 class="font-h1 text-h1 text-primary">TODAY'S OVERVIEW</h2>
        <p class="font-body-lg text-body-lg text-on-surface-variant mt-xs">Comprehensive statistical analysis of current fixtures.</p>
      </div>
      
      <div class="flex items-center gap-3 bg-surface-white border-2 border-border-dark p-sm shadow-[4px_4px_0px_0px_rgba(0,0,0,1)]">
        <span class="font-label-caps text-label-caps uppercase text-primary">GLOBAL RELIABILITY MODE</span>
        <label class="relative inline-flex items-center cursor-pointer">
          <input 
            type="checkbox" 
            class="sr-only peer" 
            :checked="metricStore.globalReliabilityOn"
            @change="onToggleChange"
          />
          <div class="w-11 h-6 bg-border-dark peer-focus:outline-none peer-focus:ring-0 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-border-dark after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-status-positive border-2 border-border-dark"></div>
        </label>
      </div>
    </div>

    <!-- Dashboard Grid -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-lg">
      <!-- Left Column (Wider) -->
      <div class="lg:col-span-2 flex flex-col gap-lg">
        <RecentMatches />
        <PlayersOfTheDayTable />
      </div>

      <!-- Right Column (Narrower) -->
      <div class="flex flex-col gap-lg">
        <SeasonLeaders />
        <DailyInsight />
      </div>
    </div>
  </div>
</template>
