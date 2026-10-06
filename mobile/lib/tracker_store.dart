import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const trackerNames = <String, String>{
  'sleep': 'Сон', 'nursing': 'Грудное кормление', 'bottle': 'Бутылочка',
  'nappy': 'Подгузник', 'pumping': 'Сцеживание', 'milestones': 'Достижения',
  'growth': 'Рост', 'activity': 'Активность',
};

String clock(int seconds) => [seconds ~/ 3600, (seconds ~/ 60) % 60, seconds % 60]
    .map((value) => value.toString().padLeft(2, '0')).join(':');
String dateTimeLabel(DateTime value) {
  final d = value.toLocal();
  return '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year} '
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}

class TrackerEntry {
  const TrackerEntry({required this.id, required this.type, required this.start,
    this.seconds = 0, this.left = 0, this.right = 0, this.detail = '', this.note = ''});
  final String id, type, detail, note;
  final DateTime start;
  final int seconds, left, right;
  Map<String, dynamic> toJson() => {'id': id, 'type': type, 'start': start.toIso8601String(),
    'seconds': seconds, 'left': left, 'right': right, 'detail': detail, 'note': note};
  factory TrackerEntry.fromJson(Map<String, dynamic> json) => TrackerEntry(
    id: json['id'] as String, type: json['type'] as String,
    start: DateTime.parse(json['start'] as String), seconds: json['seconds'] as int? ?? 0,
    left: json['left'] as int? ?? 0, right: json['right'] as int? ?? 0,
    detail: json['detail'] as String? ?? '', note: json['note'] as String? ?? '');
}

/// Elapsed time uses wall-clock timestamps, so locking the phone does not stop it.
/// No background execution or screen-lock UI is required for restoration.
class ActiveTimer {
  ActiveTimer({required this.type, required this.start, this.savedMs = 0,
    this.leftMs = 0, this.rightMs = 0, this.runningSince, this.side = 'left'});
  final String type;
  final DateTime start;
  int savedMs, leftMs, rightMs;
  DateTime? runningSince;
  String side;
  int delta(DateTime now) => runningSince == null ? 0 :
      (now.difference(runningSince!).inMilliseconds).clamp(0, 1 << 52).toInt();
  int elapsed(DateTime now) => (savedMs + delta(now)) ~/ 1000;
  int sideSeconds(String value, DateTime now) =>
      ((value == 'left' ? leftMs : rightMs) + (side == value ? delta(now) : 0)) ~/ 1000;
  void pause(DateTime now) {
    final ms = delta(now);
    savedMs += ms;
    if (type == 'nursing') {
      if (side == 'left') { leftMs += ms; } else { rightMs += ms; }
    }
    runningSince = null;
  }
  void toggle(DateTime now, [String? newSide]) {
    final wasRunning = runningSince != null;
    final oldSide = side;
    pause(now);
    if (newSide != null) side = newSide;
    if (!wasRunning || (newSide != null && newSide != oldSide)) runningSince = now;
  }
  Map<String, dynamic> toJson() => {'type': type, 'start': start.toIso8601String(),
    'savedMs': savedMs, 'leftMs': leftMs, 'rightMs': rightMs, 'side': side,
    'runningSince': runningSince?.toIso8601String()};
  factory ActiveTimer.fromJson(Map<String, dynamic> json) => ActiveTimer(
    type: json['type'] as String, start: DateTime.parse(json['start'] as String),
    savedMs: json['savedMs'] as int, leftMs: json['leftMs'] as int,
    rightMs: json['rightMs'] as int, side: json['side'] as String,
    runningSince: json['runningSince'] == null ? null : DateTime.parse(json['runningSince'] as String));
}

class TrackerStore extends ChangeNotifier {
  TrackerStore(this.preferences);
  final SharedPreferences preferences;
  String childName = 'Ameli';
  String? birthday;
  List<String> visible = ['sleep', 'nursing', 'nappy', 'pumping', 'milestones', 'growth', 'activity'];
  List<TrackerEntry> entries = [];
  ActiveTimer? timer;
  int period = 7;
  Set<String> categories = trackerNames.keys.toSet();
  String? storageError;

  static Future<TrackerStore> load() async {
    final store = TrackerStore(await SharedPreferences.getInstance());
    final raw = store.preferences.getString('ameli.mobile.v1');
    if (raw != null) {
      try {
        final data = jsonDecode(raw) as Map<String, dynamic>;
        store.childName = data['childName'] as String;
        store.birthday = data['birthday'] as String?;
        store.visible = List<String>.from(data['visible'] as List);
        store.entries = (data['entries'] as List).map((e) => TrackerEntry.fromJson(Map<String, dynamic>.from(e as Map))).toList();
        store.timer = data['timer'] == null ? null : ActiveTimer.fromJson(Map<String, dynamic>.from(data['timer'] as Map));
        store.period = data['period'] as int? ?? 7;
        store.categories = Set<String>.from(data['categories'] as List? ?? trackerNames.keys.toList());
      } catch (_) { store.storageError = 'Не удалось прочитать сохранённые данные.'; }
    }
    return store;
  }
  Future<void> persist() async {
    try {
      final saved = await preferences.setString('ameli.mobile.v1', jsonEncode({
        'childName': childName, 'birthday': birthday, 'visible': visible,
        'entries': entries.map((e) => e.toJson()).toList(), 'timer': timer?.toJson(),
        'period': period, 'categories': categories.toList(),
      }));
      storageError = saved ? null : 'Не удалось сохранить данные на устройстве.';
    } catch (_) { storageError = 'Не удалось сохранить данные на устройстве.'; }
    notifyListeners();
  }
  List<TrackerEntry> report(DateTime now) => entries.where((entry) =>
    !entry.start.isBefore(now.subtract(Duration(days: period))) &&
    !entry.start.isAfter(now) && categories.contains(entry.type)).toList()
    ..sort((a, b) => b.start.compareTo(a.start));
  Future<void> toggleTimer(String type, [String? side]) async {
    if (timer != null && timer!.type != type) throw StateError('Завершите текущий таймер.');
    final now = DateTime.now().toUtc();
    timer ??= ActiveTimer(type: type, start: now);
    timer!.toggle(now, side);
    await persist();
  }
  Future<bool> finishTimer(String note) async {
    final active = timer;
    if (active == null || active.elapsed(DateTime.now().toUtc()) < 1) return false;
    active.pause(DateTime.now().toUtc());
    entries.add(TrackerEntry(id: DateTime.now().microsecondsSinceEpoch.toString(), type: active.type,
      start: active.start, seconds: active.savedMs ~/ 1000,
      left: active.leftMs ~/ 1000, right: active.rightMs ~/ 1000, note: note));
    timer = null;
    await persist();
    return true;
  }
}
