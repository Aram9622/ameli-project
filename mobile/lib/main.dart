import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'tracker_store.dart';

const navy = Color(0xff131f30), panel = Color(0xff203148);
const lime = Color(0xff99d532), cyan = Color(0xff2ecbdc);
const colors = <String, Color>{'sleep': cyan, 'nursing': Color(0xffff763f),
  'bottle': Color(0xfff3388b), 'nappy': Color(0xfff7ce31), 'pumping': Color(0xffa186f8),
  'milestones': Color(0xff84a4fb), 'growth': Color(0xff15d55b), 'activity': Color(0xffc8ce08)};
const icons = <String, IconData>{'sleep': Icons.bedtime_outlined, 'nursing': Icons.water_drop_outlined,
  'bottle': Icons.local_drink_outlined, 'nappy': Icons.child_friendly_outlined,
  'pumping': Icons.water_drop_outlined, 'milestones': Icons.star_outline,
  'growth': Icons.straighten, 'activity': Icons.wb_sunny_outlined};

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final store = await TrackerStore.load();
    runApp(AmeliApp(store: store));
  } catch (_) {
    runApp(const MaterialApp(home: Scaffold(body: Center(child:
      Text('Не удалось открыть хранилище. Перезапустите приложение.')))));
  }
}

class AmeliApp extends StatelessWidget {
  const AmeliApp({super.key, required this.store});
  final TrackerStore store;
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Ameli', debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, brightness: Brightness.dark,
      scaffoldBackgroundColor: navy,
      colorScheme: ColorScheme.fromSeed(seedColor: cyan, brightness: Brightness.dark,
        primary: lime, surface: panel),
      appBarTheme: const AppBarTheme(backgroundColor: navy, centerTitle: true),
      inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
      filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(
        backgroundColor: lime, foregroundColor: navy,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18)))),
    home: Dashboard(store: store));
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key, required this.store});
  final TrackerStore store;
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with WidgetsBindingObserver {
  int tab = 0;
  bool exporting = false;
  Timer? ticker;
  TrackerStore get store => widget.store;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    store.addListener(refresh);
    ticker = Timer.periodic(const Duration(seconds: 1), (_) { if (store.timer != null) refresh(); });
  }
  void refresh() { if (mounted) setState(() {}); }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) { if (state == AppLifecycleState.resumed) refresh(); }
  @override
  void dispose() {
    ticker?.cancel(); store.removeListener(refresh); WidgetsBinding.instance.removeObserver(this); super.dispose();
  }
  void message(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  Future<void> openTracker(String type) async {
    if (['sleep', 'nursing'].contains(type) && store.timer != null && store.timer!.type != type) {
      message('Сначала сохраните или отмените текущий таймер.'); return;
    }
    await Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) =>
      ['sleep', 'nursing'].contains(type) ? TimerScreen(store: store, type: type) : EntryScreen(store: store, type: type)));
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('ameli', style: TextStyle(color: cyan, fontWeight: FontWeight.bold)),
      leading: Padding(padding: const EdgeInsets.all(10), child: CircleAvatar(backgroundColor: cyan,
        child: Text(store.childName.isEmpty ? 'A' : store.childName.substring(0, 1)))),
      actions: [IconButton(tooltip: 'Настроить трекеры', onPressed: customize, icon: const Icon(Icons.tune))]),
    body: SafeArea(child: Column(children: [
      if (store.storageError != null) MaterialBanner(content: Text(store.storageError!), actions: [
        TextButton(onPressed: () { store.storageError = null; refresh(); }, child: const Text('Закрыть'))]),
      Expanded(child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 900),
        child: switch (tab) { 0 => home(), 1 => reports(), _ => profile() }))),
    ])),
    bottomNavigationBar: NavigationBar(backgroundColor: navy, indicatorColor: lime,
      selectedIndex: tab, onDestinationSelected: (value) => setState(() => tab = value),
      destinations: const [NavigationDestination(icon: Icon(Icons.add_circle_outline), label: 'Главная'),
        NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Отчёты'),
        NavigationDestination(icon: Icon(Icons.child_care), label: 'Ребёнок')]));

  Widget home() => ListView(padding: const EdgeInsets.all(16), children: [
    Text(store.childName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
    Container(padding: const EdgeInsets.all(24), margin: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(26)),
      child: const Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Каждый момент\nпод заботой.', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        SizedBox(height: 12), Text('Сон, кормление и маленькие открытия — всё рядом.', style: TextStyle(color: Colors.white70)),
      ])), Icon(Icons.spa_outlined, size: 64, color: lime)])),
    ...store.visible.where(trackerNames.containsKey).map((type) {
      final recent = store.entries.where((entry) => entry.type == type).toList()..sort((a, b) => b.start.compareTo(a.start));
      return Padding(padding: const EdgeInsets.only(bottom: 14), child: Material(
        color: colors[type], borderRadius: BorderRadius.circular(24), clipBehavior: Clip.antiAlias,
        child: InkWell(onTap: () => openTracker(type), child: SizedBox(height: 120, child: Stack(children: [
          Positioned(left: -12, bottom: -18, child: Icon(icons[type], size: 126, color: navy.withValues(alpha: .18))),
          Padding(padding: const EdgeInsets.fromLTRB(94, 18, 20, 18), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(trackerNames[type]!, style: const TextStyle(color: navy, fontSize: 23, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6), Text(store.timer?.type == type ? clock(store.timer!.elapsed(DateTime.now().toUtc())) :
              recent.isEmpty ? 'Добавить первую запись' : dateTimeLabel(recent.first.start),
              style: const TextStyle(color: navy, fontSize: 13)),
          ])), const Positioned(right: 14, top: 10, child: Icon(Icons.add, color: navy)),
        ])))));
    }),
    OutlinedButton.icon(onPressed: customize, icon: const Icon(Icons.tune), label: const Text('Настроить трекеры')),
  ]);

  Future<void> customize() async {
    final selected = store.visible.toSet();
    await showModalBottomSheet<void>(context: context, isScrollControlled: true, builder: (context) =>
      StatefulBuilder(builder: (context, update) => SafeArea(child: Padding(
        padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Настроить трекеры', style: TextStyle(fontSize: 22)),
          ...trackerNames.entries.map((item) => SwitchListTile(title: Text(item.value), value: selected.contains(item.key),
            onChanged: (value) => update(() => value ? selected.add(item.key) : selected.remove(item.key)))),
          FilledButton(onPressed: selected.isEmpty ? null : () async {
            store.visible = trackerNames.keys.where(selected.contains).toList(); await store.persist();
            if (context.mounted) Navigator.pop(context);
          }, child: const Text('Сохранить')),
        ])))));
  }

  Widget reports() {
    final entries = store.report(DateTime.now().toUtc());
    return ListView(padding: const EdgeInsets.all(16), children: [
      Row(children: [const Expanded(child: Text('Отчёты', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))),
        IconButton(tooltip: 'Фильтры', onPressed: filters, icon: const Icon(Icons.tune))]),
      Text('Последние ${store.period} дней · ${entries.length} записей', style: const TextStyle(color: Colors.white70)),
      const SizedBox(height: 16), FilledButton.icon(onPressed: exporting ? null : exportPdf,
        icon: const Icon(Icons.picture_as_pdf_outlined), label: Text(exporting ? 'Подготовка…' : 'Скачать / отправить PDF')),
      const SizedBox(height: 16),
      if (entries.isEmpty) const Padding(padding: EdgeInsets.all(30), child: Text('С этими фильтрами записей пока нет.', textAlign: TextAlign.center)),
      ...entries.map((entry) => Card(color: panel, child: ListTile(
        leading: Icon(icons[entry.type], color: colors[entry.type]),
        title: Text('${trackerNames[entry.type]}${entry.seconds > 0 ? ' · ${clock(entry.seconds)}' : ''}'),
        subtitle: Text('${dateTimeLabel(entry.start)}\n${entry.detail}${entry.note.isEmpty ? '' : '\n${entry.note}'}'),
        isThreeLine: true, onTap: () => entryDetails(entry)))),
    ]);
  }
  Future<void> entryDetails(TrackerEntry entry) => showDialog<void>(context: context, builder: (context) => AlertDialog(
    title: Text(trackerNames[entry.type]!), content: SingleChildScrollView(child: Text(
      '${dateTimeLabel(entry.start)}\n${entry.seconds > 0 ? clock(entry.seconds) : ''}\n'
      '${entry.type == 'nursing' ? 'Левая: ${clock(entry.left)} · Правая: ${clock(entry.right)}\n' : ''}${entry.detail}\n${entry.note}')),
    actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Закрыть')),
      TextButton(onPressed: () async {
        Navigator.pop(context);
        final confirm = await showDialog<bool>(context: this.context, builder: (context) => AlertDialog(
          title: const Text('Удалить запись?'), actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Отмена')),
            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Удалить'))]));
        if (confirm == true) { store.entries.removeWhere((e) => e.id == entry.id); await store.persist(); }
      }, child: const Text('Удалить'))]));

  Future<void> filters() async {
    final selected = Set<String>.from(store.categories); var period = store.period;
    await showModalBottomSheet<void>(context: context, isScrollControlled: true, builder: (context) =>
      StatefulBuilder(builder: (context, update) => SafeArea(child: Padding(padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Настройки отчётов', style: TextStyle(fontSize: 22)),
          DropdownButton<int>(value: period, isExpanded: true,
            items: [7, 14, 30].map((days) => DropdownMenuItem(value: days, child: Text('$days дней'))).toList(),
            onChanged: (value) => update(() => period = value!)),
          ...trackerNames.entries.map((item) => CheckboxListTile(title: Text(item.value), value: selected.contains(item.key),
            onChanged: (value) => update(() => value! ? selected.add(item.key) : selected.remove(item.key)))),
          FilledButton(onPressed: () async { store.period = period; store.categories = selected; await store.persist();
            if (context.mounted) Navigator.pop(context); }, child: const Text('Применить')),
        ])))));
  }

  Widget profile() => ProfileForm(store: store);
  Future<void> exportPdf() async {
    setState(() => exporting = true);
    final name = store.childName, days = store.period, now = DateTime.now();
    final entries = List<TrackerEntry>.from(store.report(now.toUtc()));
    try {
      final font = pw.Font.ttf(await rootBundle.load('assets/fonts/DejaVuSans.ttf'));
      final doc = pw.Document();
      doc.addPage(pw.MultiPage(pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: font, bold: font),
        footer: (context) => pw.Text('Ameli · ${context.pageNumber} / ${context.pagesCount}', style: const pw.TextStyle(fontSize: 9)),
        build: (_) => [
          pw.Header(level: 0, text: 'Ameli — отчёт'), pw.Text('Ребёнок: $name'),
          pw.Text('Период: ${dateTimeLabel(now.subtract(Duration(days: days)))} — ${dateTimeLabel(now)}'),
          pw.Text('Время указано по часовому поясу устройства: ${now.timeZoneName}'), pw.SizedBox(height: 16),
          if (entries.isEmpty) pw.Text('За выбранный период с этими фильтрами записей нет.'),
          ...entries.expand((entry) => [
            pw.SizedBox(height: 12), pw.Text('${dateTimeLabel(entry.start)} — ${trackerNames[entry.type]}'),
            if (entry.seconds > 0) pw.Text('Длительность: ${clock(entry.seconds)}'),
            if (entry.type == 'nursing') pw.Text('Левая: ${clock(entry.left)} · Правая: ${clock(entry.right)}'),
            if (entry.detail.isNotEmpty) pw.Text(entry.detail), if (entry.note.isNotEmpty) pw.Text('Заметка: ${entry.note}'),
          ]),
        ]));
      await Printing.sharePdf(bytes: await doc.save(), filename: 'Ameli_${now.toIso8601String().substring(0, 10)}.pdf');
    } catch (_) { if (mounted) message('Не удалось создать PDF. Попробуйте ещё раз.'); }
    finally { if (mounted) setState(() => exporting = false); }
  }
}

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key, required this.store, required this.type});
  final TrackerStore store;
  final String type;
  @override
  State<TimerScreen> createState() => _TimerScreenState();
}
class _TimerScreenState extends State<TimerScreen> {
  final note = TextEditingController();
  Timer? ticker;
  @override
  void initState() { super.initState(); ticker = Timer.periodic(const Duration(seconds: 1), (_) { if (mounted) setState(() {}); }); }
  @override
  void dispose() { ticker?.cancel(); note.dispose(); super.dispose(); }
  Future<void> toggle([String? side]) async { await widget.store.toggleTimer(widget.type, side); if (mounted) setState(() {}); }
  @override
  Widget build(BuildContext context) {
    final timer = widget.store.timer, now = DateTime.now().toUtc();
    return Scaffold(appBar: AppBar(title: Text(trackerNames[widget.type]!)), body: SafeArea(child: ListView(
      padding: const EdgeInsets.all(24), children: [
        Text('Начало: ${timer == null ? 'при запуске таймера' : dateTimeLabel(timer.start)}'),
        const SizedBox(height: 55), Center(child: Text(clock(timer?.elapsed(now) ?? 0),
          style: const TextStyle(fontSize: 52, fontFeatures: [FontFeature.tabularFigures()]))),
        const SizedBox(height: 36),
        if (widget.type == 'nursing') Row(children: ['left', 'right'].map((side) => Expanded(child: Padding(
          padding: const EdgeInsets.all(6), child: FilledButton(style: FilledButton.styleFrom(
            backgroundColor: timer?.runningSince != null && timer?.side == side ? colors['nursing'] : panel,
            foregroundColor: Colors.white, shape: const CircleBorder(), padding: const EdgeInsets.all(24)),
            onPressed: () => toggle(side), child: SizedBox(height: 105, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(side == 'left' ? 'Левая' : 'Правая'), const SizedBox(height: 10),
              Text(clock(timer?.sideSeconds(side, now) ?? 0)), const SizedBox(height: 8),
              Icon(timer?.runningSince != null && timer?.side == side ? Icons.pause : Icons.play_arrow),
            ])))))).toList())
        else FilledButton.icon(onPressed: toggle, icon: Icon(timer?.runningSince == null ? Icons.play_arrow : Icons.pause),
          label: Text(timer?.runningSince == null ? 'Начать / продолжить' : 'Приостановить')),
        const SizedBox(height: 24), const Text('После блокировки телефона отсчёт восстановится при открытии приложения. Показ на экране блокировки ещё не подключён.', style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 24), TextField(controller: note, maxLength: 1000, maxLines: 3, decoration: const InputDecoration(labelText: 'Заметка')),
        const SizedBox(height: 20), FilledButton(onPressed: () async {
          final saved = await widget.store.finishTimer(note.text.trim());
          if (!context.mounted) return;
          if (saved) { Navigator.pop(context); } else { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Сначала запустите таймер.'))); }
        }, child: const Text('Сохранить')),
        if (timer != null) TextButton(onPressed: () async {
          final confirm = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
            title: const Text('Отменить таймер без сохранения?'), actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Нет')),
              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Да'))]));
          if (confirm == true) { widget.store.timer = null; await widget.store.persist(); if (context.mounted) Navigator.pop(context); }
        }, child: const Text('Отменить таймер')),
      ])));
  }
}

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key, required this.store, required this.type});
  final TrackerStore store;
  final String type;
  @override
  State<EntryScreen> createState() => _EntryScreenState();
}
class _EntryScreenState extends State<EntryScreen> {
  final form = GlobalKey<FormState>();
  final amount = TextEditingController(), height = TextEditingController();
  final detail = TextEditingController(), note = TextEditingController();
  DateTime start = DateTime.now();
  String kind = '', unit = 'мл';
  bool saving = false;
  List<String> get choices => switch (widget.type) {
    'bottle' => ['Грудное молоко', 'Смесь', 'Вода'],
    'nappy' => ['Мокрый', 'Стул', 'Смешанный', 'Сухой'],
    'activity' => ['Купание', 'На животике', 'Чтение', 'Прогулка', 'Кожа к коже'],
    _ => [],
  };
  @override
  void initState() { super.initState(); if (choices.isNotEmpty) kind = choices.first; }
  @override
  void dispose() { amount.dispose(); height.dispose(); detail.dispose(); note.dispose(); super.dispose(); }
  String? number(String? text, double min, double max) {
    final value = double.tryParse((text ?? '').replaceAll(',', '.'));
    return value == null || value < min || value > max ? 'Укажите число от $min до $max' : null;
  }
  Future<void> pickStart() async {
    final date = await showDatePicker(context: context, firstDate: DateTime(2000), lastDate: DateTime.now(), initialDate: start);
    if (date == null || !mounted) return;
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(start));
    if (time == null || !mounted) return;
    final value = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    if (value.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Начало не может быть в будущем.'))); return;
    }
    setState(() => start = value);
  }
  @override
  Widget build(BuildContext context) {
    final measured = ['bottle', 'pumping', 'growth'].contains(widget.type);
    return Scaffold(appBar: AppBar(title: Text(trackerNames[widget.type]!)), body: SafeArea(child: Form(key: form,
      child: ListView(padding: const EdgeInsets.all(24), children: [
        ListTile(contentPadding: EdgeInsets.zero, title: const Text('Начало'), subtitle: Text(dateTimeLabel(start)),
          trailing: const Icon(Icons.calendar_today), onTap: pickStart),
        const SizedBox(height: 20),
        if (choices.isNotEmpty) DropdownButtonFormField<String>(initialValue: kind,
          decoration: const InputDecoration(labelText: 'Тип'),
          items: choices.map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
          onChanged: (value) => setState(() => kind = value!)),
        if (measured) ...[
          const SizedBox(height: 20),
          if (widget.type != 'growth') DropdownButtonFormField<String>(initialValue: unit,
            decoration: const InputDecoration(labelText: 'Единицы'), items: ['мл', 'oz'].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
            onChanged: (value) => setState(() => unit = value!)),
          const SizedBox(height: 20), TextFormField(controller: amount, keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: widget.type == 'growth' ? 'Вес, кг' : 'Количество'),
            validator: (text) => number(text, widget.type == 'growth' ? .1 : 0, widget.type == 'growth' ? 100 : 2000)),
          if (widget.type == 'growth') ...[const SizedBox(height: 20), TextFormField(controller: height,
            keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Рост, см'),
            validator: (text) => number(text, 20, 200))],
        ],
        if (!measured && choices.isEmpty) ...[const SizedBox(height: 20), TextFormField(controller: detail,
          maxLength: 200, decoration: const InputDecoration(labelText: 'Описание'),
          validator: (text) => text == null || text.trim().isEmpty ? 'Добавьте описание' : null)],
        const SizedBox(height: 20), TextField(controller: note, maxLength: 1000, maxLines: 3, decoration: const InputDecoration(labelText: 'Заметка')),
        const SizedBox(height: 24), FilledButton(onPressed: saving ? null : () async {
          if (!form.currentState!.validate()) return;
          setState(() => saving = true);
          final info = widget.type == 'growth' ? '${amount.text} кг · ${height.text} см' : measured
            ? '${kind.isEmpty ? '' : '$kind · '}${amount.text} $unit' : choices.isNotEmpty ? kind : detail.text.trim();
          widget.store.entries.add(TrackerEntry(id: DateTime.now().microsecondsSinceEpoch.toString(),
            type: widget.type, start: start.toUtc(), detail: info, note: note.text.trim()));
          await widget.store.persist(); if (context.mounted) Navigator.pop(context);
        }, child: Text(saving ? 'Сохранение…' : 'Сохранить')),
      ]))));
  }
}

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key, required this.store});
  final TrackerStore store;
  @override
  State<ProfileForm> createState() => _ProfileFormState();
}
class _ProfileFormState extends State<ProfileForm> {
  late final TextEditingController name;
  DateTime? birthday;
  final form = GlobalKey<FormState>();
  @override
  void initState() { super.initState(); name = TextEditingController(text: widget.store.childName);
    birthday = widget.store.birthday == null ? null : DateTime.tryParse(widget.store.birthday!); }
  @override
  void dispose() { name.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Form(key: form, child: ListView(padding: const EdgeInsets.all(24), children: [
    const Icon(Icons.child_care, size: 72, color: cyan), const SizedBox(height: 24),
    const Text('Профиль ребёнка', style: TextStyle(fontSize: 28)), const SizedBox(height: 24),
    TextFormField(controller: name, maxLength: 60, decoration: const InputDecoration(labelText: 'Имя'),
      validator: (text) => text == null || text.trim().isEmpty ? 'Введите имя' : null),
    ListTile(contentPadding: EdgeInsets.zero, title: const Text('Дата рождения'),
      subtitle: Text(birthday == null ? 'Не указана' : dateTimeLabel(birthday!).split(' ').first),
      trailing: const Icon(Icons.calendar_today), onTap: () async {
        final value = await showDatePicker(context: context, firstDate: DateTime(2000), lastDate: DateTime.now(), initialDate: birthday ?? DateTime.now());
        if (value != null && mounted) setState(() => birthday = value);
      }),
    const SizedBox(height: 24), FilledButton(onPressed: () async {
      if (!form.currentState!.validate()) return;
      widget.store.childName = name.text.trim(); widget.store.birthday = birthday?.toIso8601String();
      await widget.store.persist();
      if (context.mounted) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Профиль сохранён'))); }
    }, child: const Text('Сохранить профиль')),
    const SizedBox(height: 24), const Text('Тестовая версия: данные хранятся только на этом устройстве. Аккаунт и синхронизация с сайтом пока не подключены. Удаление приложения удаляет локальные записи.', style: TextStyle(color: Colors.white70)),
  ]));
}
