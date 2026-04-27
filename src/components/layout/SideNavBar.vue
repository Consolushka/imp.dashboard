<script setup>
import { RouterLink } from 'vue-router'
import { APP_VERSION } from '../../config'

const navLinks = [
  { to: '/', label: 'Today', icon: 'calendar_today' },
  { to: '/leagues', label: 'Leagues', icon: 'emoji_events' },
  { to: '/tournaments', label: 'Tournaments', icon: 'workspace_premium' },
  { to: '/matches', label: 'Matches', icon: 'sports_basketball' },
  { to: '/analytics', label: 'Methodology', icon: 'menu_book' },
]
</script>

<template>
  <nav class="bg-white dark:bg-stone-900 md:h-screen w-full md:w-64 border-t-4 md:border-t-0 md:border-r-4 border-black dark:border-orange-600 flex flex-row md:flex-col fixed bottom-0 md:top-0 left-0 p-2 md:p-4 gap-2 z-50 overflow-x-auto md:overflow-visible">
    
    <!-- Заголовок -->
    <div class="mb-4 hidden md:block">
      <h1 class="font-h2 text-h2 text-black dark:text-white mb-1 uppercase">IMP</h1>
      <p class="font-data-mono text-data-mono text-secondary-container">{{ APP_VERSION }}</p>
    </div>
    
    <!-- Навигационные ссылки -->
    <div class="flex-1 flex flex-row md:flex-col gap-2 md:mt-lg justify-around md:justify-start w-full">
      <RouterLink 
        v-for="link in navLinks" 
        :key="link.to"
        :to="link.to" 
        v-slot="{ isActive }"
        custom
      >
        <a
          @click="$router.push(link.to)"
          class="flex items-center justify-center md:justify-start gap-2 md:gap-3 p-3 font-body-reg text-body-reg transition-all duration-75 border-2 rounded-lg md:rounded-none flex-1 md:flex-none cursor-pointer"
          :class="[
            isActive 
            ? 'bg-secondary-container text-white border-black shadow-[2px_2px_0px_0px_rgba(0,0,0,1)] md:shadow-[4px_4px_0px_0px_rgba(0,0,0,1)]' 
            : 'text-black dark:text-white border-transparent hover:bg-stone-100 dark:hover:bg-stone-800 hover:border-black hover:translate-x-[-2px] hover:translate-y-[-2px]'
          ]"
        >
          <span 
            class="material-symbols-outlined" 
            :style="isActive ? 'font-variation-settings: \'FILL\' 1;' : ''"
          >
            {{ link.icon }}
          </span>
          <span class="hidden md:inline">{{ link.label }}</span>
        </a>
      </RouterLink>
    </div>
  </nav>
</template>
