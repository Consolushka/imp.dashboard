<script setup>
defineProps({
  icon: {
    type: String,
    default: 'insights'
  }
})
</script>

<template>
  <section class="bg-secondary-container text-white border-2 border-border-dark shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] p-md flex flex-col gap-sm relative overflow-hidden min-h-[180px]">
    <!-- Decorative bg icon -->
    <span class="material-symbols-outlined absolute -bottom-4 -right-4 text-9xl text-white/10 select-none pointer-events-none">
      {{ icon }}
    </span>
    
    <div class="flex justify-between items-center z-10">
      <slot name="header"></slot>
    </div>
    
    <div class="z-10 mt-2 flex-1 flex flex-col justify-between">
      <slot></slot>
    </div>
  </section>
</template>
