import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medici/utils/notifications_ids.dart';
import 'package:medici/utils/time.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final MethodChannel drugsChannel =
      const MethodChannel('medici/drugs_notification');

  final MethodChannel quantityChannel =
      const MethodChannel('medici/quantity_notification');

  final MethodChannel expirationChannel =
      const MethodChannel('medici/expiration_notification');

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

  Future<void> setupTz() async {
    tz.initializeTimeZones();
    final String localTimeZone = DateTime.now().timeZoneName;
    timeZone = tz.getLocation(localTimeZone);
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
        android: AndroidNotificationDetails('notify_drug', drugsChannel.name,
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            ongoing: true,
            autoCancel: false,
            actions: [
          const AndroidNotificationAction('take_it', 'tomar'),
          const AndroidNotificationAction('delay_it', 'adiar')
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

  Future<void> scheduleMultiple(List<String> hours, int drugId, String drugName,
      double dose, String doseType, List<int> alertsIds) async {
    DateTime now = DateTime.now();

    for (int i = 0; i < hours.length; i++) {
      final TimeOfDay time = parseStringTime(hours[i]);

      DateTime newDate =
          DateTime(now.year, now.month, now.day, time.hour, time.minute);
      await scheduleDrug(
          newDate, drugId, drugName, dose, doseType, alertsIds[i]);
    }
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelMultiple(List<int> ids) async {
    for (final int id in ids) {
      cancelNotification(id);
    }
  }

  Future<void> showQuantityNotification(int drugId, String drugName) async {
    final notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
      'notify_quantity',
      quantityChannel.name,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      ongoing: true,
      autoCancel: false,
    ));

    await flutterLocalNotificationsPlugin.show(
        getQuantityNotificationId(drugId),
        'Seu remédio está acabando!',
        "Você precisa comprar mais $drugName",
        notificationDetails);
  }

  Future<void> scheduleExpiration(
      DateTime time, int drugId, String drugName, int expirationOffset) async {
    final tz.Location location = timeZone ?? tz.local;
    final tz.TZDateTime scheduledTime = tz.TZDateTime.from(
        tz.TZDateTime.from(
            DateTime(time.year, time.month, time.day).subtract(Duration(
                days:
                    expirationOffset)), // EX: use expiration offset to show this notification x days before the expiration
            location),
        location);

    final notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
            'notify_expiration', expirationChannel.name,
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            ongoing: true,
            autoCancel: false));

    await flutterLocalNotificationsPlugin.zonedSchedule(
        getExpirationNotificationId(drugId),
        'Seu remédio venceu',
        "Descarte o $drugName e compre mais",
        scheduledTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
        payload: drugId.toString());
  }
}
