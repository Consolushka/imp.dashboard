<script setup>
import { ref, onMounted, watch } from 'vue'
import { api } from '../../api/index'
import { useMetricStore } from '../../store/metricStore'
import { formatBlockDate } from '../../utils/blockDate'
import { latestOnly } from '../../utils/latestOnly'

const props = defineProps({
  tournamentId: {
    type: Number,
    required: true
  }
})

const metricStore = useMetricStore()
const players = ref([])
const date = ref(null)
const isLoading = ref(true)
const startRequest = latestOnly()

const fetchPlayers = async () => {
  const isLatest = startRequest()
  isLoading.value = true
  try {
    const response = await api.getPlayersOfTheDay(
      props.tournamentId,
      { use_reliability: metricStore.globalReliabilityOn }
    )
    if (!isLatest()) return
    players.value = response.data
    date.value = response.date
  } catch (error) {
    if (!isLatest()) return
    console.error('Failed to fetch players of the day:', error)
    // Иначе при смене турнира остались бы игроки и дата предыдущего
    players.value = []
    date.value = null
  } finally {
    if (isLatest()) isLoading.value = false
  }
}

onMounted(fetchPlayers)
watch([() => props.tournamentId, () => metricStore.globalReliabilityOn], fetchPlayers)
</script>

<template>
  <section class="bg-surface-white border-2 border-border-dark shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] overflow-hidden">
    <div class="bg-tertiary p-md flex justify-between items-center">
      <div>
        <h3 class="font-h3 text-h3 text-on-tertiary uppercase">PLAYERS OF THE DAY</h3>
        <!-- Шапка видна и во время загрузки: не показываем дату предыдущего турнира над новыми данными -->
        <p v-if="date && !isLoading" class="font-data-mono text-xs text-on-tertiary opacity-70">{{ formatBlockDate(date) }}</p>
      </div>
    </div>
    
    <div v-if="isLoading" class="p-md space-y-4">
      <div v-for="i in 4" :key="i" class="h-12 bg-ghost-gray animate-pulse border-b border-border-light"></div>
    </div>
    
    <div v-else-if="players.length === 0" class="p-xl text-center">
      <p class="font-body-reg text-secondary italic">No player stats yet, so there are no heroes to show. Check back later!</p>
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
            <!-- На телефоне колонка закреплена и должна быть непрозрачной, иначе при прокрутке сквозь неё видны соседние: берём цвет строки, а оттенок кладём поверх. Разделитель сделан тенью, потому что обычная граница в этой таблице при прокрутке осталась бы на месте -->
            <th class="font-label-caps text-label-caps text-secondary-container p-sm text-right bg-secondary-fixed/30 max-sm:sticky max-sm:right-0 max-sm:bg-inherit max-sm:bg-gradient-to-r max-sm:from-secondary-fixed/30 max-sm:to-secondary-fixed/30 max-sm:shadow-[inset_2px_0_0_0_rgba(0,0,0,1)]">IMP</th>
          </tr>
        </thead>
        <tbody>
          <tr 
            v-for="(player, index) in players" 
            :key="player.id"
            class="border-b border-border-light hover:bg-ghost-gray transition-colors"
            :class="index % 2 !== 0 ? 'bg-surface-container-low' : 'bg-surface-white'"
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
              class="p-sm font-data-mono text-data-mono font-bold text-right bg-secondary-fixed/10 max-sm:sticky max-sm:right-0 max-sm:bg-inherit max-sm:bg-gradient-to-r max-sm:from-secondary-fixed/10 max-sm:to-secondary-fixed/10 max-sm:shadow-[inset_2px_0_0_0_rgba(0,0,0,1)]"
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
