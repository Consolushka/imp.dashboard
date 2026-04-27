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
const leaders = ref([])
const isLoading = ref(true)

const fetchLeaders = async () => {
  isLoading.value = true
  try {
    const response = await mockApi.getLeaderboard(
      props.tournamentId, 
      metricStore.globalReliabilityOn
    )
    leaders.value = response.data
  } catch (error) {
    console.error('Failed to fetch season leaders:', error)
  } finally {
    isLoading.value = false
  }
}

onMounted(fetchLeaders)
watch([() => props.tournamentId, () => metricStore.globalReliabilityOn], fetchLeaders)
</script>

<template>
  <section class="bg-surface-white border-2 border-border-dark shadow-[4px_4px_0px_0px_rgba(0,0,0,1)]">
    <div class="bg-tertiary border-b-2 border-border-dark p-md">
      <h3 class="font-h3 text-h3 text-on-tertiary uppercase">SEASON LEADERS (IMP)</h3>
    </div>
    
    <div v-if="isLoading" class="p-md space-y-4">
      <div v-for="i in 4" :key="i" class="h-10 bg-ghost-gray animate-pulse border-b border-border-light"></div>
    </div>
    
    <div v-else class="p-md flex flex-col gap-md">
      <div 
        v-for="leader in leaders" 
        :key="leader.id"
        class="flex items-center justify-between border-b border-border-light pb-sm last:border-b-0"
      >
        <div class="flex items-center gap-3">
          <span class="font-data-mono text-data-mono text-on-surface-variant w-4">{{ leader.position }}.</span>
          <div class="flex flex-col">
            <span class="font-body-reg text-body-reg text-primary font-semibold">{{ leader.fullName }}</span>
            <span class="font-data-mono text-data-mono text-neutral-medium text-xs">{{ leader.teamAlias }}</span>
          </div>
        </div>
        <span class="font-data-mono text-data-mono text-secondary-container font-bold">
          {{ leader.avgImp >= 0 ? '+' : '' }}{{ leader.avgImp }}
        </span>
      </div>
      
      <button class="w-full bg-transparent border-2 border-border-dark text-primary font-label-caps text-label-caps py-2 mt-2 hover:bg-primary hover:text-white transition-colors uppercase hover:-translate-y-0.5 hover:shadow-[4px_4px_0px_0px_rgba(0,0,0,1)]">
        FULL RANKINGS
      </button>
    </div>
  </section>
</template>
