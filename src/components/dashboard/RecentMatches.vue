<template>
  <section class="bg-surface-white border-2 border-border-dark shadow-[4px_4px_0px_0px_rgba(0,0,0,1)]">
    <div class="bg-tertiary border-b-2 border-border-dark p-md flex justify-between items-center">
      <h3 class="font-h3 text-h3 text-on-tertiary uppercase">RECENT MATCHES</h3>
      <button class="text-on-tertiary font-label-caps text-label-caps hover:text-secondary-container transition-colors uppercase border-b border-transparent hover:border-secondary-container">VIEW ALL</button>
    </div>
    <div class="flex flex-col">
      <!-- Match 1 -->
      <div class="flex flex-col border-b-2 border-border-dark p-md hover:bg-ghost-gray transition-colors cursor-pointer">
        <div class="flex justify-between items-center mb-sm">
          <span class="font-data-mono text-data-mono text-neutral-medium">FINAL</span>
          <span class="font-data-mono text-data-mono bg-border-dark text-surface-white px-2 py-1 text-xs">NBA</span>
        </div>
        <div class="flex justify-between items-center">
          <div class="flex items-center gap-3 w-1/3">
            <div class="w-10 h-10 bg-primary-fixed rounded-full border border-border-dark flex items-center justify-center">
              <span class="material-symbols-outlined text-tertiary">sports_basketball</span>
            </div>
            <span class="font-h3 text-h3 text-status-positive">LAL</span>
          </div>
          <div class="flex flex-col items-center w-1/3">
            <div class="flex items-center gap-4">
              <span class="font-display-hero text-display-hero text-status-positive">112</span>
              <span class="font-h2 text-h2 text-outline">-</span>
              <span class="font-display-hero text-display-hero text-on-surface">105</span>
            </div>
            <span class="font-label-caps text-label-caps text-status-positive bg-status-positive/10 px-2 py-1 border border-status-positive mt-2">WINNER</span>
          </div>
          <div class="flex items-center justify-end gap-3 w-1/3">
            <span class="font-h3 text-h3 text-on-surface">BOS</span>
            <div class="w-10 h-10 bg-primary-fixed rounded-full border border-border-dark flex items-center justify-center">
              <span class="material-symbols-outlined text-tertiary">sports_basketball</span>
            </div>
          </div>
        </div>
      </div>
      <!-- Match 2 -->
      <div class="flex flex-col border-b-2 border-border-dark p-md hover:bg-ghost-gray transition-colors cursor-pointer">
        <div class="flex justify-between items-center mb-sm">
          <span class="font-data-mono text-data-mono text-neutral-medium">FINAL</span>
          <span class="font-data-mono text-data-mono bg-border-dark text-surface-white px-2 py-1 text-xs">NBA</span>
        </div>
        <div class="flex justify-between items-center">
          <div class="flex items-center gap-3 w-1/3">
            <div class="w-10 h-10 bg-primary-fixed rounded-full border border-border-dark flex items-center justify-center">
              <span class="material-symbols-outlined text-tertiary">sports_basketball</span>
            </div>
            <span class="font-h3 text-h3 text-on-surface">GSW</span>
          </div>
          <div class="flex flex-col items-center w-1/3">
            <div class="flex items-center gap-4">
              <span class="font-display-hero text-display-hero text-on-surface">98</span>
              <span class="font-h2 text-h2 text-outline">-</span>
              <span class="font-display-hero text-display-hero text-status-positive">104</span>
            </div>
            <span class="font-label-caps text-label-caps text-status-positive bg-status-positive/10 px-2 py-1 border border-status-positive mt-2">WINNER</span>
          </div>
          <div class="flex items-center justify-end gap-3 w-1/3">
            <span class="font-h3 text-h3 text-status-positive">DEN</span>
            <div class="w-10 h-10 bg-primary-fixed rounded-full border border-border-dark flex items-center justify-center">
              <span class="material-symbols-outlined text-tertiary">sports_basketball</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>
