/**
 * Модель лиги
 */
export class LeagueModel {
  constructor(data) {
    this.id = data.id
    this.name = data.name
    this.alias = data.alias
    this.order = data.order
    
    // Поля из Summary или дефолты
    this.tier = data.tier || 1
    this.tournamentsCount = parseInt(data.tournaments_count) || 0
    this.topPlayer = data.top_player || 'N/A'
    this.matchesCount = parseInt(data.games_count) || 0
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
    
    // Поля из Summary или дефолты
    this.tier = data.tier
    this.teamsCount = parseInt(data.teams_count) || 0
    this.topPlayer = data.best_player_full_name || 'N/A'
    this.matchesCount = parseInt(data.games_count) || 0
    this.nextUpdateAt = data.next_update_at ? new Date(data.next_update_at) : null
    this._status = data.status
  }

  get status() {
    // Если бэк прислал статус, используем его (приводим к верхнему регистру для UI)
    if (this._status) return this._status.toUpperCase()

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
    this.alias = data.alias
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
    this.subtitle = data.subtitle || 'Regular Season' // API might not have this yet
    this.duration = data.duration
    
    // Парсим статистику команд
    const stats = data.game_team_stats || []
    
    // Мапим статистику команд. 
    // В Laravel API обычно [0] - Away, [1] - Home
    this.awayTeamStats = stats[0] ? new TeamStatsModel(stats[0]) : null
    this.homeTeamStats = stats[1] ? new TeamStatsModel(stats[1]) : null
  }

  // Геттеры для совместимости с существующими View (MatchStatisticsView.vue)
  get homeTeam() {
    if (!this.homeTeamStats) return null
    return {
      name: this.homeTeamStats.team?.name || 'Home',
      alias: this.homeTeamStats.team?.alias || 'HOME',
      score: this.homeTeamStats.score,
      isWinner: this.homeTeamStats.finalDifferential > 0
    }
  }

  get awayTeam() {
    if (!this.awayTeamStats) return null
    return {
      name: this.awayTeamStats.team?.name || 'Away',
      alias: this.awayTeamStats.team?.alias || 'AWAY',
      score: this.awayTeamStats.score,
      isWinner: this.awayTeamStats.finalDifferential > 0
    }
  }

  get homeStats() {
    return this.homeTeamStats?.playerStats || []
  }

  get awayStats() {
    return this.awayTeamStats?.playerStats || []
  }
}

class TeamStatsModel {
  constructor(data) {
    this.id = data.id
    this.teamId = data.team_id
    this.score = data.score
    this.finalDifferential = data.final_differential
    this.team = data.team ? new TeamModel(data.team) : null
    
    // Статистика игроков в матче
    this.playerStats = (data.playerStats || []).map(ps => ({
      player: ps.player ? ps.player.full_name : 'Unknown',
      min: ps.played_seconds ? Math.floor(ps.played_seconds / 60) + ':' + String(ps.played_seconds % 60).padStart(2, '0') : '0:00',
      minRaw: ps.played_seconds || 0,
      plusMinus: ps.plus_minus,
      pts: ps.points,
      reb: ps.rebounds,
      ast: ps.assists,
      fgPct: ps.field_goals_percentage,
      to: ps.turnovers,
      blk: ps.blocks,
      stl: ps.steals,
      imp: typeof ps.imp === 'number' ? Number(ps.imp.toFixed(1)) : ps.imp
    }))
  }
}

/**
 * Модель игрока в лидерборде
 */
export class RankedPlayerModel {
  constructor(data) {
    this.position = data.position
    this.id = data.player?.id
    this.fullName = data.player?.full_name
    this.teamAlias = data.team_alias || 'UNK'
    this.gamesCount = data.games_count
    this.avgImp = typeof data.avg_imp === 'number' ? Number(data.avg_imp.toFixed(1)) : data.avg_imp
    this.avgMinutes = typeof data.avg_minutes === 'number' ? Number(data.avg_minutes.toFixed(1)) : data.avg_minutes
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
    this.min = typeof data.played_minutes === 'number' ? Number(data.played_minutes.toFixed(1)) : data.played_minutes
    this.pts = data.pts
    this.reb = data.reb
    this.ast = data.ast
    this.imp = typeof data.imp === 'number' ? Number(data.imp.toFixed(1)) : data.imp
  }
}
