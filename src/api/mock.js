import { GameModel, RankedPlayerModel, PlayerOfTheDayModel, TournamentModel, LeagueModel } from './models'

const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms))

export const mockApi = {
  /**
   * Получить список лиг
   */
  async getLeagues() {
    await sleep(500)
    const rawData = [
      { id: 1, name: 'NBA', alias: 'NBA', order: 1, tier: 1, description: 'North American Pro League', tournaments_count: 1, top_player: 'N. JOKIC', matches_count: 450 },
      { id: 2, name: 'EUROLEAGUE', alias: 'EUROLEAGUE', order: 2, tier: 1, description: 'Top European Competition', tournaments_count: 1, top_player: 'M. JAMES', matches_count: 180 },
      { id: 3, name: 'ACB', alias: 'ACB', order: 3, tier: 2, description: 'Spanish National League', tournaments_count: 2, top_player: 'F. CAMPAZZO', matches_count: 212 },
      { id: 4, name: 'LNB', alias: 'LNB', order: 4, tier: 2, description: 'French Pro A League', tournaments_count: 1, top_player: 'T. SHORTS', matches_count: 165 },
      { id: 5, name: 'CBA', alias: 'CBA', order: 5, tier: 3, description: 'Chinese Basketball Assoc.', tournaments_count: 1, top_player: 'Y. JIANLIAN', matches_count: 320 },
      { id: 6, name: 'NCAA', alias: 'NCAA', order: 6, tier: 1, description: 'Collegiate Basketball', tournaments_count: 8, top_player: 'Z. EDEY', matches_count: 840 }
    ]
    return {
      data: rawData.map(l => new LeagueModel(l))
    }
  },

  /**
   * Получить статистику по лигам
   */
  async getLeagueSummaryStats() {
    await sleep(300)
    return {
      totalDataPoints: '1.2M+',
      activeLeagues: 42,
      trackedPlayers: '8,500',
      totalMatches: '24,812'
    }
  },

  /**
   * Получить список турниров
   */
  async getTournaments() {
    await sleep(400)
    const rawData = [
      { id: 1, league_id: 1, name: 'NBA Playoffs', start_at: '2026-04-15', end_at: '2026-06-20', tier: 1, status: 'ONGOING', teams_count: 16, top_performer: 'Nikola Jokić', matches_count: 84 },
      { id: 2, league_id: 2, name: 'EuroLeague Regular Season', start_at: '2025-10-01', end_at: '2026-04-10', tier: 1, status: 'ONGOING', teams_count: 18, top_performer: 'Mike James', matches_count: 306 },
      { id: 3, league_id: 3, name: 'ACB Liga Endesa', start_at: '2025-09-28', end_at: '2026-05-15', tier: 2, status: 'ONGOING', teams_count: 18, top_performer: 'Facu Campazzo', matches_count: 153 },
      { id: 4, league_id: 4, name: 'LNB Pro A', start_at: '2025-09-15', end_at: '2026-05-20', tier: 2, status: 'ONGOING', teams_count: 18, top_performer: 'Nadair Hifi', matches_count: 144 },
      { id: 5, league_id: 5, name: 'CBA Playoffs', start_at: '2026-03-10', end_at: '2026-04-20', tier: 2, status: 'COMPLETED', teams_count: 12, top_performer: 'Zhou Qi', matches_count: 38 },
      { id: 6, league_id: 6, name: 'NCAA March Madness', start_at: '2026-03-15', end_at: '2026-04-05', tier: 1, status: 'ARCHIVED', teams_count: 68, top_performer: 'Zach Edey', matches_count: 67 }
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
    return {
      totalDataPoints: '1.2M+',
      activeTournaments: 12,
      trackedPlayers: '8,500',
      totalMatches: '24,812'
    }
  },

  /**
   * Получить еженедельных лидеров
   */
  async getWeeklyLeaders() {
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
  async getTournamentGames(tournamentId) {
    await sleep(600)
    
    // Мокаем ответ LengthAwarePaginator
    const rawData = [
      {
        id: 1775,
        scheduled_at: "2026-04-27T01:30:00.000000Z",
        tournament_id: tournamentId || 1, // Если ID не передан, привязываем к 1
        title: "HOU - LAL",
        duration: 48,
        game_team_stats: [
          {
            id: 3511,
            game_id: 1775,
            team_id: 39,
            score: 96,
            final_differential: -19,
            team: { id: 39, name: "Lakers", home_town: "Los Angeles" }
          },
          {
            id: 3510,
            game_id: 1775,
            team_id: 38,
            score: 115,
            final_differential: 19,
            team: { id: 38, name: "Rockets", home_town: "Houston" }
          }
        ]
      },
      {
        id: 1776,
        scheduled_at: "2026-04-27T04:00:00.000000Z",
        tournament_id: tournamentId || 2, // Привязываем ко 2
        title: "BOS - GSW",
        duration: 48,
        game_team_stats: [
          {
            id: 3512,
            game_id: 1776,
            team_id: 40,
            score: 104,
            final_differential: 6,
            team: { id: 40, name: "Warriors", home_town: "Golden State" }
          },
          {
            id: 3513,
            game_id: 1776,
            team_id: 41,
            score: 98,
            final_differential: -6,
            team: { id: 41, name: "Celtics", home_town: "Boston" }
          }
        ]
      },
      {
        id: 1777,
        scheduled_at: "2026-04-26T20:00:00.000000Z",
        tournament_id: tournamentId || 1,
        title: "GSW - BOS",
        duration: 48,
        game_team_stats: [
          {
            id: 3514,
            game_id: 1777,
            team_id: 41,
            score: 112,
            final_differential: 4,
            team: { id: 41, name: "Celtics", home_town: "Boston" }
          },
          {
            id: 3515,
            game_id: 1777,
            team_id: 40,
            score: 108,
            final_differential: -4,
            team: { id: 40, name: "Warriors", home_town: "Golden State" }
          }
        ]
      }
    ]

    return {
      data: rawData.map(g => new GameModel(g)),
      total: 3,
      per_page: 15,
      current_page: 1
    }
  },

  /**
   * Получить лидерборд
   */
  async getLeaderboard(tournamentId, useReliability) {
    await sleep(800)
    
    const rawData = [
      {
        position: 1,
        player: { id: 101, full_name: "Nikola Jokic", birth_date_at: "1995-02-19", team_alias: "DEN" },
        games_count: 72,
        avg_imp: useReliability ? 18.5 : 19.2
      },
      {
        position: 2,
        player: { id: 102, full_name: "Shai Gilgeous-Alexander", birth_date_at: "1998-07-12", team_alias: "OKC" },
        games_count: 75,
        avg_imp: useReliability ? 16.2 : 16.8
      },
      {
        position: 3,
        player: { id: 103, full_name: "Luka Doncic", birth_date_at: "1999-02-28", team_alias: "DAL" },
        games_count: 70,
        avg_imp: useReliability ? 15.8 : 17.1
      },
      {
        position: 4,
        player: { id: 104, full_name: "Giannis Antetokounmpo", birth_date_at: "1994-12-06", team_alias: "MIL" },
        games_count: 73,
        avg_imp: useReliability ? 14.9 : 15.5
      }
    ]

    return {
      data: rawData.map(p => new RankedPlayerModel(p))
    }
  },

  /**
   * Получить игроков дня
   */
  async getPlayersOfTheDay(tournamentId, useReliability) {
    await sleep(500)
    
    const multiplier = useReliability ? 0.95 : 1.05
    
    const rawData = [
      { id: 201, full_name: "LeBron James", team_alias: "LAL", min: 36.5, pts: 28, reb: 10, ast: 8, imp: Number((18.4 * multiplier).toFixed(1)) },
      { id: 202, full_name: "Nikola Jokic", team_alias: "DEN", min: 34.2, pts: 24, reb: 14, ast: 12, imp: Number((15.2 * multiplier).toFixed(1)) },
      { id: 203, full_name: "Stephen Curry", team_alias: "GSW", min: 38.0, pts: 32, reb: 4, ast: 6, imp: Number((12.1 * multiplier).toFixed(1)) },
      { id: 204, full_name: "Jayson Tatum", team_alias: "BOS", min: 39.1, pts: 22, reb: 8, ast: 4, imp: Number((-4.5 * multiplier).toFixed(1)) }
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
    
    const insights = {
      1: [
        "NBA: LAL exhibited a +8.2 IMP rating advantage in the 3rd quarter, driven largely by transition efficiency.",
        "NBA: Nikola Jokic recorded a triple-double in his last 3 home games, maintaining a 15+ IMP average.",
        "NBA: GSW's bench outscored opponents by 12 points in the last game, showing improved depth."
      ],
      2: [
        "Euroleague: Real Madrid's bench productivity (+12.4 IMP) was the deciding factor against Monaco.",
        "Euroleague: Sasha Vezenkov is leading the league in offensive efficiency for the second month."
      ],
      3: [
        "ACB: Unicaja's defensive rating spiked in the final 5 minutes, securing a crucial road win.",
        "ACB: Barcelona's three-point shooting dropped to 25% in their recent away fixture."
      ],
      4: [
        "VTB: Zenit's ball movement led to a season-high 28 assists and a +15.1 IMP offensive efficiency.",
        "VTB: CSKA Moscow's defense allowed only 12 points in the first quarter of their last match."
      ],
      5: [
        "LNB: ASVEL dominated the paint with a +10 rebounding margin and +9.4 IMP from second-chance points.",
        "LNB: Victor Wembanyama's legacy continues to influence the league's defensive strategies."
      ]
    }

    return {
      data: insights[tournamentId] || ["Comprehensive statistical analysis of current fixtures shows stable trends."]
    }
  }
}
