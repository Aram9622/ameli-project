#!/bin/sh
set -eu

if [ ! -f .env ]; then
    cp .env.example .env
fi

touch database/database.sqlite
mkdir -p bootstrap/cache storage/framework/cache/data storage/framework/sessions storage/framework/views storage/logs
chmod -R ug+rw bootstrap/cache database storage

if ! grep -Eq '^APP_KEY=base64:.+' .env; then
    php artisan key:generate --force --no-interaction
fi

php artisan migrate --force --no-interaction

exec "$@"
