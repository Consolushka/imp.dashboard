<script setup>
const props = defineProps({
  columns: {
    type: Array,
    required: true
    // Array of { key: String, label: String, align: String ('left' | 'right') }
  },
  data: {
    type: Array,
    required: true
  },
  highlightedColumn: {
    type: String,
    default: ''
  },
  sortableColumns: {
    type: Array,
    default: () => []
  }
})

const emit = defineEmits(['sort'])

const isHighlighted = (columnKey) => columnKey === props.highlightedColumn
const isSortable = (columnKey) => props.sortableColumns.includes(columnKey)
</script>

<template>
  <div class="overflow-x-auto border-4 border-primary shadow-[8px_8px_0px_0px_rgba(0,0,0,1)]">
    <table class="w-full border-collapse">
      <thead class="bg-primary text-on-primary font-label-caps text-label-caps uppercase">
        <tr>
          <th
            v-for="col in columns"
            :key="col.key"
            class="p-md border-r-2 border-on-primary-container relative"
            :class="[
              col.align === 'right' ? 'text-right' : 'text-left',
              isHighlighted(col.key) ? 'bg-secondary-container text-white border-l-2 border-primary border-b-2 border-primary' : '',
              isSortable(col.key) ? 'cursor-pointer hover:bg-neutral-charcoal' : ''
            ]"
            @click="isSortable(col.key) && emit('sort', col.key)"
          >
            <div class="flex items-center gap-1" :class="col.align === 'right' ? 'justify-end' : 'justify-start'">
              {{ col.label }}
              <span
                v-if="isSortable(col.key)"
                class="material-symbols-outlined text-sm"
              >
                expand_more
              </span>
            </div>
          </th>
        </tr>
      </thead>
      <tbody class="font-data-mono text-data-mono bg-white">
        <tr
          v-for="(row, index) in data"
          :key="index"
          class="border-b-2 border-primary hover:bg-ghost-gray"
          :class="{ 'bg-surface-container-low': index % 2 !== 0 }"
        >
          <td
            v-for="col in columns"
            :key="col.key"
            class="p-md border-r-2 border-primary"
            :class="[
              col.align === 'right' ? 'text-right' : 'text-left',
              isHighlighted(col.key) ? 'bg-secondary-container text-white font-bold text-lg border-l-2 border-primary' : '',
              col.key === 'player' ? 'font-bold' : ''
            ]"
          >
            <slot :name="`cell-${col.key}`" :row="row" :value="row[col.key]">
              <span
                v-if="col.key === '+/-'"
                :class="row[col.key] > 0 ? 'text-status-positive' : row[col.key] < 0 ? 'text-status-negative' : ''"
              >
                {{ row[col.key] > 0 ? '+' + row[col.key] : row[col.key] }}
              </span>
              <span v-else>
                {{ row[col.key] }}
              </span>
            </slot>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>
