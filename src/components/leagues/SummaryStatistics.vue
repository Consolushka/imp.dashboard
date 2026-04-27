<script setup>
defineProps({
  stats: {
    type: Object,
    required: true
  }
})
</script>

<template>
  <section class="mt-jumbo p-xl bg-surface-container-low border-2 border-border-dark shadow-[4px_4px_0px_0px_rgba(0,0,0,1)]">
    <div class="grid grid-cols-1 md:grid-cols-4 gap-lg">
      <div class="md:border-r-2 md:border-border-dark pr-4 flex flex-col gap-1">
        <p class="font-label-caps text-secondary-container uppercase text-xs">TOTAL DATA POINTS</p>
        <h4 class="font-h2 text-h2 text-primary">{{ stats.totalDataPoints }}</h4>
      </div>
      <div class="md:border-r-2 md:border-border-dark pr-4 flex flex-col gap-1">
        <p class="font-label-caps text-secondary-container uppercase text-xs">ACTIVE LEAGUES</p>
        <h4 class="font-h2 text-h2 text-primary">{{ stats.activeLeagues }}</h4>
      </div>
      <div class="md:border-r-2 md:border-border-dark pr-4 flex flex-col gap-1">
        <p class="font-label-caps text-secondary-container uppercase text-xs">TRACKED PLAYERS</p>
        <h4 class="font-h2 text-h2 text-primary">{{ stats.trackedPlayers }}</h4>
      </div>
      <div class="flex flex-col gap-1">
        <p class="font-label-caps text-secondary-container uppercase text-xs">TOTAL MATCHES</p>
        <h4 class="font-h2 text-h2 text-primary">{{ stats.totalMatches }}</h4>
      </div>
    </div>
  </section>
</template>
