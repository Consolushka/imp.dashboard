<script setup>
defineProps({
  leaders: {
    type: Array,
    required: true
  }
})
</script>

<template>
  <section class="mt-jumbo grid grid-cols-1 md:grid-cols-4 gap-4 sm:gap-xl">
    <!-- Header Block -->
    <div class="md:col-span-1 bg-primary text-white p-lg border-4 border-primary shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] flex items-center">
      <h2 class="font-h1 text-h2 uppercase leading-none font-black">WEEKLY LEADERS</h2>
    </div>
    
    <!-- Leaders Stats Block -->
    <div class="md:col-span-3 bg-white border-4 border-primary p-lg shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] flex flex-wrap md:flex-nowrap items-center justify-around gap-y-lg gap-x-md">
      <template v-for="(leader, index) in leaders" :key="index">
        <div class="text-center min-w-[100px] flex-1">
          <p class="font-label-caps text-label-caps text-neutral-medium uppercase text-[10px] mb-1 leading-none">{{ leader.category }}</p>
          <p class="font-h3 text-sm sm:text-base uppercase font-bold text-primary leading-tight mb-1">{{ leader.player }}</p>
          <p class="font-data-mono text-data-mono text-secondary-container font-black text-xs sm:text-sm">{{ leader.value }}</p>
        </div>
        
        <!-- Divider for desktop -->
        <div 
          v-if="index < leaders.length - 1" 
          class="w-px h-12 bg-primary/20 hidden md:block"
        ></div>
      </template>
    </div>
  </section>
</template>
