<script setup>
defineProps({
  items: {
    type: Array,
    required: true
  }
})
</script>

<template>
  <section class="mt-jumbo p-xl bg-surface-container-low border-2 border-border-dark shadow-[4px_4px_0px_0px_rgba(0,0,0,1)]">
    <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-lg">
      <div 
        v-for="(item, index) in items" 
        :key="index"
        class="flex flex-col gap-1"
        :class="{ 'md:border-r-2 md:border-border-dark pr-4': index < items.length - 1 }"
      >
        <p class="font-label-caps text-secondary-container uppercase text-xs">{{ item.label }}</p>
        <h4 class="font-h2 text-h2 text-primary leading-tight">{{ item.value }}</h4>
      </div>
    </div>
  </section>
</template>
