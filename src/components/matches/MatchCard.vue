<script setup>
import { useRouter } from 'vue-router'

const props = defineProps({
  match: {
    type: Object,
    required: true
  }
})

const router = useRouter()

const viewStats = () => {
  router.push({
    name: 'match-statistics',
    params: { id: props.match.id }
  })
}

const formatMatchDate = (date) => {
  return date.toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  }).toUpperCase()
}
</script>

<template>
  <article class="bg-surface-white border-2 border-primary p-md shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] flex flex-col gap-md hover:translate-x-[-2px] hover:translate-y-[-2px] hover:shadow-[6px_6px_0px_0px_rgba(0,0,0,1)] transition-all overflow-hidden">
    <!-- Header -->
    <div class="flex justify-between items-center border-b-2 border-ghost-gray pb-sm">
      <span class="font-label-caps text-[10px] uppercase text-neutral-medium">FINAL</span>
      <span class="font-data-mono text-[10px] whitespace-nowrap">{{ formatMatchDate(match.scheduledAt) }}</span>
    </div>
    
    <!-- Unified Layout for all screens -->
    <div class="grid grid-cols-[1fr_auto_1fr] items-center gap-x-2">
      <!-- Away Team Column -->
      <div class="flex flex-col items-center gap-2 min-w-0">
        <!-- Icon -->
        <div class="w-12 h-12 lg:w-14 lg:h-14 bg-ghost-gray border-2 border-primary flex items-center justify-center shrink-0">
          <span class="material-symbols-outlined text-2xl lg:text-3xl">sports_basketball</span>
        </div>
        <!-- Score -->
        <div 
          class="font-display-hero text-2xl lg:text-3xl tabular-nums leading-none"
          :class="{ 'text-status-positive font-black': match.awayTeamStats.finalDifferential > 0, 'font-bold': match.awayTeamStats.finalDifferential <= 0 }"
        >
          {{ match.awayTeamStats.score }}
        </div>
        <!-- Alias -->
        <div class="font-h3 text-sm lg:text-base uppercase truncate w-full text-center">
          {{ match.awayTeamStats.team.alias }}
        </div>
      </div>
      
      <!-- Separator -->
      <div class="flex flex-col items-center justify-center px-2">
        <span class="font-label-caps text-outline text-lg">VS</span>
      </div>
      
      <!-- Home Team Column -->
      <div class="flex flex-col items-center gap-2 min-w-0">
        <!-- Icon -->
        <div class="w-12 h-12 lg:w-14 lg:h-14 bg-ghost-gray border-2 border-primary flex items-center justify-center shrink-0">
          <span class="material-symbols-outlined text-2xl lg:text-3xl">sports_basketball</span>
        </div>
        <!-- Score -->
        <div 
          class="font-display-hero text-2xl lg:text-3xl tabular-nums leading-none"
          :class="{ 'text-status-positive font-black': match.homeTeamStats.finalDifferential > 0, 'font-bold': match.homeTeamStats.finalDifferential <= 0 }"
        >
          {{ match.homeTeamStats.score }}
        </div>
        <!-- Alias -->
        <div class="font-h3 text-sm lg:text-base uppercase truncate w-full text-center">
          {{ match.homeTeamStats.team.alias }}
        </div>
      </div>
    </div>

    <!-- Stats Button -->
    <button
      @click="viewStats"
      class="w-full bg-secondary-container text-on-secondary font-h3 text-base py-2 border-2 border-primary shadow-[2px_2px_0px_0px_rgba(0,0,0,1)] active:translate-x-0 active:translate-y-0 active:shadow-none translate-x-[-1px] translate-y-[-1px] transition-all uppercase cursor-pointer hover:bg-secondary"
    >
      VIEW STATS
    </button>
  </article>
</template>
