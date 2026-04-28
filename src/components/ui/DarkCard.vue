<script setup>
defineProps({
  title: {
    type: String,
    default: ''
  }
})
</script>

<template>
  <div class="bg-primary text-on-primary border-4 border-primary shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] p-lg flex flex-col justify-between">
    <div>
      <div v-if="title || $slots.header" class="flex justify-between items-center mb-md border-b-2 border-on-primary-container pb-xs">
        <slot name="header">
          <h3 class="font-label-caps text-label-caps uppercase">{{ title }}</h3>
        </slot>
        <div class="flex gap-xs">
          <slot name="header-actions"></slot>
        </div>
      </div>
      <slot></slot>
    </div>
    <div v-if="$slots.footer" class="mt-lg">
      <slot name="footer"></slot>
    </div>
  </div>
</template>
