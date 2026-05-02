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
      { id: 1, league_id: 1, name: 'NBA Playoffs', start_at: '2026-04-15', end_at: '2026-06-20', tier: 1, teams_count: 16, top_player: 'Nikola Jokić', matches_count: 84, next_update_at: '2026-05-03T10:00:00Z' },
      { id: 2, league_id: 2, name: 'EuroLeague Regular Season', start_at: '2025-10-01', end_at: '2026-04-10', tier: 1, teams_count: 18, top_player: 'Mike James', matches_count: 306, next_update_at: '2026-05-04T12:00:00Z' },
      { id: 3, league_id: 3, name: 'ACB Liga Endesa', start_at: '2025-09-28', end_at: '2026-05-15', tier: 2, teams_count: 18, top_player: 'Facu Campazzo', matches_count: 153, next_update_at: '2026-05-03T18:00:00Z' },
      { id: 4, league_id: 4, name: 'LNB Pro A', start_at: '2025-09-15', end_at: '2026-05-20', tier: 2, teams_count: 18, top_player: 'Nadair Hifi', matches_count: 144, next_update_at: '2026-05-05T09:00:00Z' },
      { id: 5, league_id: 5, name: 'CBA Playoffs', start_at: '2026-03-10', end_at: '2026-04-20', tier: 2, teams_count: 12, top_player: 'Zhou Qi', matches_count: 38, next_update_at: '2026-05-02T22:00:00Z' },
      { id: 6, league_id: 6, name: 'NCAA March Madness', start_at: '2026-03-15', end_at: '2026-04-05', tier: 1, teams_count: 68, top_player: 'Zach Edey', matches_count: 67, next_update_at: '2026-05-10T10:00:00Z' }
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
  async getLeaderboard(params) {
    await sleep(100)
    
    // Simulate API filtering and ordering based on params
    const { 
      tournament_id, 
      per, 
      limit = 10, 
      order = 'desc', 
      min_games, 
      team_id, 
      min_minutes, 
      max_minutes, 
      use_reliability 
    } = params || {}

    // Initial mock dataset
    let rawData = [
      {
        position: 1,
        player: { id: 101, full_name: "Nikola Jokic", birth_date_at: "1995-02-19", team_alias: "DEN" },
        games_count: 72,
        avg_imp: use_reliability ? 18.5 : 19.2,
        avg_minutes: 34.2
      },
      {
        position: 2,
        player: { id: 102, full_name: "Shai Gilgeous-Alexander", birth_date_at: "1998-07-12", team_alias: "OKC" },
        games_count: 75,
        avg_imp: use_reliability ? 16.2 : 16.8,
        avg_minutes: 36.1
      },
      {
        position: 3,
        player: { id: 103, full_name: "Luka Doncic", birth_date_at: "1999-02-28", team_alias: "DAL" },
        games_count: 70,
        avg_imp: use_reliability ? 15.8 : 17.1,
        avg_minutes: 35.8
      },
      {
        position: 4,
        player: { id: 104, full_name: "Giannis Antetokounmpo", birth_date_at: "1994-12-06", team_alias: "MIL" },
        games_count: 73,
        avg_imp: use_reliability ? 14.9 : 15.5,
        avg_minutes: 33.9
      },
      {
        position: 5,
        player: { id: 105, full_name: "Jayson Tatum", birth_date_at: "1998-03-03", team_alias: "BOS" },
        games_count: 65,
        avg_imp: use_reliability ? 14.0 : 14.6,
        avg_minutes: 35.5
      },
      {
        position: 6,
        player: { id: 106, full_name: "Anthony Edwards", birth_date_at: "2001-08-05", team_alias: "MIN" },
        games_count: 78,
        avg_imp: use_reliability ? 13.5 : 13.9,
        avg_minutes: 32.4
      }
    ]

    // Sort order (imp vs worst)
    rawData.sort((a, b) => {
      return order === 'desc' ? b.avg_imp - a.avg_imp : a.avg_imp - b.avg_imp
    })

    // Re-assign positions after sort
    rawData.forEach((item, index) => {
      item.position = index + 1
    })

    // Apply limit
    rawData = rawData.slice(0, Number(limit))

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
  },

  /**
   * Получить детальную статистику матча
   */
  async getMatchDetails(matchId) {
    await sleep(700)
    
    const id = Number(matchId)
    if (!id || isNaN(id) || id > 3000) {
      return null
    }

    const matches = {
      1775: {
        id: 1775,
        title: "HOU - LAL",
        subtitle: "Regular Season",
        homeTeam: { name: "HOUSTON", alias: "HOU", score: 115, isWinner: true },
        awayTeam: { name: "LA LAKERS", alias: "LAL", score: 96, isWinner: false },
        homeStats: [
          { player: 'Alperen Sengun', min: '34:12', 'plusMinus': 21, pts: 28, reb: 14, ast: 5, fgPct: '61.4', to: 2, blk: 3, stl: 1, imp: 92.4 },
          { player: 'Jalen Green', min: '36:45', 'plusMinus': 15, pts: 22, reb: 4, ast: 9, fgPct: '48.2', to: 4, blk: 0, stl: 2, imp: 78.1 },
          { player: 'Fred VanVleet', min: '32:20', 'plusMinus': 10, pts: 18, reb: 3, ast: 8, fgPct: '42.0', to: 1, blk: 0, stl: 1, imp: 60.5 },
          { player: 'Dillon Brooks', min: '35:12', 'plusMinus': 12, pts: 15, reb: 5, ast: 4, fgPct: '45.7', to: 2, blk: 1, stl: 3, imp: 58.8 }
        ],
        awayStats: [
          { player: 'Anthony Davis', min: '38:50', 'plusMinus': -12, pts: 24, reb: 12, ast: 3, fgPct: '50.2', to: 3, blk: 2, stl: 1, imp: 80.2 },
          { player: 'LeBron James', min: '36:15', 'plusMinus': -18, pts: 20, reb: 6, ast: 8, fgPct: '44.8', to: 4, blk: 1, stl: 0, imp: 65.5 },
          { player: 'Austin Reaves', min: '30:00', 'plusMinus': -10, pts: 14, reb: 4, ast: 5, fgPct: '41.6', to: 2, blk: 0, stl: 1, imp: 48.2 },
          { player: 'D\'Angelo Russell', min: '26:40', 'plusMinus': -25, pts: 10, reb: 2, ast: 4, fgPct: '35.5', to: 3, blk: 0, stl: 0, imp: 30.7 }
        ]
      },
      1776: {
        id: 1776,
        title: "BOS - GSW",
        subtitle: "Regular Season • Rivalry Week",
        homeTeam: { name: "BOSTON", alias: "BOS", score: 98, isWinner: false },
        awayTeam: { name: "GOLDEN STATE", alias: "GSW", score: 104, isWinner: true },
        homeStats: [
          { player: 'Jayson Tatum', min: '40:12', 'plusMinus': -4, pts: 28, reb: 9, ast: 5, fgPct: '45.4', to: 3, blk: 1, stl: 1, imp: 85.4 },
          { player: 'Jaylen Brown', min: '38:45', 'plusMinus': -8, pts: 22, reb: 5, ast: 4, fgPct: '41.2', to: 2, blk: 0, stl: 2, imp: 70.1 },
          { player: 'Kristaps Porzingis', min: '32:20', 'plusMinus': -2, pts: 16, reb: 8, ast: 2, fgPct: '50.0', to: 1, blk: 3, stl: 0, imp: 62.5 },
          { player: 'Jrue Holiday', min: '34:12', 'plusMinus': -6, pts: 14, reb: 4, ast: 6, fgPct: '42.7', to: 2, blk: 1, stl: 1, imp: 55.8 }
        ],
        awayStats: [
          { player: 'Stephen Curry', min: '38:50', 'plusMinus': 8, pts: 32, reb: 5, ast: 7, fgPct: '48.2', to: 3, blk: 0, stl: 2, imp: 92.2 },
          { player: 'Klay Thompson', min: '35:15', 'plusMinus': 10, pts: 24, reb: 4, ast: 3, fgPct: '45.8', to: 2, blk: 1, stl: 1, imp: 75.5 },
          { player: 'Draymond Green', min: '30:00', 'plusMinus': 5, pts: 15, reb: 6, ast: 4, fgPct: '42.6', to: 1, blk: 1, stl: 1, imp: 55.2 },
          { player: 'Andrew Wiggins', min: '28:40', 'plusMinus': 12, pts: 12, reb: 5, ast: 2, fgPct: '40.5', to: 1, blk: 0, stl: 2, imp: 45.7 }
        ]
      },
      1777: {
        id: 1777,
        title: "GSW - BOS",
        subtitle: "Regular Season",
        homeTeam: { name: "GOLDEN STATE", alias: "GSW", score: 108, isWinner: false },
        awayTeam: { name: "BOSTON", alias: "BOS", score: 112, isWinner: true },
        homeStats: [
          { player: 'Stephen Curry', min: '39:50', 'plusMinus': -2, pts: 29, reb: 6, ast: 8, fgPct: '45.2', to: 4, blk: 0, stl: 1, imp: 88.2 },
          { player: 'Klay Thompson', min: '36:15', 'plusMinus': -5, pts: 21, reb: 3, ast: 2, fgPct: '42.8', to: 2, blk: 0, stl: 0, imp: 65.5 },
          { player: 'Jonathan Kuminga', min: '32:00', 'plusMinus': -8, pts: 16, reb: 7, ast: 3, fgPct: '48.6', to: 2, blk: 1, stl: 1, imp: 55.2 },
          { player: 'Draymond Green', min: '30:40', 'plusMinus': 2, pts: 10, reb: 8, ast: 9, fgPct: '50.5', to: 3, blk: 1, stl: 2, imp: 60.7 }
        ],
        awayStats: [
          { player: 'Jayson Tatum', min: '41:12', 'plusMinus': 6, pts: 31, reb: 11, ast: 6, fgPct: '48.4', to: 3, blk: 1, stl: 2, imp: 95.4 },
          { player: 'Jaylen Brown', min: '39:45', 'plusMinus': 8, pts: 26, reb: 6, ast: 3, fgPct: '46.2', to: 2, blk: 0, stl: 1, imp: 78.1 },
          { player: 'Derrick White', min: '35:20', 'plusMinus': 4, pts: 15, reb: 4, ast: 7, fgPct: '44.0', to: 1, blk: 1, stl: 2, imp: 62.5 },
          { player: 'Kristaps Porzingis', min: '30:12', 'plusMinus': 10, pts: 18, reb: 9, ast: 2, fgPct: '52.7', to: 1, blk: 2, stl: 0, imp: 68.8 }
        ]
      }
    }

    const defaultMatch = {
      id: id,
      title: "DEN - LAL",
      subtitle: "Playoff Series • Western Conference Finals • Game 5",
      homeTeam: { name: "DENVER", alias: "DEN", score: 114, isWinner: true },
      awayTeam: { name: "LA LAKERS", alias: "LAL", score: 102, isWinner: false },
      homeStats: [
        { player: 'Nikola Jokic', min: '41:12', 'plusMinus': 18, pts: 32, reb: 12, ast: 11, fgPct: '58.4', to: 2, blk: 1, stl: 3, imp: 98.4 },
        { player: 'Jamal Murray', min: '38:45', 'plusMinus': 12, pts: 26, reb: 4, ast: 7, fgPct: '45.2', to: 3, blk: 0, stl: 1, imp: 82.1 },
        { player: 'Michael Porter Jr.', min: '34:20', 'plusMinus': 5, pts: 19, reb: 8, ast: 2, fgPct: '52.0', to: 1, blk: 2, stl: 0, imp: 64.5 },
        { player: 'Aaron Gordon', min: '36:12', 'plusMinus': 9, pts: 14, reb: 7, ast: 3, fgPct: '66.7', to: 2, blk: 1, stl: 1, imp: 55.8 }
      ],
      awayStats: [
        { player: 'Anthony Davis', min: '42:50', 'plusMinus': -8, pts: 28, reb: 15, ast: 2, fgPct: '54.2', to: 4, blk: 4, stl: 1, imp: 88.2 },
        { player: 'LeBron James', min: '40:15', 'plusMinus': -14, pts: 24, reb: 8, ast: 10, fgPct: '41.8', to: 5, blk: 1, stl: 2, imp: 79.5 },
        { player: 'Austin Reaves', min: '32:00', 'plusMinus': -5, pts: 16, reb: 3, ast: 4, fgPct: '47.6', to: 2, blk: 0, stl: 2, imp: 51.2 },
        { player: 'D\'Angelo Russell', min: '28:40', 'plusMinus': -22, pts: 8, reb: 1, ast: 5, fgPct: '28.5', to: 2, blk: 0, stl: 0, imp: 24.7 }
      ]
    }

    return matches[id] || defaultMatch
  },

  /**
   * Получить ключевые показатели матча
   */
  async getKeyPerformances(matchId) {
    await sleep(400)
    const id = Number(matchId)
    
    const performances = {
      1775: [
        { player: 'Alperen Sengun', imp: '92.4 IMP', description: 'Sengun commanded the paint with 28 points and 14 rebounds.' },
        { player: 'Anthony Davis', imp: '80.2 IMP', description: 'AD was a force inside, despite the blowout loss.' }
      ],
      1776: [
        { player: 'Stephen Curry', imp: '92.2 IMP', description: 'Curry hit 6 threes in the second half to lead the comeback.' },
        { player: 'Jayson Tatum', imp: '85.4 IMP', description: 'Tatum played a solid game, creating opportunities for his team.' }
      ],
      1777: [
        { player: 'Jayson Tatum', imp: '95.4 IMP', description: 'Tatum scored 31 points to seal a tough road victory.' },
        { player: 'Stephen Curry', imp: '88.2 IMP', description: 'Curry kept his team in the game with incredible shot-making.' }
      ]
    }

    const defaultPerformances = [
      { 
        player: 'Nikola Jokic', 
        imp: '98.4 IMP', 
        description: 'Nikola Jokic dominated with a 98.4 IMP, utilizing tracking data to measure real-time influence on win probability.' 
      },
      { 
        player: 'Jamal Murray', 
        imp: '82.1 IMP', 
        description: 'Jamal Murray\'s 82.1 IMP in the 4th quarter was crucial for Denver\'s late offensive surge.' 
      },
      { 
        player: 'Anthony Davis', 
        imp: '88.2 IMP', 
        description: 'Anthony Davis recorded an 88.2 IMP, leading the defense with 4 blocks and commanding the paint.' 
      }
    ]

    return {
      data: performances[id] || defaultPerformances
    }
  },

  /**
   * Рассчитать необработанный IMP
   */
  async calculateRawImp(payload) {
    await sleep(300)
    // Эмуляция расчета
    const base = (payload.plus_minus / payload.played_seconds) * payload.duration * 100
    return {
      data: base.toFixed(1)
    }
  }
}
