# Используем официальный PHP образ с Apache
FROM php:8.4-apache

# Устанавливаем системные зависимости
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libpq-dev \
    zip \
    unzip \
    && docker-php-ext-install pdo_pgsql pgsql mbstring exif pcntl bcmath gd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Устанавливаем Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Включаем Apache mod_rewrite
RUN a2enmod rewrite

# Настраиваем Apache
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Копируем конфигурацию Apache (если есть)
COPY dockerfiles/dockhost/apache/laravel.conf /etc/apache2/sites-available/000-default.conf

# Устанавливаем рабочую директорию
WORKDIR /var/www/html

# Копируем composer файлы первыми для кеширования слоев
COPY composer.json composer.lock ./

# Устанавливаем зависимости
RUN composer install --no-scripts --no-autoloader --optimize-autoloader --no-dev

# Копируем остальные файлы приложения
COPY . .

# Завершаем установку Composer
RUN composer dump-autoload --optimize

# Устанавливаем правильные права доступа
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage \
    && chmod -R 755 /var/www/html/bootstrap/cache

# Создаем необходимые директории
RUN mkdir -p storage/logs \
    && mkdir -p storage/framework/cache \
    && mkdir -p storage/framework/sessions \
    && mkdir -p storage/framework/views \
    && mkdir -p bootstrap/cache

# Генерируем ключ приложения и кешируем конфигурацию
RUN php artisan key:generate --force \
    && php artisan config:cache \
    && php artisan route:cache

# Открываем порт 80
EXPOSE 80

# Healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1

# Запускаем Apache
CMD ["apache2-foreground"]