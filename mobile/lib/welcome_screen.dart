import 'package:flutter/material.dart';

const _ink = Color(0xff131f30);
const _cream = Color(0xfff4f2eb);
const _lime = Color(0xffc9ed32);
const _cyan = Color(0xff2ecbdc);

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key, required this.dashboardBuilder});
  final WidgetBuilder dashboardBuilder;

  void _openDashboard(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: dashboardBuilder));
  }

  @override
  Widget build(BuildContext context) => Theme(
    data: ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: _cream,
      colorScheme: ColorScheme.fromSeed(seedColor: _cyan, primary: _ink, surface: _cream),
      filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(
        backgroundColor: _lime, foregroundColor: _ink,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18))),
    ),
    child: Scaffold(
      appBar: AppBar(backgroundColor: _cream,
        title: const Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.spa, color: _cyan), SizedBox(width: 8),
          Text('ameli', style: TextStyle(fontWeight: FontWeight.bold)),
        ]),
        actions: [TextButton(onPressed: () => _openDashboard(context), child: const Text('К трекерам'))]),
      body: SafeArea(child: Center(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: ListView(padding: const EdgeInsets.all(24), children: [
          const SizedBox(height: 24),
          const Text('МАЛЕНЬКИЕ МОМЕНТЫ. БОЛЬШАЯ ЛЮБОВЬ.',
            style: TextStyle(fontSize: 11, letterSpacing: 1.5, color: Color(0xff657080))),
          const SizedBox(height: 20),
          const Text('Ваш спокойный день\nначинается с Ameli',
            style: TextStyle(fontSize: 38, height: 1.15, fontWeight: FontWeight.bold, color: _ink)),
          const SizedBox(height: 20),
          const Text('Сон, кормление и первые открытия малыша — в одном месте. '
            'Меньше держать в голове, больше быть рядом.',
            style: TextStyle(fontSize: 17, height: 1.6, color: Color(0xff657080))),
          const SizedBox(height: 24),
          FilledButton.icon(onPressed: () => _openDashboard(context),
            icon: const Icon(Icons.arrow_forward), label: const Text('Попробовать Ameli')),
          const SizedBox(height: 12),
          const Text('Тестовая версия · без оплаты', textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Color(0xff657080))),
          const SizedBox(height: 30),
          Container(padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: _ink, borderRadius: BorderRadius.circular(28)),
            child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Icon(Icons.bedtime_outlined, color: _cyan), SizedBox(width: 12),
                Text('Сон под заботой', style: TextStyle(color: Colors.white, fontSize: 19))]),
              SizedBox(height: 16),
              Text('00:12:38', style: TextStyle(color: _cyan, fontSize: 40, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Пример таймера. Сохраняйте настоящий сон в трекере.',
                style: TextStyle(color: Colors.white70, height: 1.5)),
            ])),
          const SizedBox(height: 38),
          const Text('Всё важное — рядом', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ...const [
            _Feature(icon: Icons.bedtime_outlined, title: 'Сон и кормление',
              text: 'Таймеры сна и грудного кормления с отдельным учётом каждой стороны.'),
            _Feature(icon: Icons.child_care, title: 'Маленькие открытия',
              text: 'Подгузники, рост, активность и достижения — сохраните историю малыша.'),
            _Feature(icon: Icons.picture_as_pdf_outlined, title: 'Отчёты, которыми можно поделиться',
              text: 'Выберите период и категории, сохраните PDF или отправьте его близким.'),
          ],
          const SizedBox(height: 30),
          const Text('Выберите свой ритм', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const Text('Планируемые тарифы. В тестовой версии все трекеры доступны бесплатно; '
            'подписка и списания пока не подключены.', style: TextStyle(color: Color(0xff657080), height: 1.6)),
          const SizedBox(height: 20),
          _Plan(title: 'Месяц', price: '399 ₽ / месяц', description: 'Для знакомства со всеми возможностями.',
            onPressed: () => _openDashboard(context)),
          const SizedBox(height: 16),
          _Plan(title: 'Год', price: '2 990 ₽ / год', description: '249 ₽ в месяц — экономия 37%.',
            onPressed: () => _openDashboard(context)),
          const SizedBox(height: 30),
          const Text('Записи пока хранятся только на этом устройстве. '
            'Аккаунт и синхронизация будут подключены позже.',
            style: TextStyle(color: Color(0xff657080), fontSize: 12, height: 1.6)),
          const SizedBox(height: 16),
        ]),
      ))),
    ),
  );
}

class _Feature extends StatelessWidget {
  const _Feature({required this.icon, required this.title, required this.text});
  final IconData icon;
  final String title, text;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 20),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: _ink, size: 30), const SizedBox(width: 16),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 6), Text(text, style: const TextStyle(color: Color(0xff657080), height: 1.5)),
      ])),
    ]));
}

class _Plan extends StatelessWidget {
  const _Plan({required this.title, required this.price, required this.description, required this.onPressed});
  final String title, price, description;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24),
      border: Border.all(color: const Color(0xffd9dfe3))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 14),
      Text(price, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12), Text(description), const SizedBox(height: 20),
      SizedBox(width: double.infinity, child: FilledButton(onPressed: onPressed,
        child: const Text('Попробовать без оплаты'))),
    ]));
}
