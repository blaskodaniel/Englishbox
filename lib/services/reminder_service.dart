import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Napi emlékeztető értesítés („Only if you haven't practised yet”).
///
/// Nem ismétlődő értesítést kérünk a rendszertől, hanem a következő 7 napra
/// egyenként ütemezünk egyet-egyet. Így ha ma már tanultál, a mait egyszerűen
/// kihagyjuk. Az app minden indításkor és előtérbe kerüléskor újraütemez,
/// ezért a lista mindig friss.
class ReminderService {
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static const _daysAhead = 7;
  static const _firstId = 100;

  static const _details = NotificationDetails(
    android: AndroidNotificationDetails(
      'daily_reminder',
      'Daily reminder',
      channelDescription: 'A gentle nudge to practise English every day',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    ),
  );

  Future<void> _init() async {
    if (_initialized) return;
    tz_data.initializeTimeZones();
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
    _initialized = true;
  }

  AndroidFlutterLocalNotificationsPlugin? get _android =>
      _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

  /// Újraütemezi az emlékeztetőket a beállítások és a mai tevékenység szerint.
  Future<void> sync({
    required bool enabled,
    required int minutesOfDay,
    required bool practisedToday,
  }) async {
    try {
      await _init();
      for (var i = 0; i < _daysAhead; i++) {
        await _plugin.cancel(id: _firstId + i);
      }
      if (!enabled) return;
      // Android 13+: az első alkalommal megkérdezi a rendszer, hogy engedélyezed-e
      // az értesítéseket. Ha már döntöttél, nem kérdez újra.
      await _android?.requestNotificationsPermission();

      // Pontos időzítés, ha a telefon engedi (Android 12+ külön engedély,
      // Android 14-től friss telepítésnél alapból tiltva). Különben a rendszer
      // „nagyjából akkor” küldi – energiatakarékos módban akár jóval később.
      final exact = await _android?.canScheduleExactNotifications() ?? false;

      final now = DateTime.now();
      for (var i = 0; i < _daysAhead; i++) {
        // DateTime(év, hó, nap + i, óra, perc) – helyi idő, a hónapváltást is kezeli.
        final at = DateTime(
          now.year,
          now.month,
          now.day + i,
          minutesOfDay ~/ 60,
          minutesOfDay % 60,
        );
        if (!at.isAfter(now)) continue;
        if (i == 0 && practisedToday) continue;
        await _plugin.zonedSchedule(
          id: _firstId + i,
          title: 'Time for a little English 📦',
          body: i == 0
              ? "Your streak is waiting – a quick review takes 5 minutes."
              : 'Catch a new word or review a few cards today.',
          // Abszolút időpontot adunk át UTC-ben – így nem kell tudni a telefon
          // időzónájának nevét.
          scheduledDate: tz.TZDateTime.from(at, tz.UTC),
          notificationDetails: _details,
          androidScheduleMode: exact
              ? AndroidScheduleMode.exactAllowWhileIdle
              : AndroidScheduleMode.inexactAllowWhileIdle,
        );
      }
    } catch (e, st) {
      // Az emlékeztető nem kritikus – hiba esetén az app működjön tovább.
      debugPrint('Reminder sync failed: $e\n$st');
    }
  }

  /// Engedélyezve vannak-e az app értesítései a telefon beállításaiban.
  /// (Ha egyszer letiltottad, az app már nem kérdezhet rá újra.)
  Future<bool> notificationsEnabled() async {
    try {
      await _init();
      return await _android?.areNotificationsEnabled() ?? true;
    } catch (_) {
      return true;
    }
  }
}

final reminderServiceProvider = Provider((ref) => ReminderService());
