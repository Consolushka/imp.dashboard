<script setup>
import { ref, onMounted, watch } from 'vue'
import { mockApi } from '../../api/mock'
import CardImportant from '../ui/CardImportant.vue'

const props = defineProps({
  tournamentId: {
    type: Number,
    required: true
  }
})

const insights = ref([])
const isLoading = ref(true)

const fetchInsights = async () => {
  isLoading.value = true
  try {
    const response = await mockApi.getDailyInsight(props.tournamentId)
    insights.value = Array.isArray(response.data) ? response.data : [response.data]
  } catch (error) {
    console.error('Failed to fetch daily insights:', error)
  } finally {
    isLoading.value = false
  }
}

onMounted(fetchInsights)
watch(() => props.tournamentId, fetchInsights)
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
    :items="insights" 
    icon="insights"
  />
</template>
