import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzData;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final _localNotificationPlugin = FlutterLocalNotificationsPlugin();

  Future<void> setup() async {
    final androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iosSetting = DarwinInitializationSettings();

    final initSetting = InitializationSettings(
      android: androidSetting,
      iOS: iosSetting,
    );

    await _localNotificationPlugin
        .initialize(initSetting)
        .then((_) => debugPrint('Notification initialized'))
        .catchError((e) => debugPrint('$e'));
  }

  Future<void> addNotification(
    String title,
    String body,
    int endTimeInMilliseconds, {
    String? channel,
  }) async {
    tzData.initializeTimeZones();
    final scheduleTime = tz.TZDateTime.fromMillisecondsSinceEpoch(
      tz.local,
      endTimeInMilliseconds,
    );

    final androidDetail = AndroidNotificationDetails(
      channel ?? 'test',
      channel ?? 'test',
    );
    final iosDetail = DarwinNotificationDetails();

    final noticeDetail = NotificationDetails(
      android: androidDetail,
      iOS: iosDetail,
    );
    const id = 0;

    await _localNotificationPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduleTime,
      noticeDetail,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }
}
