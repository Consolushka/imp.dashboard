#!/bin/bash

# Создаем .env файл из переменных окружения
cat > /usr/share/nginx/html/.env << EOF
IMP_API_URL="${IMP_API_URL}"
IMP_CALCULATOR_URL="${IMP_CALCULATOR_URL}"
EOF

# Запускаем nginx
exec nginx -g "daemon off;"
