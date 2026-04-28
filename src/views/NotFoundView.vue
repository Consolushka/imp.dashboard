<script setup>
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const canvasRef = ref(null)

const goHome = () => {
  router.push('/')
}

onMounted(() => {
  const canvas = canvasRef.value
  if (!canvas) return
  const ctx = canvas.getContext('2d')
  const w = canvas.width
  const h = canvas.height

  // Background
  ctx.fillStyle = '#fdf8f8'
  ctx.fillRect(0, 0, w, h)

  // Draw a broken basketball
  ctx.strokeStyle = '#000000'
  ctx.lineWidth = 4

  // Main circle
  ctx.beginPath()
  ctx.arc(w / 2, h / 2, 80, 0, Math.PI * 2)
  ctx.stroke()

  // Basketball lines
  ctx.beginPath()
  ctx.moveTo(w / 2 - 80, h / 2)
  ctx.lineTo(w / 2 + 80, h / 2)
  ctx.stroke()

  ctx.beginPath()
  ctx.moveTo(w / 2, h / 2 - 80)
  ctx.lineTo(w / 2, h / 2 + 80)
  ctx.stroke()

  // "Crack"
  ctx.strokeStyle = '#fe6a34'
  ctx.lineWidth = 6
  ctx.beginPath()
  ctx.moveTo(w / 2 - 40, h / 2 - 40)
  ctx.lineTo(w / 2 + 10, h / 2 - 10)
  ctx.lineTo(w / 2 - 10, h / 2 + 20)
  ctx.lineTo(w / 2 + 30, h / 2 + 50)
  ctx.stroke()

  // 404 Text
  ctx.fillStyle = '#000000'
  ctx.font = 'bold 80px "IBM Plex Mono"'
  ctx.textAlign = 'center'
  ctx.fillText('404', w / 2, h / 2 + 180)
  
  ctx.font = '20px "Inter"'
  ctx.fillText('PAGE NOT FOUND', w / 2, h / 2 + 220)
})
</script>

<template>
  <div class="min-h-screen bg-background flex flex-col items-center justify-center p-lg">
    <canvas ref="canvasRef" width="400" height="500" class="max-w-full"></canvas>
    
    <button 
      @click="goHome"
      class="mt-xl px-xl py-md bg-secondary-container text-white font-label-caps border-4 border-primary shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] hover:translate-x-[-2px] hover:translate-y-[-2px] hover:shadow-[10px_10px_0px_0px_rgba(0,0,0,1)] active:translate-x-0 active:translate-y-0 active:shadow-none transition-all uppercase cursor-pointer"
    >
      Return to Safety
    </button>
  </div>
</template>
