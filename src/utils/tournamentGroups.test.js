import { test } from 'node:test'
import assert from 'node:assert/strict'
import { isFinished, groupTournaments } from './tournamentGroups.js'

const now = new Date('2026-10-19T12:00:00Z')
const past = new Date('2026-10-01T00:00:00Z')
const future = new Date('2026-11-01T00:00:00Z')

test('пустая дата окончания (null и undefined) — турнир активный', () => {
  assert.equal(isFinished({ endAt: null }, now), false)
  assert.equal(isFinished({ endAt: undefined }, now), false)
  assert.equal(isFinished({}, now), false)
})

test('дата окончания в прошлом — турнир завершён', () => {
  assert.equal(isFinished({ endAt: past }, now), true)
})

test('дата окончания в будущем — турнир активный', () => {
  assert.equal(isFinished({ endAt: future }, now), false)
})

test('пустой список — обе группы пустые', () => {
  assert.deepEqual(groupTournaments([], now), { active: [], finished: [] })
})

test('дата окончания ровно сейчас — турнир ещё активный', () => {
  assert.equal(isFinished({ endAt: new Date(now) }, now), false)
})

test('порядок внутри групп сохраняется', () => {
  const list = [
    { id: 1, endAt: past },
    { id: 2, endAt: null },
    { id: 3, endAt: past },
    { id: 4, endAt: future },
    { id: 5 }
  ]
  const { active, finished } = groupTournaments(list, now)
  assert.deepEqual(active.map(t => t.id), [2, 4, 5])
  assert.deepEqual(finished.map(t => t.id), [1, 3])
})
