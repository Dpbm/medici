import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medici/add.dart';
import 'package:medici/drug.dart';
import 'package:medici/drugs_list.dart';
import 'package:medici/edit.dart';
import 'package:medici/home.dart';
import 'package:medici/models/drug.dart';
import 'package:medici/utils/db.dart';
import 'package:medici/utils/debug.dart';
import 'package:medici/utils/notifications.dart';
import 'package:medici/utils/notifications_ids.dart';

Future<void> takeMed(NotificationResponse response, DB db) async {
  final String? action = response.actionId;
  final String? drugId = response.payload;

  final int? alertId = response.id;
  final int? drugIdInt = drugId != null ? int.parse(drugId) : null;

  final NotificationService tmpNotifications =
      NotificationService(notificationTapBackground);

  simpleLog("In TakeMed");

  if (action != null &&
      action.isNotEmpty &&
      drugIdInt != null &&
      alertId != null) {
    try {
      switch (action) {
        case 'take_it':
          simpleLog("Take Action!");
          await db.reduceQuantity(drugIdInt, alertId, tmpNotifications);
          await db.updateAlertStatus(alertId, 'taken');
          simpleLog("taken");
          break;

        case 'delay_it':
          simpleLog("Delay Action!");
          await db.updateAlertStatus(alertId, 'aware');
          simpleLog("delayed");
          break;

        default:
          break;
      }
    } catch (error) {
      logError("failed on Take med", error as Exception);
    }
  }

  db.close();
}

Future<void> navigateToEdit(int id, DB db) async {
  simpleLog("Getting data to edit");

  final int drugId = id.abs().isEven
      ? getInverseQuantityNotification(id)
      : getInverseExpirationNotification(id);
  final FullDrug drug = await db.getFullDrugData(drugId);
  await db.close();

  simpleLog("Navigate to Edit");
  App.navigateToEditBackgroundTask(drug);
}

@pragma('vm:entry-point')
Future<void> notificationTapBackground(NotificationResponse response) async {
  final int parsedId = response.id ?? 0;
  final DB tmpDb = DB();

  simpleLog("Called entry point with id $parsedId");

  if (parsedId >= 0) {
    await takeMed(response, tmpDb);
  } else {
    await navigateToEdit(parsedId, tmpDb);
  }
}

final NotificationService notifications =
    NotificationService(notificationTapBackground);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await notifications.init();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final DB db = DB();

  static void navigateToEditBackgroundTask(FullDrug drug) {
    navigatorKey.currentState?.pushNamed('edit', arguments: {'drug': drug});
  }

  @override
  Widget build(BuildContext context) {
    final double heightMarginTop = MediaQuery.of(context).padding.top;
    final double height = MediaQuery.of(context).size.height - heightMarginTop;
    final double width = MediaQuery.of(context).size.width;

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      title: 'Medici',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xF2F1E9),
        primary: const Color(0x063E42),
        secondary: const Color(0x90DCC7),
      )),
      initialRoute: 'home',
      routes: {
        'home': (context) => Home(
            width: width, height: height, db: db, notifications: notifications),
        'add': (context) => Add(
            width: width, height: height, db: db, notifications: notifications),
        'list': (context) => DrugsList(height: height, width: width, db: db),
        'edit': (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>;
          return EditDrug(
              width: width,
              height: height,
              db: db,
              drug: args['drug'] as FullDrug,
              notifications: notifications);
        },
        'drug': (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>;
          return DrugPage(
              width: width,
              height: height,
              db: db,
              id: args['id'] as int,
              notifications: notifications);
        }
      },
    );
  }
}
