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
import 'package:medici/utils/notifications.dart';

@pragma('vm:entry-point')
Future<void> notificationTapBackground(NotificationResponse response) async {
  final DB tmpDb = DB();

  final String? action = response.actionId;
  final String? drugId = response.payload;

  final int? alertId = response.id;
  final int? drugIdInt = drugId != null ? int.parse(drugId) : null;

  if (action != null &&
      action.isNotEmpty &&
      drugIdInt != null &&
      alertId != null) {
    try {
      switch (action) {
        case 'take_it':
          await tmpDb.reduceQuantity(drugIdInt, alertId);
          await tmpDb.updateAlertStatus(drugIdInt, 'taken');
          break;

        case 'delay_it':
          await tmpDb.updateAlertStatus(drugIdInt, 'late');
          break;

        default:
          break;
      }
    } catch (error) {
      debugPrint("Failed on update alert status!");
    }
  }

  tmpDb.close();
}

final NotificationService notifications = NotificationService();
final DB db = DB();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await notifications.init(notificationTapBackground);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final double heightMarginTop = MediaQuery.of(context).padding.top;
    final double height = MediaQuery.of(context).size.height - heightMarginTop;
    final double width = MediaQuery.of(context).size.width;

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      title: 'Medici',
      debugShowCheckedModeBanner: false,
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
