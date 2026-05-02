<script setup>
import { ref, watch } from 'vue'

const props = defineProps({
  modelValue: {
    type: [Number, String],
    required: true
  },
  min: {
    type: [Number, String],
    default: 0
  },
  max: {
    type: [Number, String],
    default: 100
  },
  label: {
    type: String,
    default: ''
  }
})

const emit = defineEmits(['update:modelValue'])

// Local state for smooth visual updates during drag
const localValue = ref(props.modelValue)

// Sync if parent updates modelValue
watch(() => props.modelValue, (newVal) => {
  localValue.value = newVal
})

const onInput = (event) => {
  localValue.value = event.target.value
}

const onChange = (event) => {
  emit('update:modelValue', Number(event.target.value))
}
</script>

<template>
  <div class="flex flex-col gap-1">
    <label v-if="label" class="font-label-caps text-xs uppercase text-on-background">{{ label }}</label>
    <div class="border-2 border-black bg-white p-4 h-14 flex items-center gap-4">
      <span class="font-data-mono text-xs">{{ min }}</span>
      <input 
        type="range" 
        :min="min" 
        :max="max" 
        :value="localValue"
        @input="onInput"
        @change="onChange"
        class="w-full accent-secondary h-2 bg-ghost-gray appearance-none cursor-pointer"
      />
      <span class="font-data-mono text-xs">{{ max }}</span>
      <div class="min-w-[2.5rem] text-right font-data-mono text-xs font-bold text-secondary">
        {{ localValue }}
      </div>
    </div>
  </div>
</template>

<style scoped>
input[type='range']::-webkit-slider-runnable-track {
  background: #F0F0F0;
  height: 8px;
  border: 1px solid black;
}

input[type='range']::-webkit-slider-thumb {
  -webkit-appearance: none;
  appearance: none;
  width: 16px;
  height: 24px;
  background: black;
  border: 2px solid white;
  margin-top: -9px;
  box-shadow: 2px 2px 0px black;
}
</style>
