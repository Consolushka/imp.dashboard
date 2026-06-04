import axios from 'axios'

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
    return Promise.reject(error)
  }
)

export default client
