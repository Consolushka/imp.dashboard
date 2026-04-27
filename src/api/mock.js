import { GameModel, RankedPlayerModel, PlayerOfTheDayModel, TournamentModel } from './models'

const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms))

export const mockApi = {
  /**
   * Получить список турниров
   */
  async getTournaments() {
    await sleep(400)
    const rawData = [
      { id: 1, league_id: 1, name: 'NBA', start_at: '2025-10-20', end_at: '2026-06-20' },
      { id: 2, league_id: 2, name: 'Euroleague', start_at: '2025-10-01', end_at: '2026-05-25' },
      { id: 3, league_id: 3, name: 'ACB', start_at: '2025-09-28', end_at: '2026-06-15' },
      { id: 4, league_id: 4, name: 'VTB', start_at: '2025-10-05', end_at: '2026-06-01' },
      { id: 5, league_id: 5, name: 'LNB', start_at: '2025-09-15', end_at: '2026-05-30' }
    ]
    return {
      data: rawData.map(t => new TournamentModel(t))
    }
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
        tournament_id: tournamentId,
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
      }
    ]

    return {
      data: rawData.map(g => new GameModel(g)),
      total: 2,
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
