<script setup>
import { ref, computed, watch, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { api } from '../../api/index'
import { APP_VERSION } from '../../config'

const props = defineProps({ collapsed: Boolean })

const router = useRouter()
const searchQuery = ref('')
const searchFocused = ref(false)
// Пока пользователь печатает, поиск не прячем: клавиатура на мобилке меняет вьюпорт и порождает scroll-события
const compact = computed(() => props.collapsed && !searchFocused.value)
const searchResults = ref([])
const isSearching = ref(false)
const showResults = ref(false)
let debounceTimeout = null

const performSearch = async () => {
  if (searchQuery.value.length < 2) {
    searchResults.value = []
    showResults.value = false
    return
  }

  isSearching.value = true
  showResults.value = true
  try {
    const response = await api.searchGames(searchQuery.value, 5)
    searchResults.value = response.data
  } catch (error) {
    console.error('Search failed:', error)
    searchResults.value = []
  } finally {
    isSearching.value = false
  }
}

watch(searchQuery, (newVal) => {
  if (debounceTimeout) clearTimeout(debounceTimeout)

  if (!newVal) {
    searchResults.value = []
    showResults.value = false
    return
  }

  debounceTimeout = setTimeout(() => {
    performSearch()
  }, 300)
})

const selectGame = (gameId) => {
  console.log('Search: Selecting game', gameId)
  searchQuery.value = ''
  showResults.value = false
  router.push({ name: 'match-statistics', params: { id: gameId } })
}

const closeResults = () => {
  console.log('Search: Blur triggered')
  searchFocused.value = false
  showResults.value = false
}

const onFocus = () => {
  searchFocused.value = true
  showResults.value = searchQuery.value.length >= 2
}

onUnmounted(() => {
  if (debounceTimeout) clearTimeout(debounceTimeout)
})
</script>

<template>
  <header class="bg-white dark:bg-black font-sans uppercase tracking-tighter font-black border-b-4 border-black dark:border-orange-600 shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] flex flex-col md:flex-row items-center w-full px-4 md:px-6 md:py-0 md:h-16 z-50 shrink-0 justify-center gap-3 md:gap-4 relative transition-all duration-200" :class="compact ? 'py-1' : 'py-3'">

    <!-- Заголовок IMP для мобильных (на десктопе он в SideNavBar) -->
    <div class="md:hidden flex flex-col items-center w-full">
      <h1 class="font-h2 text-h2 text-black dark:text-white uppercase leading-none mb-1">IMP</h1>
      <p class="font-data-mono text-data-mono text-secondary-container text-[10px] uppercase" :class="{ hidden: compact }">{{ APP_VERSION }}</p>
    </div>

    <!-- Поисковая строка -->
    <div class="items-center gap-4 w-full md:w-auto" :class="compact ? 'hidden md:flex' : 'flex'">
      <div class="relative w-full md:w-80">
        <input
          v-model="searchQuery"
          @focus="onFocus"
          @blur="closeResults"
          class="w-full bg-ghost-gray border-2 border-border-dark text-data-mono font-data-mono px-4 py-2 focus:outline-none focus:border-secondary-container focus:ring-0 placeholder-neutral-medium rounded-none"
          placeholder="SEARCH GAMES..."
          type="text"
        />
        <span v-if="!isSearching" class="material-symbols-outlined absolute right-3 top-2.5 text-neutral-medium">search</span>
        <div v-else class="absolute right-3 top-2.5 w-5 h-5 border-2 border-secondary-container border-t-transparent rounded-full animate-spin"></div>

        <!-- Search Results Dropdown -->
        <div 
          v-if="showResults" 
          class="absolute top-full left-0 right-0 mt-1 bg-white border-4 border-black shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] z-[100] max-h-80 overflow-y-auto"
        >
          <div v-if="isSearching" class="p-4 text-center">
            <p class="font-data-mono text-xs animate-pulse">SEARCHING...</p>
          </div>

          <template v-else>
            <div 
              v-for="game in searchResults" 
              :key="game.id"
              @mousedown.prevent
              @click="selectGame(game.id)"
              class="p-3 border-b-2 border-ghost-gray hover:bg-secondary-container hover:text-white cursor-pointer transition-colors group"
            >
              <div class="flex justify-between items-center mb-1">
                <span class="font-h3 text-sm group-hover:text-white">{{ game.title }}</span>
                <span class="font-data-mono text-[10px] opacity-70">{{ game.scheduledAt.toLocaleDateString() }}</span>
              </div>
              <p class="font-data-mono text-[10px] uppercase truncate opacity-70">{{ game.subtitle }}</p>
            </div>

            <div v-if="searchResults.length === 0 && !isSearching" class="p-4 text-center">
              <p class="font-data-mono text-xs">NO GAMES FOUND</p>
            </div>
          </template>
        </div>
      </div>
    </div>
  </header>
</template>
