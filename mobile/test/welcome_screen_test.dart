import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ameli_mobile/welcome_screen.dart';

void main() {
  testWidgets('welcome opens dashboard and back returns to landing', (tester) async {
    await tester.pumpWidget(MaterialApp(home: WelcomeScreen(
      dashboardBuilder: (_) => const Scaffold(body: Text('Тестовый кабинет')))));
    expect(find.text('Попробовать Ameli'), findsOneWidget);
    await tester.tap(find.text('Попробовать Ameli'));
    await tester.pumpAndSettle();
    expect(find.text('Тестовый кабинет'), findsOneWidget);
    final navigator = tester.state<NavigatorState>(find.byType(Navigator).first);
    navigator.pop();
    await tester.pumpAndSettle();
    expect(find.text('Попробовать Ameli'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
