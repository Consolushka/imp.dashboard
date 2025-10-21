#!/bin/bash

# Создаем .env файл из переменных окружения
cat > /var/www/html/.env << EOF
IMP_API_URL="${IMP_API_URL}"
IMP_CALCULATOR_URL="${IMP_CALCULATOR_URL}"
EOF

# Запускаем Apache
exec nginx -g daemon off
