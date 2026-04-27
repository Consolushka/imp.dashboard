<script setup>
import { ref, onMounted, onUnmounted, computed } from 'vue'

const props = defineProps({
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
  valueKey: {
    type: String,
    default: 'value'
  },
  labelKey: {
    type: String,
    default: 'label'
  }
})

const emit = defineEmits(['update:modelValue'])

const isOpen = ref(false)
const selectRef = ref(null)

const toggleDropdown = () => {
  isOpen.value = !isOpen.value
}

const selectOption = (option) => {
  const value = typeof option === 'object' ? option[props.valueKey] : option
  emit('update:modelValue', value)
  isOpen.value = false
}

const selectedLabel = computed(() => {
  const found = props.options.find(opt => {
    const val = typeof opt === 'object' ? opt[props.valueKey] : opt
    return val === props.modelValue
  })
  if (!found) return props.modelValue
  return typeof found === 'object' ? found[props.labelKey] : found
})

const handleClickOutside = (event) => {
  if (selectRef.value && !selectRef.value.contains(event.target)) {
    isOpen.value = false
  }
}

onMounted(() => {
  window.addEventListener('click', handleClickOutside)
})

onUnmounted(() => {
  window.removeEventListener('click', handleClickOutside)
})
</script>

<template>
  <div class="flex flex-col sm:flex-row sm:items-center items-start gap-2 sm:gap-3" ref="selectRef">
    <span v-if="label" class="font-label-caps text-label-caps uppercase text-primary text-xs sm:text-sm">{{ label }}</span>
    <div class="relative min-w-[160px] w-full sm:w-auto">
      <!-- Trigger Button -->
      <button 
        @click="toggleDropdown"
        class="w-full flex justify-between items-center bg-surface-white border-2 border-border-dark px-4 py-2 font-data-mono text-data-mono shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] hover:translate-x-[-2px] hover:translate-y-[-2px] hover:shadow-[6px_6px_0px_0px_rgba(0,0,0,1)] active:translate-x-0 active:translate-y-0 active:shadow-[2px_2px_0px_0px_rgba(0,0,0,1)] transition-all cursor-pointer"
      >
        <span>{{ selectedLabel }}</span>
        <span 
          class="material-symbols-outlined transition-transform duration-200"
          :class="{ 'rotate-180': isOpen }"
        >
          expand_more
        </span>
      </button>

      <!-- Options Dropdown -->
      <div 
        v-if="isOpen"
        class="absolute z-50 left-0 right-0 mt-2 bg-surface-white border-2 border-border-dark shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] overflow-hidden animate-in fade-in slide-in-from-top-2 duration-150"
      >
        <div 
          v-for="(option, index) in options" 
          :key="index"
          @click="selectOption(option)"
          class="px-4 py-2 font-data-mono text-data-mono cursor-pointer hover:bg-ghost-gray transition-colors border-b last:border-b-0 border-border-dark"
          :class="{ 
            'bg-secondary-container text-white': (typeof option === 'object' ? option[valueKey] : option) === modelValue 
          }"
        >
          {{ typeof option === 'object' ? option[labelKey] : option }}
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.animate-in {
  animation-fill-mode: forwards;
}
@keyframes fade-in {
  from { opacity: 0; }
  to { opacity: 1; }
}
@keyframes slide-in-from-top-2 {
  from { transform: translateY(-0.5rem); }
  to { transform: translateY(0); }
}
.fade-in { animation-name: fade-in; }
.slide-in-from-top-2 { animation-name: slide-in-from-top-2; }
</style>
