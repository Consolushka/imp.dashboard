<script setup>
defineProps({
  league: {
    type: Object,
    required: true
  }
})
</script>

<template>
  <div class="bg-surface-white border-2 border-border-dark shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] hover:-translate-y-1 hover:translate-x-1 hover:shadow-[12px_12px_0px_0px_rgba(254,106,52,1)] transition-all p-lg flex flex-col gap-md">
    <div class="flex justify-between items-start">
      <div class="w-12 h-12 bg-primary flex items-center justify-center text-secondary-container">
        <span class="material-symbols-outlined !text-3xl" style="font-variation-settings: 'FILL' 1;">grid_view</span>
      </div>
      <span 
        class="font-label-caps px-2 py-1 text-xs border border-border-dark"
        :class="league.tier === 1 ? 'bg-secondary-container text-white' : 'bg-surface-container text-primary'"
      >
        TIER {{ league.tier }}
      </span>
    </div>
    
    <div>
      <h3 class="font-h2 text-xl text-primary mb-1 uppercase">{{ league.name }}</h3>
      <p class="font-body-reg text-on-surface-variant text-xs">{{ league.name }}</p>
    </div>
    
    <div class="space-y-2 py-4 border-y-2 border-surface-container">
      <div class="flex justify-between items-center">
        <span class="font-label-caps text-xs text-on-surface uppercase">Tournaments</span>
        <span class="font-data-mono">{{ league.tournamentsCount }}</span>
      </div>
      <div class="flex justify-between items-center">
        <span class="font-label-caps text-xs text-on-surface">TOP PLAYER</span>
        <span class="font-data-mono">{{ league.topPlayer }}</span>
      </div>
      <div class="flex justify-between items-center">
        <span class="font-label-caps text-xs text-on-surface">MATCHES</span>
        <span class="font-data-mono">{{ league.matchesCount }}</span>
      </div>
    </div>
    
    <button class="w-full bg-secondary-container text-white py-2 font-label-caps border-2 border-border-dark active:translate-y-1 active:shadow-none transition-all text-xs uppercase cursor-pointer hover:bg-secondary">
      View Tournaments
    </button>
  </div>
</template>
