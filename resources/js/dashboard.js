import '../css/dashboard.css';

const root = document.querySelector('#dashboard');
if (root) {
    const paths = {
        moon: '<path d="M20 15A9 9 0 0 1 9 4a9 9 0 1 0 11 11Z"/>',
        drop: '<path d="M12 2S4 11 4 15a8 8 0 0 0 16 0c0-4-8-13-8-13Z"/><path d="M9 18c-2-1-2-3-2-4"/>',
        bottle: '<path d="m14 3 7 7-3 3-7-7Z M10 7 3 14a3 3 0 0 0 0 4l3 3a3 3 0 0 0 4 0l7-7 M6 12l3 3 M9 9l3 3"/>',
        nappy: '<path d="M3 5h18v6c0 7-4 10-9 10S3 18 3 11Z M3 9h18 M3 12c5 0 6 3 6 8 M21 12c-5 0-6 3-6 8"/>',
        star: '<path d="m12 2 3 6 7 1-5 5 1 7-6-3-6 3 1-7-5-5 7-1Z"/>',
        growth: '<path d="M7 21V3m-3 3 3-3 3 3 M14 21h7 M14 16h4 M14 11h7 M14 6h4"/>',
        activity: '<path d="M4 14a8 8 0 1 1 16 0 M8 21h8 M9 17h6 M12 2V0 M3 4 1 2 M21 4l2-2"/>',
        plus: '<circle cx="12" cy="12" r="9"/><path d="M12 7v10 M7 12h10"/>',
        reports: '<path d="M3 21h19 M6 17V9 M11 17V3 M16 17V7 M21 17v-5"/>',
        plans: '<rect x="4" y="3" width="16" height="19" rx="2"/><path d="M8 7h8 M8 12h8 M8 17h4"/>',
        child: '<circle cx="12" cy="13" r="8"/><path d="M9 12h.1 M15 12h.1 M9 16q3 3 6 0 M10 5q7-7 5 2"/>',
        settings: '<path d="M3 6h18 M3 12h18 M3 18h18"/><circle cx="8" cy="6" r="2"/><circle cx="16" cy="12" r="2"/><circle cx="9" cy="18" r="2"/>',
        close: '<path d="m5 5 14 14 M19 5 5 19"/>',
        mail: '<rect x="2" y="4" width="20" height="16" rx="2"/><path d="m3 5 9 8 9-8"/>',
        medicine: '<path d="m8 4-4 4a5 5 0 0 0 0 7l5 5a5 5 0 0 0 7 0l4-4a5 5 0 0 0 0-7l-5-5a5 5 0 0 0-7 0Z M7 7l10 10"/>',
        temperature: '<path d="M10 14V4a2 2 0 0 1 4 0v10a5 5 0 1 1-4 0Z M12 8v10"/>',
    };
    const icon = (name) => `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">${paths[name] || paths.star}</svg>`;
    const types = [
        ['sleep', 'Сон', 'moon', '#2ecbdc'], ['nursing', 'Грудное кормление', 'drop', '#ff763f'],
        ['bottle', 'Бутылочка', 'bottle', '#f3388b'], ['solids', 'Прикорм', 'drop', '#f5ae42'],
        ['nappy', 'Подгузник', 'nappy', '#f7ce31'], ['potty', 'Горшок', 'nappy', '#e49a16'],
        ['pumping', 'Сцеживание', 'bottle', '#a186f8'], ['milestones', 'Достижения', 'star', '#84a4fb'],
        ['growth', 'Рост', 'growth', '#15d55b'], ['activity', 'Активность', 'activity', '#c8ce08'],
        ['medicine', 'Лекарство', 'medicine', '#f598b4'], ['temperature', 'Температура', 'temperature', '#f69a61'],
        ['contractions', 'Схватки', 'activity', '#c38af6'],
    ];
    const defaults = { profile: { name: 'Ameli', birthday: '', dayStart: '07:00' }, visible: ['sleep', 'nursing', 'nappy', 'pumping', 'milestones', 'growth', 'activity'], entries: [], filters: { days: 7, types: types.map(t => t[0]), dayStart: false, calendar: false }, timer: null };
    let state;
    try { state = { ...defaults, ...JSON.parse(localStorage.getItem('ameli.dashboard.v1') || '{}') }; } catch { state = structuredClone(defaults); }
    let page = 'home', reportTab = 'list', modal = null, draft = null, selectedEntry = null;
    const escape = value => String(value ?? '').replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
    const getType = id => types.find(t => t[0] === id) || types[0];
    const dateLabel = date => new Date(date).toLocaleDateString('ru', { day: 'numeric', month: 'long', year: 'numeric' });
    const timeLabel = date => new Date(date).toLocaleTimeString('ru', { hour: '2-digit', minute: '2-digit' });
    const localDate = (date = new Date()) => new Date(date.getTime() - date.getTimezoneOffset() * 60000).toISOString().slice(0, 16);
    const duration = seconds => [Math.floor(seconds / 3600), Math.floor(seconds / 60) % 60, Math.floor(seconds) % 60].map(v => String(v).padStart(2, '0')).join(':');
    function save() { try { localStorage.setItem('ameli.dashboard.v1', JSON.stringify(state)); return true; } catch { alert('Не удалось сохранить данные. Проверьте доступность хранилища браузера.'); return false; } }
    function elapsed(timer = state.timer) { return timer ? timer.seconds + (timer.running ? (Date.now() - timer.since) / 1000 : 0) : 0; }
    function sideElapsed(side) { const t = state.timer; return t ? t[side] + (t.running && t.side === side ? (Date.now() - t.since) / 1000 : 0) : 0; }
    function pauseTimer() { const t = state.timer; if (t?.running) { const delta = (Date.now() - t.since) / 1000; t.seconds += delta; if (t.side) t[t.side] += delta; t.running = false; } }
    const button = (action, label, cls = '') => `<button type="button" class="${cls}" data-action="${action}">${label}</button>`;
    const toggle = (id, checked, label) => `<label class="toggle-row"><span>${label}</span><input type="checkbox" name="${id}" ${checked ? 'checked' : ''}><span class="switch"></span></label>`;
    function header() { return `<header class="dash-header"><button class="child-chip" data-action="child"><span class="avatar">${escape(state.profile.name.slice(0, 1))}</span><strong>${escape(state.profile.name)}</strong></button><a href="#" class="berry-logo" aria-label="Главная" data-action="home"><i></i><b></b><em></em></a><div class="header-tools">${button('inbox', icon('mail'), 'icon-button')}${button('customize', icon('settings'), 'icon-button')}</div></header>`; }
    function nav() { return `<nav class="dash-nav" aria-label="Разделы приложения">${[['home', 'Главная', 'plus'], ['reports', 'Отчёты', 'reports'], ['plans', 'План сна', 'plans'], ['insights', 'Обзор', 'activity'], ['child', 'Ребёнок', 'child'], ['berry', 'Помощь', 'star']].map(([id, label, glyph]) => `<button data-action="${id}" ${page === id ? 'aria-current="page"' : ''}>${icon(glyph)}<span>${label}</span></button>`).join('')}</nav>`; }
    function lastEntry(id) { return [...state.entries].filter(e => e.type === id).sort((a, b) => b.start.localeCompare(a.start))[0]; }
    function home() {
        return `<section class="sweetspot"><div><span class="sweet-pill">Ритм малыша ${icon('moon')}</span><h1>Каждый момент<br>под заботой.</h1><p>Сон, кормление и маленькие открытия —<br>всё в одном месте.</p></div><div class="care-illustration" aria-hidden="true"><div class="hair-bun"></div><div class="hair"></div><div class="face"><span>◡</span></div><div class="glasses"><i></i><i></i></div><div class="shirt"></div></div></section><section class="tracker-grid" aria-label="Трекеры">${types.filter(t => state.visible.includes(t[0])).map(([id, label, glyph, color]) => { const last = lastEntry(id); return `<button class="tracker-card" style="--card:${color}" data-action="entry" data-type="${id}"><span class="tracker-art">${icon(glyph)}</span><div><h2>${label}</h2><p>${last ? `${dateLabel(last.start)} · ${timeLabel(last.start)}${last.detail ? ' · ' + escape(last.detail) : ''}` : 'Добавить первую запись'}</p></div>${state.timer?.type === id ? '<span class="timer-badge" data-timer-total></span>' : '<span class="card-plus">+</span>'}</button>`; }).join('')}</section>${button('customize', icon('settings') + ' Настроить трекеры', 'outline wide')}`;
    }
    function filtered() { const cutoff = new Date(); cutoff.setDate(cutoff.getDate() - state.filters.days); return state.entries.filter(e => new Date(e.start) >= cutoff && new Date(e.start) <= new Date() && state.filters.types.includes(e.type)).sort((a, b) => b.start.localeCompare(a.start)); }
    function entryRow(e) { const t = getType(e.type); return `<button class="entry-row" data-action="detail" data-id="${e.id}"><span style="color:${t[3]}">${icon(t[2])}</span><div><strong>${t[1]}${e.seconds ? ' · ' + duration(e.seconds) : ''}</strong><small>${timeLabel(e.start)}${e.detail ? ' · ' + escape(e.detail) : ''}${e.note ? ' · ' + escape(e.note) : ''}</small></div><span>›</span></button>`; }
    function reports() {
        const entries = filtered();
        const tabs = `<div class="report-toolbar"><div class="segments">${[['day', 'День'], ['week', 'Неделя'], ['list', 'Список'], ['summary', 'Итоги']].map(([id, label]) => `<button data-action="report-tab" data-tab="${id}" class="${reportTab === id ? 'active' : ''}">${label}</button>`).join('')}</div>${button('filters', icon('settings'), 'icon-button')}</div><p class="period-label">Последние ${state.filters.days} дней</p>`;
        if (!entries.length) return tabs + '<div class="empty-state">' + icon('reports') + '<h2>Пока нет записей</h2><p>Добавьте событие на главной или измените фильтры.</p>' + button('home', 'Добавить запись', 'primary') + '</div>';
        if (reportTab === 'summary') return tabs + `<div class="summary-grid">${types.filter(t => entries.some(e => e.type === t[0])).map(t => { const group = entries.filter(e => e.type === t[0]); return `<article class="summary-card"><span style="color:${t[3]}">${icon(t[2])}</span><h2>${t[1]}</h2><strong>${group.length}</strong><p>записей${group.some(e => e.seconds) ? ' · ' + duration(group.reduce((n, e) => n + (e.seconds || 0), 0)) : ''}</p></article>`; }).join('')}</div>`;
        const groups = new Map();
        entries.forEach(e => { const d = new Date(e.start); if (reportTab === 'day' && state.filters.dayStart) { const [h, m] = state.profile.dayStart.split(':').map(Number); d.setMinutes(d.getMinutes() - h * 60 - m); } const key = dateLabel(d); if (!groups.has(key)) groups.set(key, []); groups.get(key).push(e); });
        if (reportTab === 'week') return tabs + `<div class="week-chart">${Array.from({ length: state.filters.days }, (_, i) => { const date = new Date(); date.setDate(date.getDate() - state.filters.days + i + 1); const count = entries.filter(e => dateLabel(e.start) === dateLabel(date)).length; const max = Math.max(1, ...Array.from(groups.values()).map(g => g.length)); return `<div class="chart-column"><strong>${count}</strong><div style="height:${Math.max(3, count / max * 160)}px"></div><small>${date.getDate()}.${date.getMonth() + 1}</small></div>`; }).join('')}</div><p class="muted">Количество событий по дням</p>`;
        return tabs + [...groups].map(([date, items]) => `<section class="report-group"><h2>${date}</h2>${reportTab === 'day' ? '<div class="timeline">' + items.map(entryRow).join('') + '</div>' : items.map(entryRow).join('')}</section>`).join('');
    }
    function profile() { return `<section class="content-panel"><span class="avatar large">${escape(state.profile.name.slice(0, 1))}</span><h1>Профиль ребёнка</h1><form id="profile-form"><label>Имя<input name="name" value="${escape(state.profile.name)}" required maxlength="60"></label><label>Дата рождения<input type="date" name="birthday" value="${escape(state.profile.birthday)}" max="${localDate().slice(0, 10)}"></label><label>Начало дня<input type="time" name="dayStart" value="${escape(state.profile.dayStart)}" required></label><button class="primary wide">Сохранить профиль</button><p class="muted">В режиме разработки записи хранятся только в этом браузере. Синхронизация с аккаунтом будет подключена позже.</p></form><p id="profile-status" role="status"></p></section>`; }
    function otherPage() {
        const sleeping = state.entries.filter(e => e.type === 'sleep');
        if (page === 'insights') return `<section class="content-panel"><div class="eyebrow">Маленькие шаги, большая история</div><h1>Ваш день в цифрах</h1><div class="summary-grid"><article class="summary-card"><strong>${state.entries.length}</strong><p>всего событий</p></article><article class="summary-card"><strong>${duration(sleeping.reduce((n, e) => n + (e.seconds || 0), 0))}</strong><p>записанного сна</p></article></div><p class="muted">Этот обзор отражает только внесённые вами записи.</p>${button('reports', 'Открыть отчёты', 'outline')}</section>`;
        if (page === 'plans') return `<section class="content-panel"><span class="feature-icon">${icon('moon')}</span><h1>План сна</h1><p>Сохраняйте сон малыша, чтобы видеть привычный ритм в отчётах.</p><p class="muted">Персональные рекомендации по сну ещё не подключены.</p>${button('entry', 'Записать сон', 'primary').replace('data-action="entry"', 'data-action="entry" data-type="sleep"')}</section>`;
        return `<section class="content-panel"><span class="feature-icon">${icon('star')}</span><h1>Рядом каждый день</h1><p>Нажмите на карточку, чтобы добавить событие. Для сна и грудного кормления используйте таймер, а затем сохраните запись.</p><p>В «Настроить трекеры» можно выбрать карточки главной страницы. В отчётах — период и категории.</p>${button('home', 'На главную', 'primary')}</section>`;
    }
    function render() { root.innerHTML = `<div class="dash-shell">${header()}<main class="dash-main">${page === 'home' ? home() : page === 'reports' ? reports() : page === 'child' ? profile() : otherPage()}</main>${nav()}</div>${modal ? modalHTML() : ''}`; updateTimers(); if (modal) { root.querySelector('.dash-dialog')?.focus(); } }
    function openEntry(type) {
        if (state.timer && state.timer.type !== type && ['sleep', 'nursing'].includes(type)) { alert('Сначала сохраните или отмените текущий таймер.'); return; }
        modal = 'entry'; draft = { type, start: localDate(), detail: '', note: '', unit: 'ml', amount: 0 };
        if (state.timer?.type === type) draft.start = localDate(new Date(state.timer.start));
        render();
    }
    function entryForm() {
        const type = draft.type, timed = ['sleep', 'nursing'].includes(type);
        return `<form id="entry-form">${['nursing', 'bottle'].includes(type) ? `<div class="segments feeding-tabs"><button type="button" data-action="feeding-type" data-type="nursing" class="${type === 'nursing' ? 'active' : ''}">Грудное</button><button type="button" data-action="feeding-type" data-type="bottle" class="${type === 'bottle' ? 'active' : ''}">Бутылочка</button></div>` : ''}<label class="inline-field">Начало<input type="datetime-local" name="start" value="${draft.start}" max="${localDate()}" required ${state.timer ? 'readonly' : ''}></label>${timed ? `<div class="timer-display" data-timer-total>00:00:00</div>${type === 'nursing' ? `<div class="breast-controls">${['left', 'right'].map((side, i) => `<button type="button" data-action="timer-side" data-side="${side}" class="breast ${state.timer?.running && state.timer.side === side ? 'running' : ''}"><span>${i ? 'Правая' : 'Левая'}</span><strong data-timer-side="${side}">00:00:00</strong><b>${state.timer?.running && state.timer.side === side ? 'Ⅱ' : '▶'}</b></button>`).join('')}</div>` : button('timer-toggle', state.timer?.running ? 'Ⅱ Приостановить' : '▶ Начать / продолжить', 'primary wide')}<p class="muted">Таймер продолжится после закрытия окна и перезагрузки страницы.</p>` : detailFields(type)}<label>Заметка<textarea name="note" rows="2" maxlength="1000" placeholder="Добавить заметку">${escape(draft.note)}</textarea></label><button class="primary wide" type="submit">Сохранить</button>${timed && state.timer ? button('discard-timer', 'Отменить таймер', 'text-button wide') : ''}<p class="form-error" role="alert"></p></form>`;
    }
    function detailFields(type) {
        const options = { bottle: ['Грудное молоко', 'Смесь', 'Вода'], nappy: ['Мокрый', 'Стул', 'Смешанный', 'Сухой'], potty: ['Мочеиспускание', 'Стул', 'Сухо'], activity: ['Купание', 'На животике', 'Чтение', 'Прогулка', 'Кожа к коже'], sleep: ['Ночной сон', 'Дневной сон'] };
        if (type === 'bottle' || type === 'pumping') return `${type === 'bottle' ? `<label>Тип<select name="detail">${options.bottle.map(v => `<option>${v}</option>`).join('')}</select></label>` : ''}<label>Единицы<select name="unit"><option value="ml" ${draft.unit === 'ml' ? 'selected' : ''}>мл</option><option value="oz" ${draft.unit === 'oz' ? 'selected' : ''}>oz</option></select></label><label>Количество<input type="number" name="amount" min="0" max="2000" step="0.1" value="${draft.amount}" required></label>`;
        if (options[type]) return `<label>Тип<select name="detail">${options[type].map(v => `<option>${v}</option>`).join('')}</select></label>`;
        if (type === 'growth') return '<label>Вес, кг<input type="number" name="weight" min="0.1" max="100" step="0.01" required></label><label>Рост, см<input type="number" name="height" min="20" max="200" step="0.1" required></label>';
        if (type === 'temperature') return '<label>Температура, °C<input type="number" name="temperature" min="30" max="45" step="0.1" required></label>';
        return '<label>Описание<input name="detail" maxlength="200" required placeholder="Что произошло?"></label>';
    }
    function modalHTML() {
        let title, content;
        if (modal === 'customize') { title = 'Настроить трекеры'; content = `<form id="customize-form">${types.map(t => toggle(t[0], state.visible.includes(t[0]), t[1])).join('')}<button class="primary wide">Сохранить</button></form>`; }
        if (modal === 'filters') { title = 'Настройки отчётов'; content = `<form id="filters-form"><div class="filter-section">${toggle('dayStart', state.filters.dayStart, 'Начинать день по профилю')}<p class="muted">Начало дня: ${escape(state.profile.dayStart)}. Применяется к режиму «День».</p></div>${types.map(t => `<div class="filter-section">${toggle(t[0], state.filters.types.includes(t[0]), t[1])}<span class="filter-type" style="--card:${t[3]}">${icon(t[2])}</span></div>`).join('')}<fieldset class="period-options"><legend>Период</legend>${[7, 14, 30].map(days => `<label>${days === 30 ? 'Месяц' : days + ' дней'}<input type="radio" name="days" value="${days}" ${state.filters.days === days ? 'checked' : ''}></label>`).join('')}</fieldset><div class="dialog-actions">${button('reset-filters', 'Сбросить', 'outline')}<button class="primary">Применить</button></div></form>`; }
        if (modal === 'entry') { title = ['nursing', 'bottle'].includes(draft.type) ? 'Добавить кормление' : getType(draft.type)[1]; content = entryForm(); }
        if (modal === 'detail') { const e = state.entries.find(e => e.id === selectedEntry); title = getType(e.type)[1]; content = `<div class="entry-detail"><p>${dateLabel(e.start)} · ${timeLabel(e.start)}</p>${e.seconds ? `<h2>${duration(e.seconds)}</h2>` : ''}${e.left !== undefined ? `<p>Левая: ${duration(e.left)} · Правая: ${duration(e.right)}</p>` : ''}<p>${escape(e.detail)}</p><p>${escape(e.note)}</p>${button('delete-entry', 'Удалить запись', 'danger wide')}</div>`; }
        if (modal === 'inbox') { title = 'Сообщения'; content = '<div class="empty-state"><h2>Всё спокойно</h2><p>Новых сообщений пока нет.</p></div>'; }
        return `<div class="dialog-backdrop"><section class="dash-dialog" role="dialog" aria-modal="true" aria-labelledby="dialog-title" tabindex="-1"><header>${button('close-modal', icon('close'), 'icon-button')}<h2 id="dialog-title">${title}</h2><span></span></header>${content}</section></div>`;
    }
    function updateTimers() { root.querySelectorAll('[data-timer-total]').forEach(el => el.textContent = duration(elapsed())); root.querySelectorAll('[data-timer-side]').forEach(el => el.textContent = duration(sideElapsed(el.dataset.timerSide))); }
    root.addEventListener('click', event => {
        const target = event.target.closest('[data-action]'); if (!target) return;
        event.preventDefault(); const action = target.dataset.action;
        if (['home', 'reports', 'plans', 'insights', 'child', 'berry'].includes(action)) { page = action; modal = null; render(); window.scrollTo(0, 0); }
        else if (['customize', 'filters', 'inbox'].includes(action)) { modal = action; render(); }
        else if (action === 'close-modal') { modal = null; render(); }
        else if (action === 'entry') openEntry(target.dataset.type);
        else if (action === 'report-tab') { reportTab = target.dataset.tab; render(); }
        else if (action === 'detail') { selectedEntry = target.dataset.id; modal = 'detail'; render(); }
        else if (action === 'delete-entry' && confirm('Удалить эту запись?')) { state.entries = state.entries.filter(e => e.id !== selectedEntry); save(); modal = null; render(); }
        else if (action === 'feeding-type') { if (state.timer && target.dataset.type !== state.timer.type) { alert('Сначала сохраните или отмените таймер.'); return; } draft.type = target.dataset.type; render(); }
        else if (['timer-side', 'timer-toggle'].includes(action)) {
            const startValue = root.querySelector('[name="start"]').value;
            if (!startValue || new Date(startValue) > new Date()) { alert('Укажите время начала не позднее текущего.'); return; }
            draft.start = startValue;
            if (!state.timer) state.timer = { type: draft.type, start: new Date(draft.start).toISOString(), seconds: 0, left: 0, right: 0, running: false, since: Date.now(), side: null };
            const t = state.timer, side = target.dataset.side || null, wasRunning = t.running, oldSide = t.side;
            pauseTimer();
            if (!wasRunning || side !== oldSide) { t.running = true; t.since = Date.now(); t.side = side; }
            save(); render();
        }
        else if (action === 'discard-timer' && confirm('Отменить таймер без сохранения?')) { state.timer = null; save(); modal = null; render(); }
        else if (action === 'reset-filters') { const form = root.querySelector('#filters-form'); form.querySelectorAll('input[type="checkbox"]').forEach(input => input.checked = input.name !== 'dayStart'); form.querySelector('[name="days"][value="7"]').checked = true; }
    });
    root.addEventListener('submit', event => {
        event.preventDefault(); const form = event.target, data = new FormData(form);
        if (form.id === 'customize-form') { state.visible = types.filter(t => data.has(t[0])).map(t => t[0]); if (!state.visible.length) { alert('Выберите хотя бы один трекер.'); return; } }
        else if (form.id === 'filters-form') state.filters = { ...state.filters, days: Number(data.get('days')), dayStart: data.has('dayStart'), types: types.filter(t => data.has(t[0])).map(t => t[0]) };
        else if (form.id === 'profile-form') { state.profile = { name: data.get('name').trim(), birthday: data.get('birthday'), dayStart: data.get('dayStart') }; if (!state.profile.name) return; save(); render(); root.querySelector('#profile-status').textContent = 'Профиль сохранён'; return; }
        else if (form.id === 'entry-form') {
            const start = new Date(data.get('start')); if (Number.isNaN(start.getTime()) || start > new Date()) { form.querySelector('.form-error').textContent = 'Укажите корректное время начала.'; return; }
            const timed = ['sleep', 'nursing'].includes(draft.type);
            if (timed && (!state.timer || elapsed() < 1)) { form.querySelector('.form-error').textContent = 'Запустите таймер перед сохранением.'; return; }
            pauseTimer();
            let detail = data.get('detail') || '';
            if (['bottle', 'pumping'].includes(draft.type)) detail = `${detail ? detail + ' · ' : ''}${data.get('amount')} ${data.get('unit') === 'ml' ? 'мл' : 'oz'}`;
            if (draft.type === 'growth') detail = `${data.get('weight')} кг · ${data.get('height')} см`;
            if (draft.type === 'temperature') detail = `${data.get('temperature')} °C`;
            const e = { id: crypto.randomUUID(), type: draft.type, start: start.toISOString(), detail, note: data.get('note') || '' };
            if (timed) { e.seconds = Math.floor(state.timer.seconds); if (draft.type === 'nursing') { e.left = Math.floor(state.timer.left); e.right = Math.floor(state.timer.right); } state.timer = null; }
            state.entries.push(e);
        }
        if (save()) { modal = null; render(); }
    });
    root.addEventListener('input', event => { if (modal === 'entry' && draft) { if (event.target.name === 'note') draft.note = event.target.value; if (event.target.name === 'start') draft.start = event.target.value; } });
    document.addEventListener('keydown', event => { if (event.key === 'Escape' && modal) { modal = null; render(); } if (event.key === 'Tab' && modal) { const focusable = [...root.querySelectorAll('.dash-dialog button, .dash-dialog input, .dash-dialog select, .dash-dialog textarea')].filter(el => !el.disabled); const first = focusable[0], last = focusable.at(-1); if (event.shiftKey && (document.activeElement === first || document.activeElement.classList.contains('dash-dialog'))) { event.preventDefault(); last?.focus(); } else if (!event.shiftKey && document.activeElement === last) { event.preventDefault(); first?.focus(); } } });
    window.addEventListener('storage', event => { if (event.key === 'ameli.dashboard.v1' && event.newValue) { try { state = { ...defaults, ...JSON.parse(event.newValue) }; render(); } catch { /* Keep current state if another tab writes invalid data. */ } } });
    setInterval(updateTimers, 1000);
    render();
}
