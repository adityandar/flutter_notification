import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:oktoast/oktoast.dart';
import 'package:timezone/data/latest.dart' as tzData;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> setup() async {
    // #1
    const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iosSetting = DarwinInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    // #2
    final initSettings =
        InitializationSettings(android: androidSetting, iOS: iosSetting);

    // #3
    await _localNotificationsPlugin.initialize(initSettings).then((_) {
      debugPrint('setupPlugin: setup success');
    }).catchError((Object error) {
      debugPrint('Error: $error');
    });
  }

  Future<void> addNotification({
    required String title,
    required String body,
    required String channelId,
    required String channelName,
    required int endTime,
  }) async {
    // #1
    tzData.initializeTimeZones();
    final scheduleTime = tz.TZDateTime.fromMillisecondsSinceEpoch(
      tz.local,
      endTime,
    );

// #2
    final androidDetail = AndroidNotificationDetails(
      channelId, // channel Id
      channelName, // channel Name
    );

    const iosDetail = DarwinNotificationDetails();

    final noticeDetail = NotificationDetails(
      iOS: iosDetail,
      android: androidDetail,
    );

// #3
    const id = 0;

// #4
    await _localNotificationsPlugin.zonedSchedule(
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

  void onDidReceiveLocalNotification(
    int? id,
    String? title,
    String? body,
    String? payload,
  ) async {
    // display a dialog with the notification details, tap ok to go to another page
    showToast('$title $body');
  }
}
