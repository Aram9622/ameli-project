import { jsPDF } from 'jspdf';
import fontUrl from '../fonts/DejaVuSans.ttf?url';

let fontPromise;
async function loadFont() {
    if (!fontPromise) {
        fontPromise = fetch(fontUrl).then(response => {
            if (!response.ok) throw new Error('Font unavailable');
            return response.arrayBuffer();
        }).then(buffer => {
            const bytes = new Uint8Array(buffer);
            let binary = '';
            for (let i = 0; i < bytes.length; i += 8192) {
                binary += String.fromCharCode(...bytes.subarray(i, i + 8192));
            }
            return btoa(binary);
        }).catch(error => { fontPromise = null; throw error; });
    }
    return fontPromise;
}

const date = value => new Date(value).toLocaleDateString('ru-RU', { day: 'numeric', month: 'long', year: 'numeric' });
const time = value => new Date(value).toLocaleTimeString('ru-RU', { hour: '2-digit', minute: '2-digit' });
const duration = seconds => [Math.floor(seconds / 3600), Math.floor(seconds / 60) % 60, Math.floor(seconds) % 60].map(n => String(n).padStart(2, '0')).join(':');

export async function downloadReport({ profile, filters, entries, types, generatedAt }) {
    const font = await loadFont();
    const pdf = new jsPDF({ unit: 'mm', format: 'a4', putOnlyUsedFonts: true });
    pdf.addFileToVFS('DejaVuSans.ttf', font);
    pdf.addFont('DejaVuSans.ttf', 'DejaVu', 'normal');
    pdf.setFont('DejaVu');
    pdf.setProperties({ title: `Ameli — отчёт: ${profile.name}`, subject: 'Отчёт о событиях ребёнка', creator: 'Ameli' });
    const margin = 18, width = 174, bottom = 275;
    let y = 22;
    function nextPage() { pdf.addPage(); y = 22; }
    // Wrap and paginate every line, including notes longer than a full page.
    function text(value, size = 10, color = [37, 51, 70], gap = 3) {
        pdf.setFontSize(size);
        pdf.setTextColor(...color);
        const lineHeight = size * 0.48;
        const lines = pdf.splitTextToSize(String(value).replace(/\r\n/g, '\n'), width);
        for (const line of lines) {
            if (y + lineHeight > bottom) nextPage();
            pdf.text(line, margin, y);
            y += lineHeight;
        }
        y += gap;
    }
    text('AMELI / Отчёт', 23);
    text(`Ребёнок: ${profile.name}`, 14);
    if (profile.birthday) text(`Дата рождения: ${date(profile.birthday)}`);
    const start = new Date(generatedAt);
    start.setDate(start.getDate() - filters.days);
    text(`Период: ${date(start)} — ${date(generatedAt)} (последние ${filters.days} дней)`);
    text(`Создан: ${date(generatedAt)}, ${time(generatedAt)}`, 9, [94, 112, 132]);
    text(`Категории: ${types.filter(t => filters.types.includes(t[0])).map(t => t[1]).join(', ') || 'не выбраны'}`, 9);
    text(`Время указано в часовом поясе: ${Intl.DateTimeFormat().resolvedOptions().timeZone}`, 9);
    text('Сводка', 15);
    if (!entries.length) text('За выбранный период с этими фильтрами записей нет.');
    for (const type of types) {
        const group = entries.filter(entry => entry.type === type[0]);
        if (!group.length) continue;
        const seconds = group.reduce((sum, entry) => sum + (entry.seconds || 0), 0);
        text(`${type[1]}: ${group.length} записей${seconds ? ` · длительность ${duration(seconds)}` : ''}`);
    }
    if (entries.length) text('События', 15);
    let day = '';
    for (const entry of entries) {
        const label = date(entry.start);
        if (label !== day) { text(label, 12, [18, 111, 128], 4); day = label; }
        const type = types.find(t => t[0] === entry.type);
        text(`${time(entry.start)} — ${type?.[1] || entry.type}${entry.seconds ? ' · ' + duration(entry.seconds) : ''}`, 11);
        if (entry.left !== undefined) text(`Левая: ${duration(entry.left)} · Правая: ${duration(entry.right)}`, 9);
        if (entry.detail) text(entry.detail, 10);
        if (entry.note) text(`Заметка: ${entry.note}`, 9, [94, 112, 132]);
        y += 3;
    }
    const count = pdf.getNumberOfPages();
    for (let page = 1; page <= count; page++) {
        pdf.setPage(page);
        pdf.setFontSize(8);
        pdf.setTextColor(110, 125, 140);
        pdf.text('Ameli · Записи, внесённые пользователем', margin, 287);
        pdf.text(`${page} / ${count}`, 192, 287, { align: 'right' });
    }
    const safeName = profile.name.replace(/[^\p{L}\p{N}_-]/gu, '_').slice(0, 60) || 'child';
    await pdf.save(`Ameli_${safeName}_${new Date(generatedAt).toISOString().slice(0, 10)}.pdf`, { returnPromise: true });
}
