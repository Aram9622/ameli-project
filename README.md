# Ameli

Чистый проект на Laravel 12.

## Запуск

```bash
cp .env.example .env
composer install
php artisan key:generate
php artisan migrate
npm install
npm run build
php artisan serve
```

Для локальной разработки по умолчанию используется SQLite. Создайте файл базы данных,
если Composer-скрипты не сделали это автоматически:

```bash
touch database/database.sqlite
```
