# Ameli

Чистый проект на Laravel 12.

## Запуск через Docker

Локально устанавливать PHP, Composer и Node.js не нужно. Достаточно Docker Desktop
или Docker Engine с плагином Compose:

```bash
docker compose up --build
```

После сборки приложение будет доступно по адресу <http://localhost:8000>.
Контейнер сам создаст `.env`, ключ приложения и SQLite-базу, а также выполнит
миграции. Для остановки используйте:

```bash
docker compose down
```

Полезные команды запускаются внутри контейнера:

```bash
docker compose exec app php artisan migrate
docker compose exec app php artisan test
docker compose exec app php artisan tinker
```

Чтобы полностью пересобрать зависимости и именованные тома:

```bash
docker compose down --volumes
docker compose up --build
```

## Запуск без Docker

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

## Оплата

Маркетинговая страница и интерфейс оформления подписки уже подготовлены. Перед
приёмом реальных платежей необходимо выбрать и подключить платёжного провайдера
(например, ЮKassa, CloudPayments или Stripe), настроить серверное создание платежа
и проверку webhook. Текущая форма не собирает и не сохраняет реквизиты карты.
