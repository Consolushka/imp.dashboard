<script setup>
defineProps({
  options: {
    type: Array,
    required: true
  },
  modelValue: {
    type: String,
    required: true
  }
})

const emit = defineEmits(['update:modelValue'])

const select = (option) => {
  emit('update:modelValue', option)
}
</script>

<template>
  <div class="flex flex-wrap gap-0">
    <button
      v-for="(option, index) in options"
      :key="option"
      @click="select(option)"
      class="px-xl py-sm font-label-caps text-label-caps uppercase border-4 border-primary transition-all duration-150"
      :class="[
        modelValue === option
          ? 'bg-electric-orange text-white shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] -translate-y-1 z-10'
          : 'bg-white hover:bg-ghost-gray text-primary',
        index === 0 ? '' : 'border-l-0', // Eliminate double borders
        index === 0 ? 'border-r-2' : (index === options.length - 1 ? 'border-l-2' : 'border-x-2')
      ]"
    >
      {{ option }}
    </button>
  </div>
</template>
