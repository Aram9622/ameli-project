<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Приложение — Ameli</title>
    @vite(['resources/css/app.css', 'resources/js/app.js'])
</head>
<body class="checkout-page">
    <header class="checkout-header section-shell">
        <a class="brand" href="{{ route('home') }}">ameli</a>
        <span>Режим разработки</span>
    </header>
    <main class="checkout-shell checkout-form">
        <div class="eyebrow"><span></span> Добро пожаловать</div>
        <h1>Ameli</h1>
        <p>Оплата пропущена для локальной разработки.</p>
        <p>Это стартовая страница приложения. Личный кабинет, авторизация и трекеры ещё в разработке.</p>
        <a class="button button--outline" href="{{ route('checkout') }}">Вернуться к подписке</a>
    </main>
</body>
</html>
