FROM node:20-alpine

WORKDIR /app

RUN apk add --no-cache bash

# Копируем только файлы зависимостей для кэширования слоев
COPY package*.json ./

# Устанавливаем зависимости
RUN npm install

# Открываем порт
EXPOSE 5173

CMD ["npm", "run", "dev", "--", "--host"]
