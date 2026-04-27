<script setup>
import { ref, onMounted, watch } from 'vue'
import { mockApi } from '../../api/mock'

const props = defineProps({
  tournamentId: {
    type: Number,
    required: true
  }
})

const games = ref([])
const isLoading = ref(true)

const fetchGames = async () => {
  isLoading.value = true
  try {
    const response = await mockApi.getTournamentGames(props.tournamentId)
    games.value = response.data
  } catch (error) {
    console.error('Failed to fetch games:', error)
  } finally {
    isLoading.value = false
  }
}

onMounted(fetchGames)
watch(() => props.tournamentId, fetchGames)
</script>

<template>
  <section class="bg-surface-white border-2 border-border-dark shadow-[4px_4px_0px_0px_rgba(0,0,0,1)]">
    <div class="bg-tertiary border-b-2 border-border-dark p-md flex justify-between items-center">
      <h3 class="font-h3 text-h3 text-on-tertiary uppercase">RECENT MATCHES</h3>
      <button class="text-on-tertiary font-label-caps text-label-caps hover:text-secondary-container transition-colors uppercase border-b border-transparent hover:border-secondary-container">VIEW ALL</button>
    </div>
    
    <div v-if="isLoading" class="flex flex-col p-md gap-md">
      <div v-for="i in 2" :key="i" class="h-32 bg-ghost-gray animate-pulse border-2 border-border-dark"></div>
    </div>
    
    <div v-else class="flex flex-col">
      <div 
        v-for="game in games" 
        :key="game.id"
        class="flex flex-col border-b-2 border-border-dark p-md hover:bg-ghost-gray transition-colors cursor-pointer"
      >
        <div class="flex justify-between items-center mb-sm">
          <span class="font-data-mono text-data-mono text-neutral-medium uppercase">
            {{ game.isFinal ? 'FINAL' : 'LIVE' }}
          </span>
          <span class="font-data-mono text-data-mono bg-border-dark text-surface-white px-2 py-1 text-xs">
            {{ game.scheduledAt.toLocaleDateString() }}
          </span>
        </div>
        
        <div class="flex justify-between items-center">
          <!-- Away Team -->
          <div class="flex items-center gap-3 w-1/3">
            <div class="w-10 h-10 bg-primary-fixed rounded-full border border-border-dark flex items-center justify-center">
              <span class="material-symbols-outlined text-tertiary">sports_basketball</span>
            </div>
            <span 
              class="font-h3 text-h3"
              :class="game.awayTeamStats.finalDifferential > 0 ? 'text-status-positive' : 'text-on-surface'"
            >
              {{ game.awayTeamStats.team.alias }}
            </span>
          </div>
          
          <!-- Score -->
          <div class="flex flex-col items-center w-1/3">
            <div class="flex items-center gap-4">
              <span 
                class="font-display-hero text-display-hero"
                :class="game.awayTeamStats.finalDifferential > 0 ? 'text-status-positive' : 'text-on-surface'"
              >
                {{ game.awayTeamStats.score }}
              </span>
              <span class="font-h2 text-h2 text-outline">-</span>
              <span 
                class="font-display-hero text-display-hero"
                :class="game.homeTeamStats.finalDifferential > 0 ? 'text-status-positive' : 'text-on-surface'"
              >
                {{ game.homeTeamStats.score }}
              </span>
            </div>
          </div>
          
          <!-- Home Team -->
          <div class="flex items-center justify-end gap-3 w-1/3">
            <span 
              class="font-h3 text-h3"
              :class="game.homeTeamStats.finalDifferential > 0 ? 'text-status-positive' : 'text-on-surface'"
            >
              {{ game.homeTeamStats.team.alias }}
            </span>
            <div class="w-10 h-10 bg-primary-fixed rounded-full border border-border-dark flex items-center justify-center">
              <span class="material-symbols-outlined text-tertiary">sports_basketball</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>
