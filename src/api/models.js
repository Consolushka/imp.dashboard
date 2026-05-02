/**
 * Модель лиги
 */
export class LeagueModel {
  constructor(data) {
    this.id = data.id
    this.name = data.name
    this.alias = data.alias
    this.order = data.order
    
    // Дополнительные поля для UI (мокаем, так как в апи их нет)
    this.tier = data.tier || 1
    this.tournamentsCount = data.tournaments_count || 1
    this.topPlayer = data.top_player || 'N/A'
    this.matchesCount = data.matches_count || 0
  }
}

/**
 * Модель турнира
 */
export class TournamentModel {
  constructor(data) {
    this.id = data.id
    this.leagueId = data.league_id
    this.name = data.name
    this.startAt = data.start_at ? new Date(data.start_at) : null
    this.endAt = data.end_at ? new Date(data.end_at) : null
    
    // Дополнительные поля для UI
    this.tier = data.tier || 1
    this.teamsCount = data.teams_count || 0
    this.topPlayer = data.top_player || 'N/A'
    this.matchesCount = data.matches_count || 0
  }

  get status() {
    const now = new Date()
    if (this.endAt && now > this.endAt) return 'COMPLETED'
    if (this.startAt && now >= this.startAt) return 'ONGOING'
    return 'UPCOMING'
  }
}

/**
 * Модель команды
 */
export class TeamModel {
  constructor(data) {
    this.id = data.id
    this.name = data.name
    this.homeTown = data.home_town
    this.alias = data.alias || this.getAliasFromName(data.name)
  }

  getAliasFromName(name) {
    return name.substring(0, 3).toUpperCase()
  }
}

/**
 * Модель матча
 */
export class GameModel {
  constructor(data) {
    this.id = data.id
    this.scheduledAt = new Date(data.scheduled_at)
    this.tournamentId = data.tournament_id
    this.title = data.title
    this.duration = data.duration
    
    // Парсим статистику команд
    const stats = data.game_team_stats || []
    
    // Предполагаем, что в title формат "HOME - AWAY" или "AWAY @ HOME"
    // Но лучше ориентироваться на final_differential (у домашней команды он обычно положительный при победе)
    // В данном апи просто берем первую и вторую
    this.homeTeamStats = stats[1] ? new TeamStatsModel(stats[1]) : null
    this.awayTeamStats = stats[0] ? new TeamStatsModel(stats[0]) : null
  }
}

class TeamStatsModel {
  constructor(data) {
    this.id = data.id
    this.teamId = data.team_id
    this.score = data.score
    this.finalDifferential = data.final_differential
    this.team = data.team ? new TeamModel(data.team) : null
  }
}

/**
 * Модель игрока в лидерборде
 */
export class RankedPlayerModel {
  constructor(data) {
    this.position = data.position
    this.id = data.player.id
    this.fullName = data.player.full_name
    this.teamAlias = data.player.team_alias || 'UNK'
    this.gamesCount = data.games_count
    this.avgImp = data.avg_imp
    this.avgMinutes = data.avg_minutes || 0
  }
}

/**
 * Модель игрока дня
 */
export class PlayerOfTheDayModel {
  constructor(data) {
    this.id = data.id
    this.fullName = data.full_name
    this.teamAlias = data.team_alias
    this.min = data.min
    this.pts = data.pts
    this.reb = data.reb
    this.ast = data.ast
    this.imp = data.imp
  }
}
