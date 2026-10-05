FROM php:8.3-cli-bookworm AS php_base

RUN apt-get update \
    && apt-get install -y --no-install-recommends git libsqlite3-dev unzip \
    && docker-php-ext-install pdo_sqlite \
    && rm -rf /var/lib/apt/lists/*

COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

FROM php_base AS php_dependencies

WORKDIR /app

COPY . .

RUN composer install \
    --no-interaction \
    --no-progress \
    --prefer-dist \
    --optimize-autoloader

FROM node:22-alpine AS frontend

WORKDIR /app

COPY package.json ./
RUN npm install --no-audit --no-fund

COPY vite.config.js ./
COPY resources ./resources
COPY --from=php_dependencies /app/vendor ./vendor

RUN npm run build

FROM php_base AS application

WORKDIR /app

COPY . .
COPY --from=php_dependencies /app/vendor ./vendor
COPY --from=frontend /app/public/build ./public/build
COPY docker/entrypoint.sh /usr/local/bin/ameli-entrypoint

RUN chmod +x /usr/local/bin/ameli-entrypoint \
    && mkdir -p bootstrap/cache database storage/framework/cache/data storage/framework/sessions storage/framework/views storage/logs \
    && chown -R www-data:www-data bootstrap/cache database storage

EXPOSE 8000

ENTRYPOINT ["ameli-entrypoint"]
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
