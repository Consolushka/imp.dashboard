# ... (начало как в предыдущем примере до WORKDIR)

WORKDIR /var/www/html

# Копируем entrypoint скрипт
COPY dockerfiles/dockhost/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Копируем composer файлы и устанавливаем зависимости
COPY composer.json composer.lock ./
RUN composer install --no-scripts --no-autoloader --optimize-autoloader --no-dev

# Копируем остальные файлы
COPY . .
RUN composer dump-autoload --optimize

# Устанавливаем права доступа
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage \
    && chmod -R 755 /var/www/html/bootstrap/cache

# Создаем директории
RUN mkdir -p storage/logs storage/framework/cache storage/framework/sessions storage/framework/views bootstrap/cache

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1

# Используем entrypoint скрипт
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]