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
const currentIndex = ref(0)
const isLoading = ref(true)

const fetchInsights = async () => {
  isLoading.value = true
  try {
    const response = await mockApi.getDailyInsight(props.tournamentId)
    insights.value = Array.isArray(response.data) ? response.data : [response.data]
    currentIndex.value = 0
  } catch (error) {
    console.error('Failed to fetch daily insights:', error)
  } finally {
    isLoading.value = false
  }
}

const nextInsight = () => {
  if (insights.value.length === 0) return
  currentIndex.value = (currentIndex.value + 1) % insights.value.length
}

const prevInsight = () => {
  if (insights.value.length === 0) return
  currentIndex.value = (currentIndex.value - 1 + insights.value.length) % insights.value.length
}

onMounted(fetchInsights)
watch(() => props.tournamentId, fetchInsights)
</script>

<template>
  <CardImportant icon="insights">
    <template #header>
      <h3 class="font-h3 text-h3 uppercase">DAILY INSIGHT</h3>
      
      <!-- Pagination Controls -->
      <div v-if="!isLoading && insights.length > 1" class="flex gap-2">
        <button 
          @click="prevInsight"
          class="w-8 h-8 flex items-center justify-center bg-white/20 hover:bg-white/40 border border-white/50 transition-colors cursor-pointer"
        >
          <span class="material-symbols-outlined text-sm">chevron_left</span>
        </button>
        <button 
          @click="nextInsight"
          class="w-8 h-8 flex items-center justify-center bg-white/20 hover:bg-white/40 border border-white/50 transition-colors cursor-pointer"
        >
          <span class="material-symbols-outlined text-sm">chevron_right</span>
        </button>
      </div>
    </template>
    
    <div v-if="isLoading" class="space-y-2 mt-2">
      <div class="h-4 bg-white/20 animate-pulse w-full"></div>
      <div class="h-4 bg-white/20 animate-pulse w-3/4"></div>
    </div>
    
    <template v-else>
      <p class="font-body-reg text-body-reg transition-all duration-300">
        {{ insights[currentIndex] }}
      </p>
      
      <div class="flex justify-between items-end mt-4">
        <span class="inline-block bg-white text-secondary-container font-data-mono text-data-mono px-3 py-1 font-bold border border-border-dark uppercase text-xs">
          TREND DETECTED
        </span>
        <span v-if="insights.length > 1" class="font-data-mono text-xs opacity-70">
          {{ currentIndex + 1 }} / {{ insights.length }}
        </span>
      </div>
    </template>
  </CardImportant>
</template>
