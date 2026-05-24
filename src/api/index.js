import client from './client'
import { 
  GameModel, 
  RankedPlayerModel, 
  PlayerOfTheDayModel, 
  TournamentModel, 
  LeagueModel 
} from './models'

export const api = {
  /**
   * Получить список лиг
   */
  async getLeagues() {
    const response = await client.get('/leagues')
    return {
      data: (response.data || []).map(l => new LeagueModel(l))
    }
  },

  /**
   * Получить общую статистику системы (Project-wide)
   */
  async getGlobalSummary() {
    const response = await client.get('/summary')
    return response.data || response
  },

  /**
   * Получить список лиг со статистикой (для Leagues View)
   */
  async getLeaguesSummary() {
    const response = await client.get('/leagues/summary')
    return {
      data: (response.data || []).map(l => new LeagueModel(l))
    }
  },

  /**
   * Получить список турниров
   */
  async getTournaments() {
    const response = await client.get('/tournaments')
    return {
      data: (response.data || []).map(t => new TournamentModel(t))
    }
  },

  /**
   * Получить список турниров со статистикой (для Tournaments View)
   */
  async getTournamentsSummary() {
    const response = await client.get('/tournaments/summary')
    return {
      data: (response.data || []).map(t => new TournamentModel(t))
    }
  },

  /**
   * Получить еженедельных лидеров
   */
  async getWeeklyLeaders(tournamentId) {
    if (!tournamentId) return []
    try {
      const response = await client.get(`/tournaments/${tournamentId}/weekly-leaders`)
      const rawData = response.data || []
      return rawData.map(item => ({
        category: item.category,
        player: item.player_full_name,
        value: item.value
      }))
    } catch (e) {
      console.error('Failed to fetch weekly leaders:', e)
      return []
    }
  },

  /**
   * Поиск игр по тексту
   */
  async searchGames(text, limit = 5) {
    if (!text || text.length < 2) return { data: [] }
    const response = await client.get('/games/search', { 
      params: { text, limit } 
    })
    return {
      data: (response.data || []).map(g => new GameModel(g))
    }
  },

  /**
   * Получить игры конкретного турнира (Recent Matches)
   */
  async getGamesByTournament(tournamentId, params) {
    const response = await client.get(`/tournaments/${tournamentId}/games`, { params })
    return {
      data: (response.data || []).map(g => new GameModel(g)),
      meta: response.meta,
      links: response.links
    }
  },

  /**
   * Получить все игры (с фильтрами)
   */
  async getTournamentGames(params) {
    const response = await client.get('/games', { params })
    return {
      data: (response.data || []).map(g => new GameModel(g)),
      meta: response.meta,
      links: response.links
    }
  },

  /**
   * Получить лидерборд
   */
  async getLeaderboard(params) {
    const response = await client.get('/leaderboard', { params })
    return {
      data: (response.data || []).map(p => new RankedPlayerModel(p))
    }
  },

  /**
   * Получить игроков дня
   */
  async getPlayersOfTheDay(tournamentId, params) {
    const response = await client.get(`/tournaments/${tournamentId}/players-of-the-day`, { params })
    return {
      data: (response.data || []).map(p => new PlayerOfTheDayModel(p))
    }
  },

  /**
   * Получить инсайты дня (Tournament level)
   */
  async getDailyInsight(tournamentId) {
    try {
      const response = await client.get(`/tournaments/${tournamentId}/insights`)
      return response
    } catch (e) {
      return { data: ["Statistical analysis for this tournament is being updated."] }
    }
  },

  /**
   * Получить инсайты дня (Key Performances - Match level)
   */
  async getKeyPerformances(matchId) {
    const response = await client.get(`/games/${matchId}/key-performances`)
    return {
      data: (response.data || []).map(p => ({
        player: p.player_full_name,
        imp: p.narrative?.value || 'N/A',
        description: p.narrative?.text || ''
      }))
    }
  },

  /**
   * Получить детальную статистику матча
   */
  async getMatchDetails(matchId, params) {
    const response = await client.get(`/games/${matchId}`, { params })
    return new GameModel(response.data)
  },

  /**
   * Рассчитать необработанный IMP
   */
  async calculateRawImp(payload) {
    const response = await client.post('/imp/calculate-raw', payload)
    return response.data
  }
}

export const mockApi = api
