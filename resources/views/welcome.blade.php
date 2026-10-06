<!DOCTYPE html>
<html lang="ru">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description"
        content="Ameli — спокойный помощник для родителей: сон, кормления, развитие и отчёты в одном месте.">
    <title>Ameli — забота становится проще</title>

    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="theme-color" content="#4f46e5">
    <link rel="manifest" href="/manifest.json">
    <link rel="apple-touch-icon" href="/images/icons/icon-192x192.png">
    @vite(['resources/css/app.css', 'resources/js/app.js'])
</head>

<body>
    <header class="site-header">
        <a class="brand" href="#top" aria-label="Ameli — на главную">
            <span class="brand__mark" aria-hidden="true"><i></i><i></i></span>
            <span>ameli</span>
        </a>
        <button class="menu-toggle" type="button" aria-expanded="false" aria-controls="main-navigation">
            <span></span><span></span>
            <span class="sr-only">Открыть меню</span>
        </button>
        <nav id="main-navigation" class="main-nav" aria-label="Основная навигация">
            <a href="#features">Возможности</a>
            <a href="#how">Как работает</a>
            <a href="#pricing">Тарифы</a>
            <a class="nav-cta" href="{{ route('checkout') }}">Попробовать</a>
        </nav>
    </header>

    <main id="top">
        <section class="hero section-shell">
            <div class="hero__copy">
                <div class="eyebrow"><span></span> Всё важное о малыше — рядом</div>
                <h1>Больше спокойствия.<br><em>Больше моментов вместе.</em></h1>
                <p class="hero__lead">Сон, кормления, подгузники и первые достижения — Ameli бережно собирает рутину
                    малыша и превращает её в понятные подсказки.</p>
                <div class="hero__actions">
                    <a class="button button--primary" href="{{ route('checkout') }}">Начать бесплатно <span>→</span></a>
                    <a class="button button--ghost" href="#features"><span class="play">▶</span> Посмотреть
                        возможности</a>
                </div>
                <div class="hero__trust">
                    <div class="avatars" aria-hidden="true"><b>А</b><b>М</b><b>К</b><b>+</b></div>
                    <p><strong>4,9 из 5</strong><br>выбирают заботливые родители</p>
                </div>
            </div>

            <div class="hero__visual" aria-label="Пример мобильного приложения Ameli">
                <div class="glow glow--one"></div>
                <div class="glow glow--two"></div>
                <div class="phone">
                    <div class="phone__speaker"></div>
                    <div class="app-head">
                        <div><small>Добрый вечер,</small><strong>Амина <span>👋</span></strong></div>
                        <button aria-label="Уведомления">♢<i></i></button>
                    </div>
                    <div class="baby-card">
                        <div><small>Следующий сон</small><strong>через 42 мин</strong><span>Лучшее время: 19:30</span>
                        </div>
                        <div class="baby-face" aria-hidden="true"><span>•‿•</span></div>
                    </div>
                    <div class="quick-title"><strong>Сегодня</strong><span>12 сентября</span></div>
                    <div class="track-card track-card--cyan"><i>☾</i>
                        <div><strong>Сон</strong><span>1 ч 24 мин</span></div><b>02:18:09</b>
                    </div>
                    <div class="track-card track-card--coral"><i>◉</i>
                        <div><strong>Кормление</strong><span>18 мин назад</span></div><b>Правая</b>
                    </div>
                    <div class="track-card track-card--yellow"><i>♧</i>
                        <div><strong>Подгузник</strong><span>1 ч 12 мин назад</span></div><b>+</b>
                    </div>
                    <div class="app-nav"><b
                            class="active">⌂<small>Главная</small></b><b>▥<small>Отчёты</small></b><b>✦<small>Советы</small></b><b>○<small>Профиль</small></b>
                    </div>
                </div>
                <div class="float-card float-card--sleep"><span>☾</span>
                    <div><small>Сон сегодня</small><strong>13 ч 40 мин</strong></div>
                </div>
                <div class="float-card float-card--growth"><span>↗</span>
                    <div><small>Рост</small><strong>Всё по плану</strong></div>
                </div>
            </div>
        </section>

        <section class="proof section-shell" aria-label="Преимущества">
            <p>Создано вместе с родителями и экспертами</p>
            <div><span>Без рекламы</span><span>Данные защищены</span><span>Просто начать</span><span>Поддержка
                    24/7</span></div>
        </section>

        <section id="features" class="features section-shell section-pad">
            <div class="section-heading">
                <div class="eyebrow"><span></span> Один помощник вместо заметок</div>
                <h2>Ритм малыша —<br><em>понятно и красиво</em></h2>
                <p>Никаких сложных таблиц. Только нужные функции, которые экономят время и помогают замечать
                    закономерности.</p>
            </div>
            <div class="feature-grid">
                <article class="feature-card feature-card--large feature-card--mint"><span class="feature-icon">☾</span>
                    <div><small>Умный трекер</small>
                        <h3>Сон без догадок</h3>
                        <p>Записывайте сон одним касанием и получайте подсказку о следующем комфортном времени отдыха.
                        </p>
                    </div>
                    <div class="mini-chart"><i></i><i></i><i></i><i></i><i></i><i></i><i></i></div>
                </article>
                <article class="feature-card feature-card--lavender"><span
                        class="feature-icon">◉</span><small>Кормление</small>
                    <h3>Всё под рукой</h3>
                    <p>Грудное, бутылочка или прикорм — история всегда рядом.</p>
                </article>
                <article class="feature-card feature-card--peach"><span class="feature-icon">↗</span><small>Рост и
                        развитие</small>
                    <h3>Каждая победа важна</h3>
                    <p>Сохраняйте вес, рост и памятные достижения малыша.</p>
                </article>
                <article class="feature-card feature-card--dark"><span class="feature-icon">▥</span>
                    <div><small>Отчёты</small>
                        <h3>Замечайте закономерности</h3>
                        <p>Наглядная картина дня, недели и месяца для вас и вашего педиатра.</p>
                    </div>
                    <div class="bars"><i></i><i></i><i></i><i></i><i></i><i></i><i></i></div>
                </article>
            </div>
        </section>

        <section id="how" class="how section-pad">
            <div class="section-shell how__inner">
                <div class="section-heading">
                    <div class="eyebrow"><span></span> Легко с первого дня</div>
                    <h2>Забота в три<br><em>простых шага</em></h2>
                </div>
                <ol class="steps">
                    <li><b>01</b>
                        <div>
                            <h3>Создайте профиль</h3>
                            <p>Добавьте дату рождения и особенности режима малыша.</p>
                        </div>
                    </li>
                    <li><b>02</b>
                        <div>
                            <h3>Отмечайте события</h3>
                            <p>Сон, питание и уход — быстро, даже одной рукой.</p>
                        </div>
                    </li>
                    <li><b>03</b>
                        <div>
                            <h3>Получайте подсказки</h3>
                            <p>Ameli покажет ритм дня и поможет спланировать следующий шаг.</p>
                        </div>
                    </li>
                </ol>
            </div>
        </section>

        <section id="pricing" class="pricing section-shell section-pad">
            <div class="section-heading section-heading--center">
                <div class="eyebrow"><span></span> Выберите свой ритм</div>
                <h2>Попробуйте бесплатно.<br><em>Оставайтесь с любовью.</em></h2>
                <p>7 дней полного доступа. Отменить подписку можно в любой момент.</p>
            </div>
            <div class="price-grid">
                <article class="price-card"><span class="plan-name">Месяц</span>
                    <div class="price"><strong>399 ₽</strong><span>/ месяц</span></div>
                    <p>Для знакомства со всеми возможностями.</p>
                    <ul>
                        <li>Все трекеры</li>
                        <li>Подробные отчёты</li>
                        <li>До 2 профилей</li>
                    </ul><a class="button button--outline" href="{{ route('checkout', ['plan' => 'month']) }}">Выбрать
                        месяц</a>
                </article>
                <article class="price-card price-card--popular">
                    <div class="popular-label">Выгодно</div><span class="plan-name">Год</span>
                    <div class="price"><strong>2 990 ₽</strong><span>/ год</span></div>
                    <p>249 ₽ в месяц — экономия 37%.</p>
                    <ul>
                        <li>Всё из тарифа «Месяц»</li>
                        <li>Семейный доступ</li>
                        <li>Приоритетная поддержка</li>
                    </ul><a class="button button--primary"
                        href="{{ route('checkout', ['plan' => 'year']) }}">Попробовать 7 дней</a>
                </article>
            </div>
            <p class="payment-note">Безопасная оплата · МИР, Visa, Mastercard · Отмена в один клик</p>
        </section>
        <section id="download" class="mx-auto w-full max-w-[1200px] px-5 py-16 md:py-24 download"
            aria-labelledby="download-title">
            <div
                class="relative grid items-center gap-8 overflow-hidden rounded-[2rem] bg-[#111c33] p-7 text-white sm:p-10 md:grid-cols-[1.4fr_1fr] lg:p-16">

                <!-- glow -->
                <div
                    class="pointer-events-none absolute -bottom-24 -right-24 size-88 rounded-full bg-[radial-gradient(circle,rgba(200,234,58,.25),transparent_70%)]">
                </div>

                <!-- visual (on mobile goes first) -->
                <div class="relative z-10 grid justify-items-start gap-3 md:order-2 md:justify-items-center"
                    aria-hidden="true">
                    <div
                        class="grid aspect-square w-28 -rotate-6 place-items-center rounded-[28%] bg-[#f9f6ef] shadow-[0_1.5rem_3rem_rgba(0,0,0,.35)] sm:w-36 lg:w-40">
                        <span class="brand__mark"><i></i><i></i></span>
                    </div>
                    <small class="font-bold tracking-wider opacity-80">ameli</small>
                </div>

                <!-- copy -->
                <div class="relative z-10 md:order-1">
                    <div class="eyebrow"><span></span> Всегда под рукой</div>

                    <h2 id="download-title" class="mt-3 text-white">
                        Установите Ameli<br><em>на свой телефон</em>
                    </h2>

                    <p class="mt-4 max-w-xl opacity-80">
                        Открывается как обычное приложение: на главном экране, без адресной строки и даже без интернета.
                    </p>

                    <ul class="mb-7 mt-5 grid gap-2">
                        <li class="flex items-center gap-3"><span class="font-bold text-[#c8ea3a]">✓</span> Быстрый
                            запуск одним касанием</li>
                        <li class="flex items-center gap-3"><span class="font-bold text-[#c8ea3a]">✓</span> Работает на
                            весь экран</li>
                        <li class="flex items-center gap-3"><span class="font-bold text-[#c8ea3a]">✓</span> Не занимает
                            место, как обычные приложения</li>
                    </ul>

                    <div class="flex flex-wrap items-center gap-4">
                        <button type="button" data-install
                            class="button button--primary inline-flex cursor-pointer items-center gap-3 whitespace-nowrap">
                            <span
                                class="group grid size-8 flex-none place-items-center rounded-full bg-[#111c33] text-[#c8ea3a]"
                                aria-hidden="true">
                                <svg viewBox="0 0 24 24" class="block size-4" fill="none" stroke="currentColor"
                                    stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M12 4v11m0 0l-4.5-4.5M12 15l4.5-4.5M5 20h14" />
                                </svg>
                            </span>
                            <span>Установить приложение</span>
                        </button>

                        <p id="installStatus" role="status" class="m-0 hidden font-semibold text-[#c8ea3a]">
                            Приложение уже установлено на этом устройстве ✓
                        </p>
                    </div>

                    <div id="installManual" class="mt-5 hidden max-w-[30rem] rounded-2xl bg-white/10 px-5 py-4">
                        <strong>Как установить вручную</strong>
                        <ol class="mt-2 list-decimal space-y-1 pl-5 opacity-90">
                            <li data-ios class="hidden">Нажмите «Поделиться» <span aria-hidden="true">⬆</span> в Safari
                            </li>
                            <li data-ios class="hidden">Выберите «На экран Домой»</li>
                            <li data-other class="hidden">Откройте меню браузера (⋮)</li>
                            <li data-other class="hidden">Выберите «Установить приложение» или «Добавить на главный
                                экран»</li>
                        </ol>
                    </div>
                </div>
            </div>
        </section>
    </main>
    <footer class="footer section-shell"><a class="brand" href="#top"><span
                class="brand__mark"><i></i><i></i></span><span>ameli</span></a>
        <p>Создано с заботой о родителях.</p>
        <div><a href="#">Конфиденциальность</a><a href="#">Условия</a><span>© {{ date('Y') }} Ameli</span></div>
    </footer>
    <script>
        let deferredPrompt = null;

        const buttons = document.querySelectorAll('[data-install]');
        const status = document.getElementById('installStatus');
        const manual = document.getElementById('installManual');

        const show = (el, visible) => el && el.classList.toggle('hidden', !visible);

        const isInstalled = () =>
            window.matchMedia('(display-mode: standalone)').matches ||
            window.navigator.standalone === true;

        const isIos = /iphone|ipad|ipod/i.test(navigator.userAgent);

        function showManual() {
            show(manual, true);
            manual.querySelectorAll('[data-ios]').forEach((el) => show(el, isIos));
            manual.querySelectorAll('[data-other]').forEach((el) => show(el, !isIos));
        }

        function markInstalled() {
            buttons.forEach((b) => show(b, false));
            show(manual, false);
            show(status, true);
        }

        if (isInstalled()) markInstalled();

        window.addEventListener('beforeinstallprompt', (e) => {
            e.preventDefault();
            deferredPrompt = e;
        });

        buttons.forEach((btn) =>
            btn.addEventListener('click', async () => {
                if (deferredPrompt) {
                    deferredPrompt.prompt();
                    const { outcome } = await deferredPrompt.userChoice;
                    deferredPrompt = null;
                    if (outcome === 'accepted') markInstalled();
                } else {
                    showManual();
                }
            })
        );

        window.addEventListener('appinstalled', () => {
            deferredPrompt = null;
            markInstalled();
        });
    </script>
</body>

</html>