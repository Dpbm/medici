import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medici/utils/debug.dart';
import 'package:medici/utils/notifications_ids.dart';
import 'package:medici/utils/time.dart';
import 'package:permission_handler/permission_handler.dart';
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
  late tz.Location timeZone;

  bool accepted = false;
  bool initialized = false;

  late Function(NotificationResponse) handleFunction;

  NotificationService(Function(NotificationResponse) callback) {
    handleFunction = callback;
  }

  Future<void> setup() async {
    if (!initialized) {
      warning("Notifications wasn't initialized!");

      await init();
      return;
    }

    setupTz();
    await getPermission();
  }

  Future<void> getPermission() async {
    await Permission.ignoreBatteryOptimizations.request();
    PermissionStatus status = await Permission.notification.request();
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    accepted = status.isGranted;
  }

  void setupTz() {
    tz.initializeTimeZones();
    timeZone = tz.getLocation(
        "America/Sao_Paulo"); //It's a good idea to handle multiple timezones, but for now it's ok
    tz.setLocalLocation(timeZone);
  }

  Future<void> init() async {
    try {
      // these two following lines are now the best way, but it's just to avoid function call loops
      setupTz();
      await getPermission();

      if (!accepted) {
        warning("notifications not accepted from [init]");
        return;
      }

      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
      final InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
      );

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: handleFunction,
        onDidReceiveBackgroundNotificationResponse: handleFunction,
      );

      initialized = true;
      successLog("Initialized Notification Service");
    } catch (error) {
      logError("Error on init NotificationService!", error.toString());
    }
  }

  Future<void> scheduleDrug(DateTime time, int drugId, String drugName,
      double dose, String doseType, int alertId) async {
    await setup();
    if (!accepted) {
      warning("notifications not accepted from [scheduleDrug]!");
      return;
    }

    if (!initialized) {
      warning("notifications wasn't initialized [scheduleDrug]!");
      return;
    }

    final tz.TZDateTime scheduledTime =
        tz.TZDateTime.from(tz.TZDateTime.from(time, timeZone), timeZone);

    final notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails('notify_drug', drugsChannel.name,
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            ongoing: true,
            autoCancel: false,
            actions: [
          const AndroidNotificationAction(
            'take_it',
            'tomar',
          ),
          const AndroidNotificationAction(
            'delay_it',
            'adiar',
          )
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

    successLog("Drug Scheduled to ${scheduledTime.toIso8601String()}");
  }

  Future<void> scheduleMultiple(List<String> hours, int drugId, String drugName,
      double dose, String doseType, List<int> alertsIds) async {
    if (!accepted) {
      warning("notifications not accepted from [schedule multiple]!");
      return;
    }

    if (!initialized) {
      warning("notifications wasn't initialized [schedule multiple]!");
      return;
    }

    DateTime now = DateTime.now();

    for (int i = 0; i < hours.length; i++) {
      final DateTime time = parseStringTime(hours[i]);
      DateTime newDate =
          DateTime(now.year, now.month, now.day, time.hour, time.minute);

      await scheduleDrug(
          newDate, drugId, drugName, dose, doseType, alertsIds[i]);
    }
  }

  Future<void> cancelNotification(int id) async {
    if (!accepted || !initialized) return;
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelMultiple(List<int> ids) async {
    if (!accepted || !initialized) return;

    for (final int id in ids) {
      cancelNotification(id);
    }
  }

  Future<void> showQuantityNotification(int drugId, String drugName) async {
    await setup();
    if (!accepted) {
      warning("notifications not accepted from [showQuantityNotification]!");
      return;
    }

    if (!initialized) {
      warning("notifications wasn't initialized [showQuantityNotification]!");
      return;
    }

    final notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
      'notify_quantity',
      quantityChannel.name,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    ));

    await flutterLocalNotificationsPlugin.show(
        getQuantityNotificationId(drugId),
        'Seu remédio está acabando!',
        "Você precisa comprar mais $drugName. Clique para atualizar a quantidade do remédio.",
        notificationDetails);
  }

  Future<void> scheduleExpiration(
      DateTime time, int drugId, String drugName, int expirationOffset) async {
    await getPermission();
    if (!accepted) {
      warning("notifications not accepted from [scheduleExpiration]!");
      return;
    }

    if (!initialized) {
      warning("notifications wasn't initialized [scheduleExpiration]!");
      return;
    }

    final DateTime timeToExpire = DateTime(time.year, time.month, time.day)
        .subtract(Duration(days: expirationOffset));

    final tz.TZDateTime scheduledTime = tz.TZDateTime.from(
        tz.TZDateTime.from(
            timeToExpire, // EX: use expiration offset to show this notification x days before the expiration
            timeZone),
        timeZone);

    final notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
            'notify_expiration', expirationChannel.name,
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            enableVibration: true));

    await flutterLocalNotificationsPlugin.zonedSchedule(
        getExpirationNotificationId(drugId),
        'Seu remédio venceu',
        "Descarte o $drugName e compre mais. Clique para atualizar a data de vencimento do remédio.",
        scheduledTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
        payload: drugId.toString());
  }
}
