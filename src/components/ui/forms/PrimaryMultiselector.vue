<script setup>
import { ref, onMounted, onUnmounted } from 'vue'

const props = defineProps({
  modelValue: {
    type: Array,
    required: true
  },
  options: {
    type: Array,
    required: true
  },
  label: {
    type: String,
    default: 'SELECT OPTIONS'
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

const toggleOption = (option) => {
  const value = typeof option === 'object' ? option[props.valueKey] : option
  const newValue = [...props.modelValue]
  const index = newValue.indexOf(value)
  
  if (index > -1) {
    newValue.splice(index, 1)
  } else {
    newValue.push(value)
  }
  
  emit('update:modelValue', newValue)
}

const isChecked = (option) => {
  const value = typeof option === 'object' ? option[props.valueKey] : option
  return props.modelValue.includes(value)
}

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
  <div class="relative inline-block w-full md:w-auto" ref="selectRef">
    <button 
      @click="toggleDropdown"
      class="w-full bg-surface-white border-2 border-primary px-4 sm:px-lg py-2 sm:py-sm flex items-center justify-between md:justify-start gap-2 sm:gap-md font-label-caps text-xs sm:text-sm font-bold shadow-[4px_4px_0px_0px_rgba(28,27,27,1)] transition-all active:translate-y-[2px] active:shadow-none uppercase cursor-pointer hover:bg-ghost-gray"
    >
      <span class="truncate">{{ label }}</span>
      <span 
        class="material-symbols-outlined text-primary text-sm sm:text-base transition-transform duration-200"
        :class="{ 'rotate-180': isOpen }"
      >
        {{ icon }}
      </span>
    </button>

    <div 
      v-if="isOpen"
      class="absolute z-50 left-0 md:left-auto md:right-0 mt-2 bg-white w-full md:min-w-[240px] border-2 border-black shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] p-sm animate-in fade-in slide-in-from-top-2 duration-150"
    >
      <div class="space-y-sm">
        <label 
          v-for="(option, index) in options" 
          :key="index"
          class="flex items-center gap-sm cursor-pointer hover:bg-ghost-gray p-xs border border-transparent hover:border-primary transition-colors group"
        >
          <input 
            type="checkbox" 
            :checked="isChecked(option)"
            @change="toggleOption(option)"
            class="w-5 h-5 border-2 border-primary rounded-none checked:bg-secondary-container focus:ring-0 focus:ring-offset-0 outline-none cursor-pointer transition-colors"
          />
          <span class="font-label-caps text-[10px] sm:text-xs uppercase">
            {{ typeof option === 'object' ? option[labelKey] : option }}
          </span>
        </label>
        
        <div class="border-t-2 border-primary mt-sm pt-sm">
          <button 
            @click="isOpen = false"
            class="w-full bg-primary text-white font-label-caps text-[10px] py-2 uppercase tracking-tighter cursor-pointer hover:bg-neutral-charcoal transition-colors"
          >
            APPLY FILTERS
          </button>
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
