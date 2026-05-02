<script setup>
import { useRouter } from 'vue-router'

const props = defineProps({
  tournament: {
    type: Object,
    required: true
  }
})

const router = useRouter()

const viewMatches = () => {
  router.push({ 
    name: 'matches', 
    query: { tournaments: props.tournament.id } 
  })
}

const getStatusColor = (status) => {
  switch (status) {
    case 'ONGOING': return 'text-status-positive'
    case 'COMPLETED': return 'text-neutral-medium italic'
    case 'ARCHIVED': return 'text-neutral-medium italic'
    default: return 'text-primary'
  }
}
</script>

<template>
  <article class="bg-surface-white border-2 border-primary shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] flex flex-col">
    <div class="p-lg border-b-2 border-primary flex justify-between items-start bg-ghost-gray">
      <span class="material-symbols-outlined text-primary text-4xl" style="font-variation-settings: 'FILL' 1;">grid_view</span>
      <span class="font-label-caps text-xs px-2 py-1 bg-primary text-white">TIER {{ tournament.tier }}</span>
    </div>
    
    <div class="p-lg flex-grow">
      <h3 class="font-h3 text-h3 mb-md leading-tight uppercase">{{ tournament.name }}</h3>
      <div class="space-y-sm">
        <div class="flex justify-between border-b border-outline-variant pb-micro">
          <span class="font-label-caps text-xs text-on-surface-variant uppercase">Status</span>
          <span class="font-data-mono text-data-mono font-bold" :class="getStatusColor(tournament.status)">
            {{ tournament.status }}
          </span>
        </div>
        <div class="flex justify-between border-b border-outline-variant pb-micro">
          <span class="font-label-caps text-xs text-on-surface-variant uppercase">Teams Count</span>
          <span class="font-data-mono text-data-mono font-bold">{{ tournament.teamsCount }}</span>
        </div>
        <div class="flex justify-between border-b border-outline-variant pb-micro">
          <span class="font-label-caps text-xs text-on-surface-variant uppercase">Top Player</span>
          <span class="font-data-mono text-data-mono font-bold">{{ tournament.topPlayer }}</span>
        </div>
        <div class="flex justify-between border-b border-outline-variant pb-micro">
          <span class="font-label-caps text-xs text-on-surface-variant uppercase">Total Matches</span>
          <span class="font-data-mono text-data-mono font-bold">{{ tournament.matchesCount }}</span>
        </div>
      </div>
    </div>
    
    <div class="p-lg pt-0">
      <button 
        @click="viewMatches"
        class="w-full bg-secondary-container text-white font-label-caps py-md transition-all border-2 border-primary uppercase tracking-wider font-bold shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] active:translate-x-[2px] active:translate-y-[2px] active:shadow-none cursor-pointer hover:bg-secondary"
      >
        VIEW MATCHES
      </button>
    </div>
  </article>
</template>
