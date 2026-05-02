<script setup>
import { ref, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { mockApi } from '../api/mock'
import { useTournamentStore } from '../store/tournamentStore'
import { useMetricStore } from '../store/metricStore'
import PrimarySelector from '../components/ui/forms/PrimarySelector.vue'
import SecondarySelector from '../components/ui/forms/SecondarySelector.vue'
import SegmentedControl from '../components/ui/forms/SegmentedControl.vue'
import RangeSlider from '../components/ui/forms/RangeSlider.vue'

const tournamentStore = useTournamentStore()
const metricStore = useMetricStore()
const route = useRoute()
const router = useRouter()

const avgMinutesRange = ref(route.query.avgMins ? Number(route.query.avgMins) : 20)
const performanceOrder = ref(route.query.order || 'desc') // API expects 'asc' or 'desc'
const resultsLimit = ref(route.query.limit ? Number(route.query.limit) : 10)
const selectedTeam = ref(route.query.team || 'all')
const gameMinMinutes = ref(route.query.minMins ? Number(route.query.minMins) : 20)

const isLoading = ref(false)
const players = ref([])

const performanceOptions = [
  { label: 'BEST', value: 'desc' },
  { label: 'WORST', value: 'asc' }
]

const limitOptions = [
  { label: '3', value: 3 },
  { label: '5', value: 5 },
  { label: '10', value: 10 },
  { label: '25', value: 25 }
]

const teamOptions = [
  { label: 'ALL TEAMS', value: 'all' },
  { label: 'CHICAGO', value: 'CHI' },
  { label: 'HOUSTON', value: 'HOU' },
  { label: 'PHOENIX', value: 'PHX' },
  { label: 'GOLDEN STATE', value: 'GSW' },
  { label: 'BOSTON', value: 'BOS' }
]

const minMinutesOptions = [
  { label: '10 MINS', value: 10 },
  { label: '15 MINS', value: 15 },
  { label: '20 MINS', value: 20 },
  { label: '25 MINS', value: 25 }
]

const fetchLeaderboardData = async () => {
  if (!metricStore.selectedTournamentId) {
    console.log('Leaderboard: No tournament selected, skipping fetch')
    return
  }
  
  console.log('Leaderboard: Fetching data for tournament', metricStore.selectedTournamentId)
  isLoading.value = true
  try {
    const response = await mockApi.getLeaderboard({
      tournament_id: metricStore.selectedTournamentId,
      per: 'fullGame',
      limit: resultsLimit.value,
      order: performanceOrder.value,
      use_reliability: metricStore.globalReliabilityOn
    })
    console.log('Leaderboard: Data received', response.data)
    players.value = response.data
  } catch (error) {
    console.error('Failed to fetch leaderboard:', error)
  } finally {
    console.log('Leaderboard: Fetch finished, setting isLoading to false')
    isLoading.value = false
  }
}

onMounted(async () => {
  if (metricStore.tournaments.length === 0) {
    await metricStore.fetchTournaments()
  }
  
  fetchLeaderboardData()
})

watch(
  [avgMinutesRange, performanceOrder, resultsLimit, selectedTeam, gameMinMinutes],
  ([avgMins, order, limit, team, minMins]) => {
    router.replace({
      query: {
        ...route.query,
        avgMins: avgMins === 20 ? undefined : avgMins,
        order: order === 'desc' ? undefined : order,
        limit: limit === 10 ? undefined : limit,
        team: team === 'all' ? undefined : team,
        minMins: minMins === 20 ? undefined : minMins,
      }
    })
  },
  { deep: true }
)

watch(
  [() => metricStore.selectedTournamentId, avgMinutesRange, performanceOrder, resultsLimit, selectedTeam, gameMinMinutes, () => metricStore.globalReliabilityOn],
  fetchLeaderboardData
)
</script>

<template>
  <main class="max-w-[1280px] mx-auto p-lg lg:p-xl space-y-xl">
    <!-- Header Section -->
    <header class="border-b-4 border-black pb-lg flex flex-col md:flex-row md:items-end justify-between gap-md">
      <div>
        <h1 class="font-h1 text-h1 uppercase tracking-tighter">IMP LEADERBOARD</h1>
      </div>
      <!-- Large Primary Filter -->
      <div class="w-full md:w-80">
        <PrimarySelector 
          v-model="metricStore.selectedTournamentId" 
          :options="metricStore.tournaments" 
          value-key="id"
          label-key="name"
          label="SELECT TOURNAMENT"
        />
      </div>
    </header>

    <!-- Controls Grid -->
    <section class="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-5 gap-md items-end">
      <!-- Avg Minutes Range -->
      <RangeSlider 
        v-model="avgMinutesRange" 
        :min="0" 
        :max="48" 
        label="Avg Minutes Range"
      />

      <!-- Direction Toggle -->
      <SegmentedControl 
        v-model="performanceOrder"
        :options="performanceOptions"
        label="Order"
        activeColorClass="bg-secondary text-white"
      />

      <!-- Player Count Selector -->
      <SegmentedControl 
        v-model="resultsLimit"
        :options="limitOptions"
        label="Show Results"
        activeColorClass="bg-secondary text-white"
      />

      <!-- Team Selection -->
      <SecondarySelector 
        v-model="selectedTeam"
        :options="teamOptions"
        label="Team Selection"
        icon="filter_list"
      />

      <!-- Single Game Min -->
      <SecondarySelector 
        v-model="gameMinMinutes"
        :options="minMinutesOptions"
        label="Game Min. Mins"
      />
    </section>

    <!-- Main Content: Data Table -->
    <section class="shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] border-4 border-black bg-white overflow-x-auto relative min-h-[400px]">
      <!-- Loading Overlay -->
      <div v-if="isLoading" class="absolute inset-0 bg-white/50 z-20 flex items-center justify-center backdrop-blur-[1px]">
        <div class="flex flex-col items-center gap-4">
          <div class="w-12 h-12 border-4 border-black border-t-secondary animate-spin"></div>
          <p class="font-data-mono text-xs uppercase animate-pulse">Recalculating Rankings...</p>
        </div>
      </div>

      <table class="w-full text-left border-collapse">
        <thead>
          <tr class="bg-black text-white border-b-4 border-black">
            <th class="px-md py-sm font-label-caps text-sm">RANK</th>
            <th class="px-md py-sm font-label-caps text-sm">PLAYER NAME</th>
            <th class="px-md py-sm font-label-caps text-sm">TEAM</th>
            <th class="px-md py-sm font-label-caps text-sm text-right">GP</th>
            <th class="px-md py-sm font-label-caps text-sm text-right">AVG MINS</th>
            <th class="px-md py-sm font-label-caps text-sm text-right bg-secondary">IMP SCORE</th>
          </tr>
        </thead>
        <tbody class="font-data-mono text-sm">
          <tr 
            v-for="(player, index) in players" 
            :key="player.id"
            class="border-b-2 border-black transition-colors group hover:bg-ghost-gray"
          >
            <td 
              class="px-md py-md font-bold text-lg"
              :class="{ 
                'bg-secondary text-white': index === 0,
                'bg-[#ffb59d]': index === 1,
                'bg-surface-container-highest': index === 2
              }"
            >
              #{{ String(player.position).padStart(2, '0') }}
            </td>
            <td class="px-md py-md">
              <span class="uppercase font-bold">{{ player.fullName }}</span>
            </td>
            <td class="px-md py-md">
              <div class="flex items-center gap-xs">
                <!-- Standard Team Avatar -->
                <div class="w-8 h-8 bg-primary-fixed rounded-full border border-border-dark flex items-center justify-center">
                  <span class="material-symbols-outlined text-tertiary text-lg">sports_basketball</span>
                </div>
                <span>{{ player.teamAlias }}</span>
              </div>
            </td>
            <td class="px-md py-md text-right">{{ player.gamesCount }}</td>
            <td class="px-md py-md text-right">{{ player.avgMinutes }}</td>
            <td class="px-md py-md text-right bg-secondary/10 font-black text-secondary group-hover:bg-secondary group-hover:text-white transition-colors text-lg">
              {{ player.avgImp }}
            </td>
          </tr>

          <!-- Empty State -->
          <tr v-if="!isLoading && players.length === 0">
            <td colspan="6" class="px-md py-xl text-center text-neutral-medium uppercase">
              No players found matching current criteria
            </td>
          </tr>
        </tbody>
      </table>
    </section>

    <!-- Pagination / Footer Info -->
    <footer class="flex flex-col md:flex-row justify-between items-center gap-md border-t-2 border-black pt-lg">
      <div class="font-data-mono text-xs uppercase">
        Showing 1-{{ players.length }} of 482 active players qualified by intensity metrics
      </div>
      <div class="flex gap-1">
        <button class="bg-white border-2 border-black px-md py-sm font-label-caps hover:bg-black hover:text-white transition-colors">PREV</button>
        <button class="bg-black text-white border-2 border-black px-md py-sm font-label-caps">NEXT</button>
      </div>
    </footer>
  </main>

  <!-- Refresh FAB -->
  <button 
    @click="fetchLeaderboardData"
    class="fixed bottom-8 right-8 w-16 h-16 bg-black text-white border-4 border-white shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] flex items-center justify-center hover:scale-110 active:scale-95 transition-all z-30"
  >
    <span class="material-symbols-outlined text-3xl">refresh</span>
  </button>
</template>

