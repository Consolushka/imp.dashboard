<script setup>
defineProps({
  modelValue: {
    type: [String, Number],
    required: true
  },
  options: {
    type: Array,
    required: true
  },
  label: {
    type: String,
    default: ''
  },
  activeColorClass: {
    type: String,
    default: 'bg-black text-white'
  }
})

defineEmits(['update:modelValue'])
</script>

<template>
  <div class="flex flex-col gap-1">
    <label v-if="label" class="font-label-caps text-xs uppercase text-on-background">{{ label }}</label>
    <div 
      class="flex h-14 border-2 border-black bg-white overflow-hidden"
      :class="`grid grid-cols-${options.length}`"
    >
      <button 
        v-for="option in options" 
        :key="option.value"
        @click="$emit('update:modelValue', option.value)"
        class="flex-1 font-data-mono text-xs transition-colors border-r-2 last:border-r-0 border-black"
        :class="[
          modelValue === option.value ? activeColorClass : 'bg-white text-black hover:bg-ghost-gray'
        ]"
      >
        {{ option.label }}
      </button>
    </div>
  </div>
</template>
