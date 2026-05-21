import { GameModel, RankedPlayerModel, PlayerOfTheDayModel, TournamentModel, LeagueModel } from './models'

const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms))

export const mockApi = {
  /**
   * Получить список лиг
   */
  async getLeagues() {
    await sleep(500)
    const rawData = [
      { id: 1, name: 'NBA', alias: 'NBA', order: 1, tier: 1, tournaments_count: 1, top_player: 'N. JOKIC', games_count: 450 },
      { id: 2, name: 'EUROLEAGUE', alias: 'EUROLEAGUE', order: 2, tier: 1, tournaments_count: 1, top_player: 'M. JAMES', games_count: 180 },
      { id: 3, name: 'ACB', alias: 'ACB', order: 3, tier: 2, tournaments_count: 2, top_player: 'F. CAMPAZZO', games_count: 212 },
      { id: 4, name: 'LNB', alias: 'LNB', order: 4, tier: 2, tournaments_count: 1, top_player: 'T. SHORTS', games_count: 165 },
      { id: 5, name: 'CBA', alias: 'CBA', order: 5, tier: 3, tournaments_count: 1, top_player: 'Y. JIANLIAN', games_count: 320 },
      { id: 6, name: 'NCAA', alias: 'NCAA', order: 6, tier: 1, tournaments_count: 8, top_player: 'Z. EDEY', games_count: 840 }
    ]
    return {
      data: rawData.map(l => new LeagueModel(l))
    }
  },

  /**
   * Получить общую статистику (Dashboard)
   */
  async getSummaryStats() {
    await sleep(300)
    return {
      totalDataPoints: '1.2M+',
      activeLeagues: '42',
      trackedPlayers: '8,500',
      totalMatches: '24,812'
    }
  },

  /**
   * Получить сводную статистику по лигам (Leagues View)
   */
  async getLeagueSummaryStats() {
    await sleep(300)
    return this.getLeagues()
  },

  /**
   * Получить список турниров
   */
  async getTournaments() {
    await sleep(400)
    const rawData = [
      { id: 1, league_id: 1, name: 'NBA Playoffs', start_at: '2026-04-15', end_at: '2026-06-20', tier: 1, teams_count: 16, best_player_full_name: 'Nikola Jokić', games_count: 84, next_update_at: '2026-05-03T10:00:00Z' },
      { id: 2, league_id: 2, name: 'EuroLeague Regular Season', start_at: '2025-10-01', end_at: '2026-04-10', tier: 1, teams_count: 18, best_player_full_name: 'Mike James', games_count: 306, next_update_at: '2026-05-04T12:00:00Z' },
      { id: 3, league_id: 3, name: 'ACB Liga Endesa', start_at: '2025-09-28', end_at: '2026-05-15', tier: 2, teams_count: 18, best_player_full_name: 'Facu Campazzo', games_count: 153, next_update_at: '2026-05-03T18:00:00Z' },
      { id: 4, league_id: 4, name: 'LNB Pro A', start_at: '2025-09-15', end_at: '2026-05-20', tier: 2, teams_count: 18, best_player_full_name: 'Nadair Hifi', games_count: 144, next_update_at: '2026-05-05T09:00:00Z' },
      { id: 5, league_id: 5, name: 'CBA Playoffs', start_at: '2026-03-10', end_at: '2026-04-20', tier: 2, teams_count: 12, best_player_full_name: 'Zhou Qi', games_count: 38, next_update_at: '2026-05-02T22:00:00Z' },
      { id: 6, league_id: 6, name: 'NCAA March Madness', start_at: '2026-03-15', end_at: '2026-04-05', tier: 1, teams_count: 68, best_player_full_name: 'Zach Edey', games_count: 67, next_update_at: '2026-05-10T10:00:00Z' }
    ]
    return {
      data: rawData.map(t => new TournamentModel(t))
    }
  },

  /**
   * Получить сводную статистику по турнирам
   */
  async getTournamentSummaryStats() {
    await sleep(300)
    return this.getTournaments()
  },

  /**
   * Получить еженедельных лидеров
   */
  async getWeeklyLeaders(tournamentId) {
    await sleep(400)
    return [
      { category: 'points', player: 'L. DONCIC', value: '38.4 PPG' },
      { category: 'assists', player: 'T. YOUNG', value: '12.1 APG' },
      { category: 'rebounds', player: 'N. JOKIC', value: '13.8 RPG' },
      { category: 'imp', player: 'L. DONCIC', value: '+18.4 IMP' }
    ]
  },

  /**
   * Получить игры турнира
   */
  async getTournamentGames(params) {
    await sleep(600)
    const tournamentId = params?.tournament_id || 1
    
    const rawData = [
      {
        id: 1775,
        scheduled_at: "2026-04-27T01:30:00.000000Z",
        tournament_id: tournamentId,
        title: "HOU - LAL",
        duration: 48,
        game_team_stats: [
          {
            id: 3511,
            game_id: 1775,
            team_id: 39,
            score: 96,
            final_differential: -19,
            team: { id: 39, name: "Lakers", alias: "LAL", home_town: "Los Angeles" },
            playerStats: []
          },
          {
            id: 3510,
            game_id: 1775,
            team_id: 38,
            score: 115,
            final_differential: 19,
            team: { id: 38, name: "Rockets", alias: "HOU", home_town: "Houston" },
            playerStats: []
          }
        ]
      }
    ]

    return {
      data: rawData.map(g => new GameModel(g)),
      meta: { current_page: 1, total: 1 },
      links: {}
    }
  },

  /**
   * Получить лидерборд
   */
  async getLeaderboard(params) {
    await sleep(100)
    
    const { use_reliability } = params || {}

    let rawData = [
      {
        position: 1,
        player: { id: 101, full_name: "Nikola Jokic" },
        team_alias: "DEN",
        games_count: 72,
        avg_imp: use_reliability ? 18.5 : 19.2,
        avg_minutes: 34.2
      },
      {
        position: 2,
        player: { id: 102, full_name: "Shai Gilgeous-Alexander" },
        team_alias: "OKC",
        games_count: 75,
        avg_imp: use_reliability ? 16.2 : 16.8,
        avg_minutes: 36.1
      }
    ]

    return {
      data: rawData.map(p => new RankedPlayerModel(p))
    }
  },

  /**
   * Получить игроков дня
   */
  async getPlayersOfTheDay(tournamentId, params) {
    await sleep(500)
    
    const useReliability = params?.use_reliability
    const multiplier = useReliability ? 0.95 : 1.05
    
    const rawData = [
      { id: 201, full_name: "LeBron James", team_alias: "LAL", played_minutes: 36.5, pts: 28, reb: 10, ast: 8, imp: Number((18.4 * multiplier).toFixed(1)) },
      { id: 202, full_name: "Nikola Jokic", team_alias: "DEN", played_minutes: 34.2, pts: 24, reb: 14, ast: 12, imp: Number((15.2 * multiplier).toFixed(1)) }
    ]

    return {
      data: rawData.map(p => new PlayerOfTheDayModel(p))
    }
  },

  /**
   * Получить инсайты дня
   */
  async getDailyInsight(tournamentId) {
    await sleep(400)
    return {
      data: ["NBA: LAL exhibited a +8.2 IMP rating advantage in the 3rd quarter."]
    }
  },

  /**
   * Получить детальную статистику матча
   */
  async getMatchDetails(matchId) {
    await sleep(700)
    
    const rawGame = {
      id: Number(matchId),
      scheduled_at: "2026-04-27T01:30:00Z",
      tournament_id: 1,
      title: "HOU - LAL",
      duration: 48,
      game_team_stats: [
        {
          id: 1,
          team_id: 39,
          score: 96,
          final_differential: -19,
          team: { id: 39, name: "Lakers", alias: "LAL", home_town: "Los Angeles" },
          playerStats: [
            { player: { full_name: 'Anthony Davis' }, played_seconds: 2330, plus_minus: -12, points: 24, rebounds: 12, assists: 3, field_goals_percentage: '50.2', turnovers: 3, blocks: 2, steals: 1, imp: 80.2 }
          ]
        },
        {
          id: 2,
          team_id: 38,
          score: 115,
          final_differential: 19,
          team: { id: 38, name: "Rockets", alias: "HOU", home_town: "Houston" },
          playerStats: [
            { player: { full_name: 'Alperen Sengun' }, played_seconds: 2052, plus_minus: 21, points: 28, rebounds: 14, assists: 5, field_goals_percentage: '61.4', turnovers: 2, blocks: 3, steals: 1, imp: 92.4 }
          ]
        }
      ]
    }

    return new GameModel(rawGame)
  },

  /**
   * Получить ключевые показатели матча
   */
  async getKeyPerformances(matchId) {
    await sleep(400)
    return {
      data: [
        { player_name: 'Alperen Sengun', imp: 92.4, narratives: 'Sengun commanded the paint with 28 points and 14 rebounds.' }
      ]
    }
  },

  /**
   * Рассчитать необработанный IMP
   */
  async calculateRawImp(payload) {
    await sleep(300)
    const base = (payload.plus_minus / payload.played_seconds) * payload.duration * 100
    return {
      data: base.toFixed(1)
    }
  }
}
