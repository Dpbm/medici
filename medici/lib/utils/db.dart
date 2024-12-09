import 'package:medici/datetime_parser.dart';
import 'package:medici/models/alert.dart';
import 'package:medici/models/drug.dart';
import 'package:medici/models/notification_settings.dart';
import 'package:medici/utils/alerts.dart';
import 'package:medici/utils/debug.dart';
import 'package:medici/utils/notifications.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  late Database database;

  Future<void> init() async {
    database = await openDatabase(join(await getDatabasesPath(), 'data.db'),
        onCreate: (db, version) {
      db.execute('''
        CREATE TABLE drug (
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          name TEXT NOT NULL, 
          image TEXT, 
          expiration_date TEXT NOT NULL, 
          last_day INTEGER, 
          quantity REAL NOT NULL, 
          dose_type TEXT NOT NULL, 
          dose REAL NOT NULL, 
          recurrent INTEGER NOT NULL,
          leaflet TEXT,
          status TEXT NOT NULL,
          frequency TEXT NOT NULL,
          starting_time TEXT NOT NULL)
      ''');

      db.execute('''
        CREATE TABLE alert(
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          time TEXT NOT NULL,
          drug_id INTEGER NOT NULL,
          status TEXT NOT NULL,
          last_interaction TEXT NOT NULL,
          FOREIGN KEY(drug_id) REFERENCES drug(id)
        )
      ''');

      db.execute('''
        CREATE TABLE notification(
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          expiration_offset INTEGER NOT NULL,
          quantity_offset INTEGER NOT NULL,
          drug_id INTEGER NOT NULL,
          FOREIGN KEY(drug_id) REFERENCES drug(id)
        )
      ''');
    }, version: 1);
  }

  Future<int> addDrug(Drug drug) async {
    int id = await database.insert('drug', drug.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail);

    return id;
  }

  Future<int> addNotification(NotificationSettings notification) async {
    int id = await database.insert('notification', notification.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail);
    return id;
  }

  Future<List<int>> addAlerts(List<Alert> alerts) async {
    List<int> ids = [];

    for (Alert alert in alerts) {
      int id = await database.insert('alert', alert.toMap(),
          conflictAlgorithm: ConflictAlgorithm.fail);
      ids.add(id);
    }

    return ids;
  }

  Future<List<DrugsScheduling>> getDrugs(
      NotificationService notifications) async {
    final data = await database.rawQuery('''
      SELECT 
        alert.id as alert_id,
        alert.time,
        alert.status as alert_status,
        alert.last_interaction,
        drug.id as drug_id,
        drug.last_day,
        drug.name, 
        drug.image, 
        drug.dose_type, 
        drug.dose,
        drug.status as drug_status,
        drug.quantity,
        drug.recurrent,
        drug.expiration_date,
        notification.expiration_offset
      FROM alert 
      INNER JOIN drug ON drug.id = alert.drug_id
      INNER JOIN notification ON drug.id = notification.drug_id
      WHERE drug.status != 'archived' AND alert.status != 'aware' AND alert.status != 'taken';
    ''');

    List<DrugsScheduling> drugs = [];
    List<int> archivedDrugs = [];

    for (final drug in data) {
      final String? lastDay = drug['last_day'] as String?;
      final int id = drug['drug_id'] as int;
      final int alertId = drug['alert_id'] as int;
      final bool recurrent = (drug['recurrent'] as int) == 1;

      if (archivedDrugs.contains(id)) continue;

      if (!recurrent) {
        try {
          final List<int> alertsIds = data
              .where((drugData) => (drugData['drug_id'] as int) == id)
              .map((drugData) => drugData['alert_id'] as int)
              .toList();

          final bool archived =
              await archiveOnLastDay(lastDay!, notifications, id, alertsIds);

          if (archived) {
            archivedDrugs.add(id);
            successLog("Archived drug $id");
            continue;
          }
        } catch (error) {
          logError(
              "failed on update drug to be archived on last day inside the getDrugs function",
              error.toString());
        }
      }

      final String expirationDate = drug['expiration_date'] as String;
      final int expirationOffset = drug['expiration_offset'] as int;

      final DateParser expirationDateParsed =
          DateParser.fromString(expirationDate);

      if (expirationDateParsed.passedDaysOffset(expirationOffset)) {
        await updateDrugStatus(id, 'expired');
      }

      final String time = drug['time'] as String;
      final String lastInteraction = drug['last_interaction'] as String;
      final String lastStatus = drug['alert_status'] as String;
      String status = lastStatus;

      if (passedTolerance(time)) {
        continue;
      }

      try {
        status =
            await autoUpdateStatus(lastInteraction, alertId, time, lastStatus);
        successLog("Updated alert status from getDrugs");
      } catch (error) {
        logError(
            "Failed on update alert status from getDrugs", error.toString());
      }

      drugs.add(DrugsScheduling(
          id: id,
          name: drug['name'] as String,
          doseType: drug['dose_type'] as String,
          dose: drug['dose'] as double,
          image: drug['image'] as String?,
          status: drug['drug_status'] as String,
          quantity: drug['quantity'] as double,
          alert: Alert(
              id: drug['alert_id'] as int,
              drugId: id,
              status: status,
              time: time,
              lastInteraction: lastInteraction)));
    }

    return drugs;
  }

  Future<bool> archiveOnLastDay(String lastDay,
      NotificationService notifications, int drugId, List<int> alerts) async {
    final DateParser lastDayParsed = DateParser.fromString(lastDay);
    if (!lastDayParsed.isAtMostToday()) {
      simpleLog("$drugId is not on its last day!");
      return false;
    }

    await archiveDrug(drugId);
    await notifications.cancelMultiple(alerts);
    successLog("$drugId archived on last day");

    return true;
  }

  Future<String> autoUpdateStatus(String lastInteraction, int alertId,
      String time, String lastStatus) async {
    final TimeParser parsedLastInteraction =
        TimeParser.fromRaw(lastInteraction);
    if (parsedLastInteraction.isPast()) {
      await updateAlertStatus(alertId, 'pending');
      successLog("Reset the alert status to pending after days!");
      return 'pending';
    }

    if (lastStatus != 'pending') {
      return lastStatus;
    }

    final String newStatus = getAlertStatus(time);
    if (newStatus != 'pending') {
      await updateAlertStatus(alertId, newStatus);
      successLog("Updated alert status on auto update: $newStatus!");
    }

    return newStatus;
  }

  Future<List<DrugTinyData>> getAllDrugs() async {
    final data = await database.query('drug', columns: ['id', 'name', 'image']);

    List<DrugTinyData> drugs = [];
    for (final drug in data) {
      drugs.add(DrugTinyData(
          id: drug['id'] as int,
          name: drug['name'] as String,
          image: drug['image'] as String?));
    }

    successLog("Got tiny drug data!");

    return drugs;
  }

  Future<FullDrug> getFullDrugData(
      int id, NotificationService notifications) async {
    final drugData =
        (await database.query('drug', where: 'id=?', whereArgs: [id])).first;

    final notificationData = (await database
            .query('notification', where: 'drug_id=?', whereArgs: [id]))
        .first;

    final alertsData =
        await database.query('alert', where: 'drug_id=?', whereArgs: [id]);

    final bool recurrent = drugData['recurrent'] == 1;
    final String? lastDay = drugData['last_day'] as String?;
    String drugStatus = drugData['status'] as String;

    final String expirationDate = drugData['expiration_date'] as String;
    final int expirationOffset = notificationData['expiration_offset'] as int;

    final DateParser expirationDateParsed =
        DateParser.fromString(expirationDate);

    if (expirationDateParsed.passedDaysOffset(expirationOffset)) {
      await updateDrugStatus(id, 'expired');
      drugStatus = 'expired';
    }

    if (!recurrent) {
      try {
        final List<int> alertsIds =
            alertsData.map((alert) => alert['id'] as int).toList();

        final bool archived =
            await archiveOnLastDay(lastDay!, notifications, id, alertsIds);

        if (archived) {
          drugStatus = 'archived';
          successLog("Archived drug $id");
        }
      } catch (error) {
        logError(
            "failed on update drug to be archived on last day inside the getFullDrugData function",
            error.toString());
      }
    }

    List<Alert> alerts = [];
    for (final alert in alertsData) {
      final String time = alert['time'] as String;
      final String lastInteraction = alert['last_interaction'] as String;
      final String lastStatus = alert['status'] as String;
      final int alertId = alert['id'] as int;

      String alertStatus = lastStatus;

      try {
        alertStatus =
            await autoUpdateStatus(lastInteraction, alertId, time, lastStatus);
        successLog("Updated alert status from getFullDrugData");
      } catch (error) {
        logError("Failed on update alert status from getFullDrugData",
            error.toString());
      }

      alerts.add(Alert(
          drugId: id,
          lastInteraction: lastInteraction,
          status: alertStatus,
          time: time,
          id: alertId));
    }

    final notification = NotificationSettings(
        drugId: notificationData['drug_id'] as int,
        expirationOffset: notificationData['expiration_offset'] as int,
        quantityOffset: notificationData['quantity_offset'] as int,
        id: notificationData['id'] as int);

    FullDrug drug = FullDrug(
        dose: drugData['dose'] as double,
        doseType: drugData['dose_type'] as String,
        expirationDate: drugData['expiration_date'] as String,
        name: drugData['name'] as String,
        id: id,
        quantity: drugData['quantity'] as double,
        recurrent: drugData['recurrent'] == 1,
        image: drugData['image'] as String?,
        lastDay: drugData['last_day'] as String?,
        leaflet: drugData['leaflet'] as String?,
        status: drugStatus,
        frequency: drugData['frequency'] as String,
        startingTime: drugData['starting_time'] as String,
        notification: notification,
        schedule: alerts);

    successLog("Got all data from drug $id");

    return drug;
  }

  Future<void> deleteDrug(int id) async {
    await database.delete('notification', where: 'drug_id=?', whereArgs: [id]);
    await database.delete('alert', where: 'drug_id=?', whereArgs: [id]);
    await database.delete('drug', where: 'id=?', whereArgs: [id]);

    successLog("Deleted drug $id");
  }

  Future<void> deleteAlerts(int drugId) async {
    await database.delete('alert', where: 'drug_id=?', whereArgs: [drugId]);
  }

  Future<void> deleteNotificationSettings(int drugId) async {
    await database
        .delete('notification', where: 'drug_id=?', whereArgs: [drugId]);
  }

  Future<void> archiveDrug(int id) async {
    await database.update('drug', {'status': 'archived'},
        where: 'id = ?', whereArgs: [id]);

    successLog("Archived drug $id");
  }

  Future<void> unarchiveDrug(int id) async {
    await database.update('drug', {'status': 'current'},
        where: 'id = ?', whereArgs: [id]);

    successLog("UNarchived drug $id");
  }

  Future<void> updateDrug(Drug drug) async {
    await database.update('drug', drug.toMap(),
        where: 'id=?',
        whereArgs: [drug.id],
        conflictAlgorithm: ConflictAlgorithm.fail);

    successLog("Updated drug ${drug.id}");
  }

  Future<void> reduceQuantity(
      int id, int alertId, NotificationService notification) async {
    final alertData = (await database.query('alert',
            columns: ['status'], where: 'id=?', whereArgs: [alertId]))
        .first;

    if (alertData.isEmpty) throw Exception('Invalid Alert data');

    final String status = alertData['status'] as String;
    if (!['late', 'pending'].contains(status)) return;

    final drugData = (await database.query('drug',
            columns: ['quantity', 'dose', 'name'],
            where: 'id=?',
            whereArgs: [id]))
        .first;

    final notificationData = (await database.query('notification',
            columns: ['quantity_offset'], where: 'drug_id=?', whereArgs: [id]))
        .first;

    final String drugName = drugData['name'] as String;
    final double quantity = drugData['quantity'] as double;
    final double dose = drugData['dose'] as double;
    final int quantityOffset = notificationData['quantity_offset'] as int;

    final double updatedQuantity = quantity - dose;
    final double newQuantity = updatedQuantity <= 0 ? 0 : updatedQuantity;

    if (newQuantity <= quantityOffset) {
      await notification.showQuantityNotification(id, drugName);
      await updateDrugStatus(id, 'refill');
    }

    await database.update('drug', {'quantity': newQuantity},
        where: 'id=?',
        whereArgs: [id],
        conflictAlgorithm: ConflictAlgorithm.fail);
  }

  Future<void> refillDrugAmount(int id, double amount) async {
    await database.update('drug', {'quantity': amount},
        where: 'id=?', whereArgs: [id]);
  }

  Future<void> updateAlertStatus(int id, String status) async {
    await database.update(
        'alert',
        {
          'status': status,
          'last_interaction': DateTime.now().toIso8601String()
        },
        where: 'id=?',
        whereArgs: [id],
        conflictAlgorithm: ConflictAlgorithm.fail);

    successLog("Updated alert $id status to $status!");
  }

  Future<void> updateDrugStatus(int id, String status) async {
    await database.update('drug', {'status': status},
        where: 'id=?',
        whereArgs: [id],
        conflictAlgorithm: ConflictAlgorithm.fail);

    successLog("Updated drug $id status to $status");
  }

  Future<void> close() async {
    database.close();
  }
}
