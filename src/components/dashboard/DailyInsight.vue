<script setup>
import { ref, onMounted, watch } from 'vue'
import { mockApi } from '../../api/mock'

const props = defineProps({
  tournamentId: {
    type: Number,
    required: true
  }
})
// todo: to abstract component
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
  <section class="bg-secondary-container text-white border-2 border-border-dark shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] p-md flex flex-col gap-sm relative overflow-hidden min-h-[180px]">
    <!-- Decorative bg icon -->
    <span class="material-symbols-outlined absolute -bottom-4 -right-4 text-9xl text-white/10 select-none pointer-events-none">insights</span>
    
    <div class="flex justify-between items-center z-10">
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
    </div>
    
    <div v-if="isLoading" class="z-10 space-y-2 mt-2">
      <div class="h-4 bg-white/20 animate-pulse w-full"></div>
      <div class="h-4 bg-white/20 animate-pulse w-3/4"></div>
    </div>
    
    <template v-else>
      <div class="flex-1 flex flex-col justify-between mt-2">
        <p class="font-body-reg text-body-reg z-10 transition-all duration-300">
          {{ insights[currentIndex] }}
        </p>
        
        <div class="flex justify-between items-end mt-4 z-10">
          <span class="inline-block bg-white text-secondary-container font-data-mono text-data-mono px-3 py-1 font-bold border border-border-dark uppercase text-xs">
            TREND DETECTED
          </span>
          <span v-if="insights.length > 1" class="font-data-mono text-xs opacity-70">
            {{ currentIndex + 1 }} / {{ insights.length }}
          </span>
        </div>
      </div>
    </template>
  </section>
</template>
