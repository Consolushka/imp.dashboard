import { groupTournaments, bestByTier } from './tournamentGroups.js'

// Какой турнир показать на Dashboard и из чего выбирать.
// Общий выбор в сторе не трогаем: завершённый турнир, выбранный на Leaderboard, должен там и остаться
export function pickDashboardTournament(tournaments, selectedId, now) {
  const { active, finished } = groupTournaments(tournaments, now)

  if (active.length) {
    const tournament = active.find(t => t.id === selectedId) ?? bestByTier(active)
    return { tournament, options: active, seasonFinished: false }
  }

  if (finished.length) {
    // Сезон закончился — показываем последний завершённый, чтобы Dashboard не был пустым
    const tournament = finished.reduce((last, t) => (t.endAt > last.endAt ? t : last))
    return { tournament, options: [tournament], seasonFinished: true }
  }

  return { tournament: null, options: [], seasonFinished: false }
}
