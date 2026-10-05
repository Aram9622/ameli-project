<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="Оформление подписки Ameli.">
    <title>Оформление подписки — Ameli</title>
    @vite(['resources/css/app.css', 'resources/js/app.js'])
</head>
<body class="checkout-page">
    <header class="checkout-header section-shell"><a class="brand" href="{{ route('home') }}"><span class="brand__mark"><i></i><i></i></span><span>ameli</span></a><span>Безопасное оформление <b>⌾</b></span></header>
    <main class="checkout-shell">
        <a class="back-link" href="{{ route('home') }}#pricing">← Назад к тарифам</a>
        <div class="checkout-grid">
            <section class="checkout-form">
                <div class="eyebrow"><span></span> Почти готово</div>
                <h1>Оформление подписки</h1>
                <p>Первое списание — после 7 бесплатных дней. Напомним заранее.</p>
                <form action="#" method="post" data-checkout-form>
                    @csrf
                    <fieldset>
                        <legend>1. Ваши данные</legend>
                        <label>Имя<input type="text" name="name" autocomplete="name" placeholder="Анна" required></label>
                        <label>Email<input type="email" name="email" autocomplete="email" placeholder="anna@example.ru" required></label>
                    </fieldset>
                    <fieldset>
                        <legend>2. Способ оплаты</legend>
                        <div class="payment-placeholder"><div><span>МИР</span><span>VISA</span><span>MC</span></div><p>Платёжная форма появится после подключения выбранного эквайринга.</p></div>
                    </fieldset>
                    <label class="agreement"><input type="checkbox" required><span>Я принимаю условия подписки и политику конфиденциальности</span></label>
                    <button class="button button--primary checkout-button" type="submit">Перейти к оплате <span>→</span></button>
                    <p class="form-message" role="status" hidden>Спасибо! Форма готова — осталось подключить платёжного провайдера.</p>
                </form>
            </section>
            <aside class="order-card">
                <span>Ваш заказ</span><h2>Ameli Premium</h2>
                <div class="plan-switch"><button type="button" data-plan="month">1 месяц</button><button type="button" data-plan="year" class="active">1 год <small>−37%</small></button></div>
                <div class="order-line"><span>Пробный период</span><strong>7 дней бесплатно</strong></div>
                <div class="order-line"><span>Затем</span><strong data-plan-price>2 990 ₽ / год</strong></div>
                <hr><div class="order-total"><span>К оплате сегодня</span><strong>0 ₽</strong></div>
                <ul><li>Все трекеры и отчёты</li><li>Семейный доступ</li><li>Отмена в любой момент</li></ul>
                <p>🔒 Данные передаются в зашифрованном виде.</p>
            </aside>
        </div>
    </main>
</body>
</html>
