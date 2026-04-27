<script setup>
import { ref, onMounted, watch } from 'vue'
import { mockApi } from '../../api/mock'
import { useMetricStore } from '../../store/metricStore'

const props = defineProps({
  tournamentId: {
    type: Number,
    required: true
  }
})

const metricStore = useMetricStore()
const players = ref([])
const isLoading = ref(true)

const fetchPlayers = async () => {
  isLoading.value = true
  try {
    const response = await mockApi.getPlayersOfTheDay(
      props.tournamentId,
      metricStore.globalReliabilityOn
    )
    players.value = response.data
  } catch (error) {
    console.error('Failed to fetch players of the day:', error)
  } finally {
    isLoading.value = false
  }
}

onMounted(fetchPlayers)
watch([() => props.tournamentId, () => metricStore.globalReliabilityOn], fetchPlayers)
</script>

<template>
  <section class="bg-surface-white border-2 border-border-dark shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] overflow-hidden">
    <div class="bg-tertiary p-md flex justify-between items-center">
      <h3 class="font-h3 text-h3 text-on-tertiary uppercase">PLAYERS OF THE DAY</h3>
    </div>
    
    <div v-if="isLoading" class="p-md space-y-4">
      <div v-for="i in 4" :key="i" class="h-12 bg-ghost-gray animate-pulse border-b border-border-light"></div>
    </div>
    
    <div v-else class="overflow-x-auto w-full">
      <table class="w-full text-left border-collapse">
        <thead>
          <tr class="bg-ghost-gray border-b-2 border-border-dark">
            <th class="font-label-caps text-label-caps text-primary p-sm border-r border-border-light">PLAYER</th>
            <th class="font-label-caps text-label-caps text-primary p-sm border-r border-border-light text-right">TEAM</th>
            <th class="font-label-caps text-label-caps text-primary p-sm border-r border-border-light text-right">MIN</th>
            <th class="font-label-caps text-label-caps text-primary p-sm border-r border-border-light text-right">PTS</th>
            <th class="font-label-caps text-label-caps text-primary p-sm border-r border-border-light text-right">REB</th>
            <th class="font-label-caps text-label-caps text-primary p-sm border-r border-border-light text-right">AST</th>
            <th class="font-label-caps text-label-caps text-secondary-container p-sm text-right bg-secondary-fixed/30">IMP</th>
          </tr>
        </thead>
        <tbody>
          <tr 
            v-for="(player, index) in players" 
            :key="player.id"
            class="border-b border-border-light hover:bg-ghost-gray transition-colors"
            :class="{ 'bg-surface-container-low': index % 2 !== 0 }"
          >
            <td class="p-sm border-r border-border-light font-body-reg text-body-reg text-primary font-medium">
              {{ player.fullName }}
            </td>
            <td class="p-sm border-r border-border-light font-data-mono text-data-mono text-primary text-right">
              {{ player.teamAlias }}
            </td>
            <td class="p-sm border-r border-border-light font-data-mono text-data-mono text-on-surface-variant text-right">
              {{ player.min }}
            </td>
            <td class="p-sm border-r border-border-light font-data-mono text-data-mono text-primary text-right">
              {{ player.pts }}
            </td>
            <td class="p-sm border-r border-border-light font-data-mono text-data-mono text-primary text-right">
              {{ player.reb }}
            </td>
            <td class="p-sm border-r border-border-light font-data-mono text-data-mono text-primary text-right">
              {{ player.ast }}
            </td>
            <td 
              class="p-sm font-data-mono text-data-mono font-bold text-right bg-secondary-fixed/10"
              :class="player.imp >= 0 ? 'text-status-positive' : 'text-status-negative'"
            >
              {{ player.imp >= 0 ? '+' : '' }}{{ player.imp }}
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </section>
</template>
