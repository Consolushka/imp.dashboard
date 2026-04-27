<script setup>
import { APP_VERSION } from '../../config'
</script>

<template>
  <header class="bg-white dark:bg-black font-sans uppercase tracking-tighter font-black border-b-4 border-black dark:border-orange-600 shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] flex flex-col md:flex-row items-center w-full px-4 md:px-6 py-3 md:py-0 md:h-16 z-40 shrink-0 justify-center gap-3 md:gap-4">
    
    <!-- Заголовок IMP для мобильных (на десктопе он в SideNavBar) -->
    <div class="md:hidden flex flex-col items-center w-full">
      <h1 class="font-h2 text-h2 text-black dark:text-white uppercase leading-none mb-1">IMP</h1>
      <p class="font-data-mono text-data-mono text-secondary-container text-[10px] uppercase">{{ APP_VERSION }}</p>
    </div>

    <!-- Поисковая строка -->
    <div class="flex items-center gap-4 w-full md:w-auto">
      <div class="relative w-full md:w-64">
        <input 
          class="w-full bg-ghost-gray border-2 border-border-dark text-data-mono font-data-mono px-4 py-2 focus:outline-none focus:border-secondary-container focus:ring-0 placeholder-neutral-medium rounded-none" 
          placeholder="SEARCH GAMES..."
          type="text"
        />
        <span class="material-symbols-outlined absolute right-3 top-2.5 text-neutral-medium">search</span>
      </div>
    </div>
  </header>
</template>
