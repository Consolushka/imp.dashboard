import { test } from 'node:test'
import assert from 'node:assert/strict'
import { pickDashboardTournament } from './dashboardTournament.js'

const now = new Date('2026-10-19T12:00:00Z')
const past = new Date('2026-10-01T00:00:00Z')
const longAgo = new Date('2026-05-01T00:00:00Z')
const future = new Date('2026-11-01T00:00:00Z')

const activeTier1 = { id: 1, tier: 1, endAt: future }
const activeTier2 = { id: 2, tier: 2, endAt: null }
const finishedLast = { id: 3, tier: 1, endAt: past }
const finishedOld = { id: 4, tier: 1, endAt: longAgo }

test('выбранный активный турнир остаётся', () => {
  const pick = pickDashboardTournament([activeTier1, activeTier2, finishedLast], 2, now)
  assert.equal(pick.tournament, activeTier2)
  assert.deepEqual(pick.options, [activeTier1, activeTier2])
  assert.equal(pick.seasonFinished, false)
})

test('выбранный завершённый — показываем лучший активный по уровню, вход не меняется', () => {
  const list = [activeTier2, activeTier1, finishedLast]
  const snapshot = structuredClone(list)
  const pick = pickDashboardTournament(list, 3, now)
  assert.equal(pick.tournament, activeTier1)
  assert.deepEqual(pick.options, [activeTier2, activeTier1])
  assert.equal(pick.seasonFinished, false)
  assert.deepEqual(list, snapshot)
})

test('активных нет — последний завершённый по дате окончания', () => {
  const pick = pickDashboardTournament([finishedOld, finishedLast], 4, now)
  assert.equal(pick.tournament, finishedLast)
  assert.deepEqual(pick.options, [finishedLast])
  assert.equal(pick.seasonFinished, true)
})

test('пустой список — турнира нет', () => {
  assert.deepEqual(pickDashboardTournament([], 1, now), { tournament: null, options: [], seasonFinished: false })
})

test('турнир без тира идёт после турниров с тиром', () => {
  const noTier = { id: 5, endAt: null }
  const pick = pickDashboardTournament([noTier, activeTier2], null, now)
  assert.equal(pick.tournament, activeTier2)
})
