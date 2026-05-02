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
  },
  icon: {
    type: String,
    default: 'expand_more'
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
  <div class="flex flex-col gap-1" ref="selectRef">
    <label v-if="label" class="font-label-caps text-xs uppercase text-on-background">{{ label }}</label>
    <div class="relative w-full">
      <!-- Trigger Button -->
      <button 
        @click="toggleDropdown"
        class="w-full h-14 flex justify-between items-center bg-white border-2 border-black px-4 font-data-mono text-xs transition-colors hover:bg-ghost-gray cursor-pointer"
      >
        <span>{{ selectedLabel }}</span>
        <span 
          class="material-symbols-outlined text-sm transition-transform duration-200"
          :class="{ 'rotate-180': isOpen }"
        >
          {{ icon }}
        </span>
      </button>

      <!-- Options Dropdown -->
      <div 
        v-if="isOpen"
        class="absolute z-50 left-0 right-0 mt-1 bg-white border-2 border-black shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] overflow-hidden"
      >
        <div 
          v-for="(option, index) in options" 
          :key="index"
          @click="selectOption(option)"
          class="px-4 py-3 font-data-mono text-xs cursor-pointer transition-colors border-b last:border-b-0 border-black"
          :class="{ 
            'bg-black text-white': (typeof option === 'object' ? option[valueKey] : option) === modelValue,
            'hover:bg-ghost-gray': (typeof option === 'object' ? option[valueKey] : option) !== modelValue
          }"
        >
          {{ typeof option === 'object' ? option[labelKey] : option }}
        </div>
      </div>
    </div>
  </div>
</template>
