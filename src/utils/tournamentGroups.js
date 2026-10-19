// Турнир завершён, если дата окончания уже прошла; пустая дата — турнир идёт (так же фильтрует API)
export function isFinished(tournament, now) {
  return tournament.endAt != null && tournament.endAt < now
}

export function groupTournaments(tournaments, now) {
  return {
    active: tournaments.filter(t => !isFinished(t, now)),
    finished: tournaments.filter(t => isFinished(t, now))
  }
}

// Турнир с лучшим тиром (наименьшее число); без тира — в конец
export function bestByTier(list) {
  return [...list].sort((a, b) => (a.tier || 99) - (b.tier || 99))[0]
}
