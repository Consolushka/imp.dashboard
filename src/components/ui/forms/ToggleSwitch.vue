<script setup>
const props = defineProps({
  modelValue: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['update:modelValue'])

const toggle = () => {
  emit('update:modelValue', !props.modelValue)
}
</script>

<template>
  <button
    @click="toggle"
    class="w-12 h-6 border-2 border-primary relative flex items-center p-[2px] transition-colors focus:outline-none cursor-pointer"
    :class="modelValue ? 'bg-electric-orange' : 'bg-surface-container'"
  >
    <div
      class="w-4 h-4 transition-transform duration-200"
      :class="[
        modelValue ? 'translate-x-6 bg-white' : 'translate-x-0 bg-primary'
      ]"
    ></div>
  </button>
</template>
