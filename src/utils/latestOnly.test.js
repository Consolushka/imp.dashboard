import { test } from 'node:test'
import assert from 'node:assert/strict'
import { latestOnly } from './latestOnly.js'

// Повторяет то, что делает блок: запрос стартует, ждёт ответа и пишет данные, только если он ещё последний
const load = async (begin, response, shown) => {
  const isLatest = begin()
  const value = await response
  if (isLatest()) shown.push(value)
}

const deferred = () => {
  let resolve
  const promise = new Promise(r => { resolve = r })
  return { promise, resolve }
}

test('поздний ответ старого турнира не заменяет ответ нового', async () => {
  const begin = latestOnly()
  const shown = []
  const oldTournament = deferred()
  const newTournament = deferred()

  const first = load(begin, oldTournament.promise, shown)
  const second = load(begin, newTournament.promise, shown)

  newTournament.resolve('B')
  await second
  oldTournament.resolve('A')
  await first

  assert.deepEqual(shown, ['B'])
})

test('единственный запрос считается последним', async () => {
  const begin = latestOnly()
  const shown = []
  await load(begin, Promise.resolve('A'), shown)
  assert.deepEqual(shown, ['A'])
})

test('у каждого блока свой счётчик', () => {
  const insights = latestOnly()
  const players = latestOnly()
  const isLatest = insights()
  players()
  assert.equal(isLatest(), true)
})
