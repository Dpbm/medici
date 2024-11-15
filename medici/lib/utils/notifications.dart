import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final StreamController<String?> selectNotificationStream =
      StreamController<String?>.broadcast();
  final MethodChannel platform =
      const MethodChannel('medici/drugs_notification');
  final String navigationActionId = 'drugs_notification';
  final AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  tz.Location? timeZone;

  bool accepted = false;

  Future<void> getPermission() async {
    final bool? acceptedPermission = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    accepted = acceptedPermission ?? false;
  }

  void setupTz() {
    tz.initializeTimeZones();
    timeZone = tz.getLocation('America/Sao_Paulo');
    tz.setLocalLocation(timeZone ?? tz.local);
  }

  Future<void> init(
      Function(NotificationResponse) notificationTapResponse) async {
    setupTz();
    await getPermission();

    if (!accepted) return;

    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print(response.payload);
        print(response.actionId);
        //flutterLocalNotificationsPlugin.cancel(response.id!);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapResponse,
    );
  }

  Future<void> schedule() async {
    final tz.TZDateTime scheduledTime = tz.TZDateTime.from(
        tz.TZDateTime.from(
            DateTime(2024, 11, 15, 14, 40), timeZone ?? tz.local),
        timeZone ?? tz.local);

    final notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails('notify', platform.name,
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            ongoing: true,
            autoCancel: false,
            actions: [const AndroidNotificationAction('0', 'tomado')]));

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          0,
          "notification title",
          "notification body",
          scheduledTime,
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
          payload: '1');

      debugPrint('Notification scheduled successfully');
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
    }
  }
}
