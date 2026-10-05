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

## Оплата

Маркетинговая страница и интерфейс оформления подписки уже подготовлены. Перед
приёмом реальных платежей необходимо выбрать и подключить платёжного провайдера
(например, ЮKassa, CloudPayments или Stripe), настроить серверное создание платежа
и проверку webhook. Текущая форма не собирает и не сохраняет реквизиты карты.
