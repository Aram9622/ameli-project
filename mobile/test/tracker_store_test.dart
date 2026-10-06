import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ameli_mobile/tracker_store.dart';

void main() {
  test('nursing switch and pause count each side without double counting', () {
    final start = DateTime.utc(2026, 1, 1);
    final timer = ActiveTimer(type: 'nursing', start: start);
    timer.toggle(start, 'left');
    timer.toggle(start.add(const Duration(seconds: 10)), 'right');
    timer.pause(start.add(const Duration(seconds: 25)));
    expect(timer.elapsed(start.add(const Duration(hours: 1))), 25);
    expect(timer.sideSeconds('left', start), 10);
    expect(timer.sideSeconds('right', start), 15);
  });
  test('running timer restores elapsed time after phone lock / reload', () {
    final start = DateTime.utc(2026, 1, 1);
    final timer = ActiveTimer(type: 'sleep', start: start)..toggle(start);
    final restored = ActiveTimer.fromJson(timer.toJson());
    expect(restored.elapsed(start.add(const Duration(hours: 2))), 7200);
  });
  test('fractional pauses retain milliseconds', () {
    final start = DateTime.utc(2026, 1, 1);
    final timer = ActiveTimer(type: 'nursing', start: start)..toggle(start, 'left');
    timer.pause(start.add(const Duration(milliseconds: 600)));
    timer.toggle(start.add(const Duration(seconds: 1)), 'left');
    timer.pause(start.add(const Duration(milliseconds: 1600)));
    expect(timer.elapsed(start.add(const Duration(seconds: 2))), 1);
  });
  test('record, profile and active timer survive storage reload', () async {
    SharedPreferences.setMockInitialValues({});
    final store = await TrackerStore.load();
    store.childName = 'Алиса';
    store.entries.add(TrackerEntry(id: '1', type: 'bottle', start: DateTime.now().toUtc(), detail: '120 мл'));
    await store.toggleTimer('nursing', 'right');
    final restored = await TrackerStore.load();
    expect(restored.childName, 'Алиса');
    expect(restored.entries.single.detail, '120 мл');
    expect(restored.timer!.side, 'right');
    expect(restored.timer!.runningSince, isNotNull);
  });
  test('report respects category, period and future date', () async {
    SharedPreferences.setMockInitialValues({});
    final store = await TrackerStore.load();
    final now = DateTime.utc(2026, 1, 30);
    store.categories = {'sleep'};
    store.entries = [
      TrackerEntry(id: 'visible', type: 'sleep', start: now.subtract(const Duration(days: 1))),
      TrackerEntry(id: 'old', type: 'sleep', start: now.subtract(const Duration(days: 10))),
      TrackerEntry(id: 'category', type: 'bottle', start: now),
      TrackerEntry(id: 'future', type: 'sleep', start: now.add(const Duration(days: 1))),
    ];
    expect(store.report(now).map((e) => e.id), ['visible']);
  });
}
