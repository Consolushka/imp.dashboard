<script setup>
import { ref, watch } from 'vue'
import { rateLimitedUntil } from '../../api/client'

const secondsLeft = ref(0)
let timer = null

const tick = () => {
  secondsLeft.value = Math.ceil((rateLimitedUntil.value - Date.now()) / 1000)
  if (secondsLeft.value > 0) return
  clearInterval(timer)
  timer = null
  rateLimitedUntil.value = null
}

// Повторный 429 во время отсчёта только сдвигает конец: таймер уже идёт и прочитает новое значение
watch(rateLimitedUntil, (until) => {
  if (!until || timer) return
  tick()
  timer = setInterval(tick, 1000)
})
</script>

<template>
  <!-- На мобилке снизу закреплено меню, поднимаем всплывашку над ним -->
  <div
    v-if="secondsLeft > 0"
    role="status"
    class="fixed right-4 bottom-20 md:bottom-4 z-50 max-w-[calc(100vw-2rem)] flex items-center gap-2 bg-white border-2 border-black shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] px-md py-sm font-data-mono text-xs uppercase"
  >
    <span class="material-symbols-outlined text-error">warning</span>
    <span>Too many requests. Try again in {{ secondsLeft }} s</span>
  </div>
</template>
