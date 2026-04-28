<script setup>
import { ref, computed } from 'vue'

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

// Internal sorting state
const sortColumn = ref('')
const sortDirection = ref('desc') // 'asc' or 'desc'

const handleSort = (columnKey) => {
  if (sortColumn.value === columnKey) {
    sortDirection.value = sortDirection.value === 'asc' ? 'desc' : 'asc'
  } else {
    sortColumn.value = columnKey
    sortDirection.value = 'desc'
  }
  emit('sort', { column: sortColumn.value, direction: sortDirection.value })
}

const sortedData = computed(() => {
  if (!sortColumn.value) return props.data
  
  return [...props.data].sort((a, b) => {
    const valA = a[sortColumn.value]
    const valB = b[sortColumn.value]
    
    if (valA === valB) return 0
    
    const modifier = sortDirection.value === 'asc' ? 1 : -1
    
    if (typeof valA === 'number' && typeof valB === 'number') {
      return (valA - valB) * modifier
    }
    
    return String(valA).localeCompare(String(valB)) * modifier
  })
})

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
              isHighlighted(col.key) ? 'bg-secondary-container text-white z-10 shadow-[inset_2px_0_0_0_#000,inset_-2px_0_0_0_#000,inset_0_-2px_0_0_#000]' : '',
              isSortable(col.key) ? 'cursor-pointer hover:bg-neutral-charcoal' : ''
            ]"
            @click="isSortable(col.key) && handleSort(col.key)"
          >
            <div class="flex items-center gap-1" :class="col.align === 'right' ? 'justify-end' : 'justify-start'">
              {{ col.label }}
              <span
                v-if="isSortable(col.key)"
                class="material-symbols-outlined text-sm transition-transform"
                :class="{ 'rotate-180': sortColumn === col.key && sortDirection === 'asc' }"
              >
                expand_more
              </span>
            </div>
          </th>
        </tr>
      </thead>
      <tbody class="font-data-mono text-data-mono bg-white">
        <tr
          v-for="(row, index) in sortedData"
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
              isHighlighted(col.key) ? 'bg-secondary-container text-white font-bold text-lg shadow-[inset_2px_0_0_0_#000,inset_-2px_0_0_0_#000]' : ''
            ]"
          >
            <slot :name="`cell-${col.key}`" :row="row" :value="row[col.key]">
              {{ row[col.key] }}
            </slot>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>
