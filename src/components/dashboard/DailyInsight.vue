<script setup>
import { ref, onMounted, watch } from 'vue'
import { api } from '../../api/index'
import { useMetricStore } from '../../store/metricStore'
import { formatBlockDate } from '../../utils/blockDate'
import { latestOnly } from '../../utils/latestOnly'
import CardImportant from '../ui/CardImportant.vue'

const props = defineProps({
  tournamentId: {
    type: Number,
    required: true
  }
})

const metricStore = useMetricStore()
const insights = ref([])
const date = ref(null)
const isLoading = ref(true)
const startRequest = latestOnly()

const fetchInsights = async () => {
  const isLatest = startRequest()
  isLoading.value = true
  try {
    const response = await api.getDailyInsight(
      props.tournamentId,
      { use_reliability: metricStore.globalReliabilityOn }
    )
    if (!isLatest()) return
    insights.value = response.data
    date.value = response.date
  } catch (error) {
    if (!isLatest()) return
    console.error('Failed to fetch daily insights:', error)
    // Иначе при смене турнира остались бы инсайты и дата предыдущего
    insights.value = []
    date.value = null
  } finally {
    if (isLatest()) isLoading.value = false
  }
}

onMounted(fetchInsights)
watch([() => props.tournamentId, () => metricStore.globalReliabilityOn], fetchInsights)
</script>

<template>
  <div v-if="isLoading" class="bg-secondary-container border-2 border-border-dark p-md h-[180px] flex items-center justify-center">
    <div class="space-y-2 w-full">
      <div class="h-4 bg-white/20 animate-pulse w-full"></div>
      <div class="h-4 bg-white/20 animate-pulse w-3/4"></div>
    </div>
  </div>
  <CardImportant 
    v-else
    title="Daily Insight"
    :subtitle="date ? formatBlockDate(date) : ''"
    :items="insights"
    icon="insights"
    empty-message="Sorry, we'd love to give you some food for thought, but there's nothing to share yet."
  />
</template>
