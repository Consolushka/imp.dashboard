import axios from 'axios'
import { ref } from 'vue'

// Окно лимита частоты в API (throttle:60,1 в routes/api.php). Повторяем его здесь, потому что
// заголовок Retry-After браузер от нас прячет: API не разрешает его читать с другого домена.
// Поменяли лимит в API — поменяй и здесь.
const RATE_LIMIT_WINDOW_SECONDS = 60

// Момент, до которого API отказывает из-за лимита частоты; null — лимит не превышен
export const rateLimitedUntil = ref(null)

const apiHost = import.meta.env.VITE_API_HOST || 'http://localhost'

/**
 * Создаем экземпляр axios для работы с Laravel API
 */
const client = axios.create({
  baseURL: `${apiHost}/api`,
  headers: {
    'Accept': 'application/json',
    'Content-Type': 'application/json'
  }
})

/**
 * Стандартный Laravel Resource возвращает данные в объекте { data: ... }
 * Добавляем перехватчик, чтобы упростить доступ к данным
 */
client.interceptors.response.use(
  (response) => {
    // Если в ответе есть ключ data, возвращаем его содержимое
    if (response.data && Object.prototype.hasOwnProperty.call(response.data, 'data')) {
      return response.data
    }
    return response
  },
  (error) => {
    // Глобальная обработка ошибок (можно добавить уведомления)
    console.error('API Error:', error.response?.data || error.message)
    if (error.response?.status === 429) {
      const seconds = Number(error.response.headers['retry-after']) || RATE_LIMIT_WINDOW_SECONDS
      rateLimitedUntil.value = Date.now() + seconds * 1000
    }
    return Promise.reject(error)
  }
)

export default client
