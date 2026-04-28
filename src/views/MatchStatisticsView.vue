<script setup>
import { ref, onMounted, computed, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { mockApi } from '@/api/mock'
import { useMetricStore } from '@/store/metricStore'
import ToggleSwitch from '@/components/ui/ToggleSwitch.vue'
import DarkCard from '@/components/ui/DarkCard.vue'
import DataTable from '@/components/ui/DataTable.vue'
import ViewSelector from '@/components/ui/ViewSelector.vue'

const route = useRoute()
const router = useRouter()
const metricStore = useMetricStore()

const isLoading = ref(true)
const matchData = ref(null)
const keyPerformances = ref([])
const currentPerformanceIndex = ref(0)

// Initialize from URL query or defaults
const reliabilityFromQuery = route.query.reliability
const isLocalReliability = ref(
  reliabilityFromQuery !== undefined 
    ? reliabilityFromQuery === 'true' 
    : metricStore.globalReliabilityOn
)

const tabFromQuery = route.query.tab
const selectedTab = ref(
  tabFromQuery === 'imp-only' ? 'IMP ONLY' : 'TRADITIONAL'
)

const tabOptions = ['IMP ONLY', 'TRADITIONAL']

// Sync state to URL
watch([selectedTab, isLocalReliability], ([newTab, newReliability]) => {
  router.replace({
    query: {
      ...route.query,
      tab: newTab === 'IMP ONLY' ? 'imp-only' : 'traditional',
      reliability: String(newReliability)
    }
  })
})

const currentPerformance = computed(() => keyPerformances.value[currentPerformanceIndex.value] || null)

const nextPerformance = () => {
  if (keyPerformances.value.length === 0) return
  currentPerformanceIndex.value = (currentPerformanceIndex.value + 1) % keyPerformances.value.length
}

const prevPerformance = () => {
  if (keyPerformances.value.length === 0) return
  currentPerformanceIndex.value = (currentPerformanceIndex.value - 1 + keyPerformances.value.length) % keyPerformances.value.length
}

const TRADITIONAL_COLUMNS = [
  { key: 'player', label: 'Player', align: 'left' },
  { key: 'min', label: 'Min', align: 'right' },
  { key: 'plusMinus', label: '+/-', align: 'right' },
  { key: 'pts', label: 'Pts', align: 'right' },
  { key: 'reb', label: 'Reb', align: 'right' },
  { key: 'ast', label: 'Ast', align: 'right' },
  { key: 'fgPct', label: 'Fg%', align: 'right' },
  { key: 'to', label: 'To', align: 'right' },
  { key: 'blk', label: 'Blk', align: 'right' },
  { key: 'stl', label: 'Stl', align: 'right' },
  { key: 'imp', label: 'Imp', align: 'right' }
]

const IMP_ONLY_COLUMNS = TRADITIONAL_COLUMNS.filter(col => 
  ['player', 'min', 'plusMinus', 'imp'].includes(col.key)
)

const columns = computed(() => {
  return selectedTab.value === 'IMP ONLY' ? IMP_ONLY_COLUMNS : TRADITIONAL_COLUMNS
})

const sortableColumns = ['min', 'plusMinus', 'pts', 'imp']

onMounted(async () => {
  isLoading.value = true
  try {
    const [details, performances] = await Promise.all([
      mockApi.getMatchDetails(route.params.id),
      mockApi.getKeyPerformances(route.params.id)
    ])
    
    if (!details) {
      router.push({ name: 'not-found' })
      return
    }
    
    matchData.value = details
    keyPerformances.value = performances?.data || []
  } catch (error) {
    console.error('Failed to fetch match details:', error)
    router.push({ name: 'not-found' })
  } finally {
    isLoading.value = false
  }
})
</script>

<template>
  <div v-if="isLoading" class="min-h-screen flex items-center justify-center">
    <div class="flex flex-col items-center gap-4">
      <div class="w-16 h-16 border-4 border-primary border-t-secondary-container rounded-full animate-spin"></div>
      <p class="font-data-mono text-data-mono uppercase animate-pulse">Retreiving Match Stats...</p>
    </div>
  </div>

  <main v-else-if="matchData" class="max-w-[1280px] mx-auto p-lg lg:p-jumbo">
    <!-- Header Section -->
    <header class="flex flex-col md:flex-row justify-between items-end mb-xl border-b-4 border-primary pb-md">
      <div class="w-full">
        <h1 class="font-h1 text-h1 uppercase tracking-tighter mb-micro">{{ matchData.title }}</h1>
        <p class="font-label-caps text-label-caps text-neutral-medium uppercase">{{ matchData.subtitle }}</p>
      </div>
      <div class="mt-md md:mt-0 flex gap-base">
        <div class="flex items-center gap-md">
          <span class="font-label-caps text-label-caps uppercase whitespace-nowrap">Reliability</span>
          <ToggleSwitch v-model="isLocalReliability" />
        </div>
      </div>
    </header>

    <!-- Scoreboard & Key Performances -->
    <section class="grid grid-cols-1 md:grid-cols-12 gap-lg mb-jumbo">
      <div class="md:col-span-8 bg-surface-white border-4 border-primary shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] p-lg flex items-center justify-around relative overflow-hidden">
        <!-- Home Team -->
        <div class="flex flex-col items-center gap-md">
          <div class="w-24 h-24 bg-primary text-on-primary flex items-center justify-center border-4 border-primary">
            <span class="material-symbols-outlined text-5xl">sports_basketball</span>
          </div>
          <span class="font-h3 text-h3 uppercase tracking-tighter">{{ matchData.homeTeam.name }}</span>
        </div>
        <!-- Live Score -->
        <div class="flex flex-col items-center">
          <div class="flex items-center gap-xl">
            <span class="font-display-hero text-display-hero" :class="{ 'text-status-positive': matchData.homeTeam.isWinner }">{{ matchData.homeTeam.score }}</span>
            <span class="font-h1 text-h1 text-neutral-medium">:</span>
            <span class="font-display-hero text-display-hero" :class="{ 'text-status-positive': matchData.awayTeam.isWinner }">{{ matchData.awayTeam.score }}</span>
          </div>
          <span class="font-label-caps text-label-caps bg-primary text-on-primary px-md py-micro mt-sm">FINAL</span>
        </div>
        <!-- Away Team -->
        <div class="flex flex-col items-center gap-md">
          <div class="w-24 h-24 bg-surface-container border-4 border-primary flex items-center justify-center">
            <span class="material-symbols-outlined text-5xl">sports_basketball</span>
          </div>
          <span class="font-h3 text-h3 uppercase tracking-tighter">{{ matchData.awayTeam.name }}</span>
        </div>
      </div>

      <!-- Key Performances (Using slot for logic) -->
      <DarkCard title="Key Performances" class="md:col-span-4">
        <template #header-actions>
          <button 
            @click="prevPerformance"
            class="bg-on-primary text-primary w-6 h-6 flex items-center justify-center hover:bg-secondary-container hover:text-white transition-colors cursor-pointer disabled:opacity-50 disabled:cursor-not-allowed"
            :disabled="keyPerformances.length <= 1"
          >
            <span class="material-symbols-outlined text-sm">chevron_left</span>
          </button>
          <button 
            @click="nextPerformance"
            class="bg-on-primary text-primary w-6 h-6 flex items-center justify-center hover:bg-secondary-container hover:text-white transition-colors cursor-pointer disabled:opacity-50 disabled:cursor-not-allowed"
            :disabled="keyPerformances.length <= 1"
          >
            <span class="material-symbols-outlined text-sm">chevron_right</span>
          </button>
        </template>
        
        <div class="space-y-sm mt-md">
          <div v-if="currentPerformance" class="flex items-center justify-between">
            <span class="font-h3 text-h3 uppercase tracking-tighter">{{ currentPerformance.player }}</span>
            <span class="bg-secondary-container text-white px-sm font-data-mono">{{ currentPerformance.imp }}</span>
          </div>
          <p v-if="currentPerformance" class="font-body-reg text-body-reg text-neutral-medium">
            {{ currentPerformance.description }}
          </p>
          <p v-else class="text-neutral-medium italic text-center">No key performances available for this match.</p>
        </div>

        <template #footer>
          <div class="flex gap-xs">
            <div 
              v-for="(_, index) in keyPerformances" 
              :key="index"
              class="h-1.5 transition-all duration-300"
              :class="index === currentPerformanceIndex ? 'w-8 bg-secondary-container' : 'w-4 bg-neutral-charcoal'"
            ></div>
          </div>
        </template>
      </DarkCard>
    </section>

    <!-- Stats View Selector -->
    <div class="mb-xl">
      <ViewSelector v-model="selectedTab" :options="tabOptions" />
    </div>

    <!-- Stats Section: Home Team -->
    <section class="mb-jumbo">
      <div class="flex items-center gap-md mb-md">
        <div class="h-8 w-2 bg-status-positive"></div>
        <h2 class="font-h2 text-h2 uppercase">{{ matchData.homeTeam.name }} Statistics</h2>
      </div>
      <DataTable
        :columns="columns"
        :data="matchData.homeStats"
        highlighted-column="imp"
        :sortable-columns="sortableColumns"
      >
        <template #cell-player="{ value }">
          <span class="font-bold">{{ value }}</span>
        </template>
        <template #cell-plusMinus="{ value }">
          <span :class="value > 0 ? 'text-status-positive' : value < 0 ? 'text-status-negative' : ''">
            {{ value > 0 ? '+' + value : value }}
          </span>
        </template>
      </DataTable>
    </section>

    <!-- Stats Section: Away Team -->
    <section class="mb-jumbo">
      <div class="flex items-center gap-md mb-md">
        <div class="h-8 w-2 bg-neutral-charcoal"></div>
        <h2 class="font-h2 text-h2 uppercase">{{ matchData.awayTeam.name }} Statistics</h2>
      </div>
      <DataTable
        :columns="columns"
        :data="matchData.awayStats"
        highlighted-column="imp"
        :sortable-columns="sortableColumns"
      >
        <template #cell-player="{ value }">
          <span class="font-bold">{{ value }}</span>
        </template>
        <template #cell-plusMinus="{ value }">
          <span :class="value > 0 ? 'text-status-positive' : value < 0 ? 'text-status-negative' : ''">
            {{ value > 0 ? '+' + value : value }}
          </span>
        </template>
      </DataTable>
    </section>
  </main>
</template>
