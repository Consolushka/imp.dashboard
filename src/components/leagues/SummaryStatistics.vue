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
    <div class="grid grid-cols-2 lg:grid-cols-4 gap-lg">
      <div 
        v-for="(item, index) in items" 
        :key="index"
        class="flex flex-col gap-1 min-w-0"
        :class="[
          /* На мобилках и планшетах (2 колонки) граница у нечетных элементов (индекс 0, 2) */
          /* На десктопе (4 колонки) граница у 1, 2, 3 элементов (индекс 0, 1, 2) */
          index % 2 === 0 ? 'border-r-2 border-border-dark pr-4' : 'lg:border-r-2 lg:border-border-dark lg:pr-4',
          /* Убираем границу у самого последнего элемента всегда */
          index === items.length - 1 ? 'border-r-0 pr-0' : ''
        ]"
      >
        <p class="font-label-caps text-secondary-container uppercase text-xs">{{ item.label }}</p>
        <h4 class="font-h2 text-h2 text-primary leading-tight">{{ item.value }}</h4>
      </div>
    </div>
  </section>
</template>
