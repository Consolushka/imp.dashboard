<script setup>
import { ref } from 'vue'
import { RouterView } from 'vue-router'
import SideNavBar from './components/layout/SideNavBar.vue'
import TopAppBar from './components/layout/TopAppBar.vue'

const headerCollapsed = ref(false)

// Разные пороги на схлопывание и раскрытие, чтобы хедер не мигал у границы
const onScroll = (e) => {
  const top = e.target.scrollTop
  if (top > 40) headerCollapsed.value = true
  else if (top < 10) headerCollapsed.value = false
}
</script>

<template>
  <div class="flex flex-col md:flex-row h-screen overflow-hidden bg-background-primary">
    <!-- Боковая панель (фиксированная снизу на мобильных, слева на десктопе) -->
    <SideNavBar />

    <!-- Основная область контента -->
    <!-- На десктопе отступ слева 64 (w-64 = 16rem = 256px), на мобилке отступ снизу для меню (pb-16) -->
    <div class="md:ml-64 flex-1 flex flex-col h-screen overflow-hidden pb-16 md:pb-0">
      <!-- Верхняя панель -->
      <TopAppBar :collapsed="headerCollapsed" />

      <!-- Прокручиваемый контент страницы -->
      <main class="flex-1 overflow-y-auto" @scroll.passive="onScroll">
        <RouterView />
      </main>
    </div>
  </div>
</template>

<style>
/* Мы убираем старые стили, так как теперь используем Tailwind из index.html */
body {
  margin: 0;
  overflow: hidden;
}
</style>
