<template>
  <section class="bg-surface-white border-2 border-border-dark shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] overflow-hidden">
    <div class="bg-tertiary p-md flex justify-between items-center">
      <h3 class="font-h3 text-h3 text-on-tertiary uppercase">PLAYERS OF THE DAY</h3>
    </div>
    <div class="overflow-x-auto w-full">
      <table class="w-full text-left border-collapse">
        <thead>
          <tr class="bg-ghost-gray border-b-2 border-border-dark">
            <th class="font-label-caps text-label-caps text-primary p-sm border-r border-border-light">PLAYER</th>
            <th class="font-label-caps text-label-caps text-primary p-sm border-r border-border-light text-right">TEAM</th>
            <th class="font-label-caps text-label-caps text-primary p-sm border-r border-border-light text-right">MIN</th>
            <th class="font-label-caps text-label-caps text-primary p-sm border-r border-border-light text-right">PTS</th>
            <th class="font-label-caps text-label-caps text-primary p-sm border-r border-border-light text-right">REB</th>
            <th class="font-label-caps text-label-caps text-primary p-sm border-r border-border-light text-right">AST</th>
            <th class="font-label-caps text-label-caps text-secondary-container p-sm text-right bg-secondary-fixed/30">IMP</th>
          </tr>
        </thead>
        <tbody>
          <tr class="border-b border-border-light hover:bg-ghost-gray transition-colors">
            <td class="p-sm border-r border-border-light font-body-reg text-body-reg text-primary font-medium">L. James</td>
            <td class="p-sm border-r border-border-light font-data-mono text-data-mono text-primary text-right">LAL</td>
            <td class="p-sm border-r border-border-light font-data-mono text-data-mono text-on-surface-variant text-right">36.5</td>
            <td class="p-sm border-r border-border-light font-data-mono text-data-mono text-primary text-right">28</td>
            <td class="p-sm border-r border-border-light font-data-mono text-data-mono text-primary text-right">10</td>
            <td class="p-sm border-r border-border-light font-data-mono text-data-mono text-primary text-right">8</td>
            <td class="p-sm font-data-mono text-data-mono text-status-positive font-bold text-right bg-secondary-fixed/10">+18.4</td>
          </tr>
          <tr class="border-b border-border-light bg-surface-container-low hover:bg-ghost-gray transition-colors">
            <td class="p-sm border-r border-border-light font-body-reg text-body-reg text-primary font-medium">N. Jokic</td>
            <td class="p-sm border-r border-border-light font-data-mono text-data-mono text-primary text-right">DEN</td>
            <td class="p-sm border-r border-border-light font-data-mono text-data-mono text-on-surface-variant text-right">34.2</td>
            <td class="p-sm border-r border-border-light font-data-mono text-data-mono text-primary text-right">24</td>
            <td class="p-sm border-r border-border-light font-data-mono text-data-mono text-primary text-right">14</td>
            <td class="p-sm border-r border-border-light font-data-mono text-data-mono text-primary text-right">12</td>
            <td class="p-sm font-data-mono text-data-mono text-status-positive font-bold text-right bg-secondary-fixed/10">+15.2</td>
          </tr>
          <tr class="border-b border-border-light hover:bg-ghost-gray transition-colors">
            <td class="p-sm border-r border-border-light font-body-reg text-body-reg text-primary font-medium">S. Curry</td>
            <td class="p-sm border-r border-border-light font-data-mono text-data-mono text-primary text-right">GSW</td>
            <td class="p-sm border-r border-border-light font-data-mono text-data-mono text-on-surface-variant text-right">38.0</td>
            <td class="p-sm border-r border-border-light font-data-mono text-data-mono text-primary text-right">32</td>
            <td class="p-sm border-r border-border-light font-data-mono text-data-mono text-primary text-right">4</td>
            <td class="p-sm border-r border-border-light font-data-mono text-data-mono text-primary text-right">6</td>
            <td class="p-sm font-data-mono text-data-mono text-status-positive font-bold text-right bg-secondary-fixed/10">+12.1</td>
          </tr>
          <tr class="border-b border-border-light bg-surface-container-low hover:bg-ghost-gray transition-colors">
            <td class="p-sm border-r border-border-light font-body-reg text-body-reg text-primary font-medium">J. Tatum</td>
            <td class="p-sm border-r border-border-light font-data-mono text-data-mono text-primary text-right">BOS</td>
            <td class="p-sm border-r border-border-light font-data-mono text-data-mono text-on-surface-variant text-right">39.1</td>
            <td class="p-sm border-r border-border-light font-data-mono text-data-mono text-primary text-right">22</td>
            <td class="p-sm border-r border-border-light font-data-mono text-data-mono text-primary text-right">8</td>
            <td class="p-sm border-r border-border-light font-data-mono text-data-mono text-primary text-right">4</td>
            <td class="p-sm font-data-mono text-data-mono text-status-negative font-bold text-right bg-secondary-fixed/10">-4.5</td>
          </tr>
        </tbody>
      </table>
    </div>
  </section>
</template>
