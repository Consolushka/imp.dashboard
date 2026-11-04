import { test } from 'node:test'
import assert from 'node:assert/strict'
import { formatBlockDate } from './blockDate.js'

test('западнее Гринвича показывается тот же день, что прислал API', () => {
  process.env.TZ = 'America/New_York'
  assert.equal(formatBlockDate('2026-10-18'), 'OCT 18, 2026')
})
