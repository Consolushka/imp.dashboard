<script setup>
import CardImportant from '../components/ui/CardImportant.vue'
</script>

<template>
  <main class="max-w-[1280px] mx-auto px-6 md:px-12 py-12 lg:py-24 space-y-jumbo">
    <!-- TITLE SECTION -->
    <header class="border-b-[6px] border-primary pb-lg">
      <h1 class="font-display-hero text-display-hero uppercase text-primary leading-none">
        THE IMP <span class="text-secondary">IDEOLOGY</span>
      </h1>
    </header>

    <!-- DATA SOURCING SECTION -->
    <section class="space-y-lg">
      <div class="flex items-baseline gap-base">
        <h2 class="font-h1 text-h1 uppercase">Synchronized <span class="text-secondary">Analytics</span></h2>
        <div class="h-1 flex-grow bg-primary"></div>
      </div>
      
      <div class="grid grid-cols-1 lg:grid-cols-12 gap-lg items-stretch">
        <div class="lg:col-span-4 bg-primary p-lg flex flex-col justify-between shadow-[8px_8px_0px_0px_rgba(254,106,52,1)]">
          <span class="material-symbols-outlined text-white text-[48px]">sync</span>
          <h2 class="font-h2 text-h2 text-white uppercase mt-lg">Synchronized Analytics</h2>
        </div>
        <div class="lg:col-span-8 neo-border p-lg flex flex-col justify-center bg-surface-white">
          <div class="space-y-md">
            <div class="flex items-center gap-md">
              <div class="h-4 w-4 bg-secondary"></div>
              <p class="font-label-caps text-primary uppercase">Multi-Source Aggregation</p>
            </div>
            <div class="space-y-base pt-md">
              <div class="flex items-start gap-md border-l-4 border-secondary pl-md">
                <p class="font-h3 text-h3 uppercase text-primary leading-tight">
                  <span class="block text-xs font-label-caps text-secondary">01. Agility</span>
                  Multi-Source Agility: <span class="text-secondary">3</span> providers
                </p>
              </div>
              <div class="flex items-start gap-md border-l-4 border-secondary pl-md">
                <p class="font-h3 text-h3 uppercase text-primary leading-tight">
                  <span class="block text-xs font-label-caps text-secondary">02. Frequency</span>
                  High-Frequency Sync: <span class="text-secondary">30m</span> sync rate
                </p>
              </div>
              <div class="flex items-start gap-md border-l-4 border-secondary pl-md">
                <p class="font-h3 text-h3 uppercase text-primary leading-tight">
                  <span class="block text-xs font-label-caps text-secondary">03. Standard</span>
                  Strict Data Normalization
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- WHAT IS IMP SECTION -->
    <section class="space-y-lg">
      <div class="flex flex-row-reverse items-baseline gap-base">
        <h2 class="font-h1 text-h1 uppercase">Defining <span class="text-secondary">IMP</span></h2>
        <div class="h-1 flex-grow bg-primary"></div>
      </div>
      
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-lg">
        <div class="space-y-md">
          <p class="font-body-lg text-body-lg">
            The <strong class="font-bold">Impact (IMP)</strong> is more than just a box score. It is the definitive measure of a player's atmospheric influence on the game flow. While +/- measures what happened, IMP explains the weight of that occurrence relative to the environment of the game.
          </p>
          <div class="bg-primary text-white p-lg neo-shadow border-l-[12px] border-secondary">
            <p class="font-label-caps text-secondary mb-base">THE CORE ALGORITHM</p>
            <p class="font-h2 text-h2 font-data-mono tracking-tighter">
              IMP = (P+/- - TFD) / MP
            </p>
            <div class="mt-base text-stone-400 font-data-mono text-xs flex gap-lg">
              <span>P+/-: Player Plus/Minus</span>
              <span>TFD: Team Final Diff</span>
              <span>MP: Minutes Played</span>
            </div>
          </div>
        </div>
        
        <CardImportant 
          title="What does IMP tells You?" 
          :items="['IMP (with reliability disabled) tells us how the final score would differ if the player had played the entire game. It\'s the ultimate \'What If\' simulator for professional rosters.']" 
          icon="lightbulb" 
          class="bg-secondary-container"
        />
      </div>
    </section>

    <!-- RELIABILITY SECTION -->
    <section class="space-y-lg">
      <div class="flex items-baseline gap-base">
        <h2 class="font-h1 text-h1 uppercase">The <span class="text-secondary">Reliability</span> Engine</h2>
        <div class="h-1 flex-grow bg-primary"></div>
      </div>
      
      <div class="grid grid-cols-1 lg:grid-cols-12 gap-xl">
        <div class="lg:col-span-5 space-y-md">
          <p class="font-body-lg text-body-lg text-neutral-charcoal">
            Our <strong>Reliability</strong> metric ensures pinpoint accuracy in player evaluation through a smart, <strong>dual-phase approach</strong>. Initially, it <strong>filters out statistical noise</strong> from small sample sizes, building trust until a player reaches the <strong>"Gold Standard" of playtime</strong>, where data reliability hits exactly <strong>100%</strong>. Beyond this peak, the system seamlessly applies a <strong>fatigue factor</strong> to gracefully account for late-game exhaustion and overtime anomalies. This guarantees realistic, high-quality stats <strong>without unfairly penalizing star players</strong> who carry a heavy rotational load.
          </p>
        </div>
        <div class="lg:col-span-7">
          <div class="bg-white p-base neo-border neo-shadow">
            <img alt="Reliability Curve" class="w-full h-[300px] object-contain border border-primary bg-stone-950" src="/reliability_graph.jpg" />
            <div class="mt-base flex justify-between items-center px-xs">
              <p class="font-label-caps text-xs text-primary">RELIABILITY CURVE</p>
              <span class="material-symbols-outlined text-secondary">analytics</span>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- REAL-WORLD SCENARIOS -->
    <section class="space-y-lg pb-jumbo">
      <div class="flex flex-row-reverse items-baseline gap-base">
        <h2 class="font-h1 text-h1 uppercase">Tactical <span class="text-secondary">Scenarios</span></h2>
        <div class="h-1 flex-grow bg-primary"></div>
      </div>
      
      <div class="grid grid-cols-1 md:grid-cols-3 gap-lg">
        <!-- Scenario 1 -->
        <div class="bg-surface-white neo-border p-lg hover:translate-x-[-4px] hover:translate-y-[-4px] transition-transform duration-200 cursor-default group flex flex-col">
          <div class="flex justify-between mb-md">
            <span class="font-label-caps text-secondary">SCENARIO A</span>
            <span class="material-symbols-outlined text-primary group-hover:rotate-12 transition-transform">visibility_off</span>
          </div>
          <h3 class="font-h3 text-h3 mb-sm uppercase">The Invisible Hero</h3>
          <p class="font-body-reg text-neutral-charcoal mb-lg flex-grow">
            Player logs <strong class="text-primary">40 mins</strong> and a <strong class="text-primary">+10 +/-</strong>. Meanwhile, the team lost by <strong class="text-status-negative">-5</strong>. Despite the team's failure, the player's IMP scales to <strong class="text-status-positive">+20</strong>.
          </p>
          <div class="bg-primary text-white p-sm font-data-mono text-center text-xl">
            RESULT: +20 IMP
          </div>
        </div>
        <!-- Scenario 2 -->
        <div class="bg-surface-white neo-border p-lg hover:translate-x-[-4px] hover:translate-y-[-4px] transition-transform duration-200 cursor-default group flex flex-col">
          <div class="flex justify-between mb-md">
            <span class="font-label-caps text-secondary">SCENARIO B</span>
            <span class="material-symbols-outlined text-primary group-hover:rotate-12 transition-transform">directions_walk</span>
          </div>
          <h3 class="font-h3 text-h3 mb-sm uppercase">The System Passenger</h3>
          <p class="font-body-reg text-neutral-charcoal mb-lg flex-grow">
            Player logs <strong class="text-primary">40 mins</strong> but manages a <strong class="text-status-negative">-5 +/-</strong> while the team cruised to a <strong class="text-status-positive">+3</strong> win. The metric identifies the drag on efficiency.
          </p>
          <div class="bg-primary text-white p-sm font-data-mono text-center text-xl">
            RESULT: -10 IMP
          </div>
        </div>
        <!-- Scenario 3 -->
        <div class="bg-secondary p-lg hover:translate-x-[-4px] hover:translate-y-[-4px] transition-transform duration-200 cursor-default text-white group flex flex-col">
          <div class="flex justify-between mb-md">
            <span class="font-label-caps text-white">SCENARIO C</span>
            <span class="material-symbols-outlined text-white group-hover:rotate-12 transition-transform">cleaning_services</span>
          </div>
          <h3 class="font-h3 text-h3 mb-sm uppercase">Garbage Time Smoothing</h3>
          <p class="font-body-reg text-white mb-lg flex-grow">
            A player enters for <strong class="text-white underline">1 min</strong> during a blowout and nets <strong class="text-white underline">+6</strong>. Reliability engine detects the sample size risk and smooths the <span class="underline">IMP</span> toward zero.
          </p>
          <div class="bg-white text-primary p-sm font-data-mono text-center text-xl">
            SMOOTHED: 0.2 IMP
          </div>
        </div>
      </div>
    </section>
  </main>
</template>

<style scoped>
.neo-shadow { box-shadow: 4px 4px 0px 0px rgba(0,0,0,1); }
.neo-border { border: 2px solid #000000; }
</style>
