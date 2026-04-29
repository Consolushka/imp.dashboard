<script setup>
import { ref } from 'vue'

const props = defineProps({
  title: {
    type: String,
    required: true
  },
  items: {
    type: Array,
    required: true,
    default: () => []
  },
  icon: {
    type: String,
    default: 'insights'
  }
})

const currentIndex = ref(0)

const nextItem = () => {
  if (props.items.length === 0) return
  currentIndex.value = (currentIndex.value + 1) % props.items.length
}

const prevItem = () => {
  if (props.items.length === 0) return
  currentIndex.value = (currentIndex.value - 1 + props.items.length) % props.items.length
}
</script>

<template>
  <section class="bg-secondary-container text-white border-2 border-border-dark shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] p-md flex flex-col gap-sm relative overflow-hidden min-h-[180px]">
    <!-- Decorative bg icon -->
    <span class="material-symbols-outlined absolute -bottom-4 -right-4 text-9xl text-white/10 select-none pointer-events-none">
      {{ icon }}
    </span>
    
    <div class="flex justify-between items-center z-10">
      <h3 class="font-h3 text-h3 uppercase">{{ title }}</h3>
      
      <!-- Pagination Controls -->
      <div v-if="items.length > 1" class="flex gap-2">
        <button 
          @click="prevItem"
          class="bg-white/20 hover:bg-white/40 border border-white/50 w-6 h-6 flex items-center justify-center transition-colors cursor-pointer"
        >
          <span class="material-symbols-outlined text-sm">chevron_left</span>
        </button>
        <button 
          @click="nextItem"
          class="bg-white/20 hover:bg-white/40 border border-white/50 w-6 h-6 flex items-center justify-center transition-colors cursor-pointer"
        >
          <span class="material-symbols-outlined text-sm">chevron_right</span>
        </button>
      </div>
    </div>
    
    <div class="z-10 mt-2 flex-1 flex flex-col justify-between">
      <div class="flex-1">
        <p v-if="items.length > 0" class="font-body-reg text-body-reg transition-all duration-300">
          {{ items[currentIndex] }}
        </p>
        <p v-else class="italic opacity-50">No items available</p>
      </div>

      <!-- Pagination Indicator -->
      <div v-if="items.length > 1" class="mt-4 flex justify-between items-center">
        <div class="flex gap-xs">
          <div 
            v-for="(_, index) in items" 
            :key="index"
            class="h-1.5 transition-all duration-300"
            :class="index === currentIndex ? 'w-8 bg-white' : 'w-4 bg-white/30'"
          ></div>
        </div>
        <span class="font-data-mono text-xs opacity-70">
          {{ currentIndex + 1 }} / {{ items.length }}
        </span>
      </div>
    </div>
  </section>
</template>
