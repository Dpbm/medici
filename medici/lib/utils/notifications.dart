import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
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
      onDidReceiveNotificationResponse: notificationTapResponse,
      onDidReceiveBackgroundNotificationResponse: notificationTapResponse,
    );
  }

  Future<void> scheduleDrug(DateTime time, int drugId, String drugName,
      double dose, String doseType, int alertId) async {
    final tz.Location location = timeZone ?? tz.local;
    final tz.TZDateTime scheduledTime =
        tz.TZDateTime.from(tz.TZDateTime.from(time, location), location);

    final notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails('notify', platform.name,
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            ongoing: true,
            autoCancel: false,
            actions: [
          const AndroidNotificationAction('take_it', 'take the medicine now',
              showsUserInterface: true),
          const AndroidNotificationAction(
              'delay_it', 'delay the medicine intake',
              showsUserInterface: true)
        ]));

    await flutterLocalNotificationsPlugin.zonedSchedule(
        alertId,
        'Hora do seu remédio!',
        "Tomar $dose$doseType de $drugName",
        scheduledTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: drugId.toString());
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
