import 'package:medici/models/alert.dart';
import 'package:medici/models/drug.dart';
import 'package:medici/models/notification_settings.dart';
import 'package:medici/utils/alerts.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  Database? database;

  Future<void> getDB() async {
    if (database != null) return;

    database = await openDatabase(join(await getDatabasesPath(), 'data.db'),
        onCreate: (db, version) {
      db.execute('''
        CREATE TABLE drug (
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          name TEXT NOT NULL, 
          image TEXT, 
          expiration_date INTEGER NOT NULL, 
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
    await getDB();

    int id = await database!.insert('drug', drug.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail);

    return id;
  }

  Future<int> addNotification(NotificationSettings notification) async {
    await getDB();

    int id = await database!.insert('notification', notification.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail);
    return id;
  }

  Future<void> addAlerts(List<Alert> alerts) async {
    await getDB();

    for (Alert alert in alerts) {
      await database!.insert('alert', alert.toMap(),
          conflictAlgorithm: ConflictAlgorithm.fail);
    }
  }

  Future<List<DrugsScheduling>> getDrugs() async {
    await getDB();

    final data = await database!.rawQuery('''
      SELECT 
        alert.id as alert_id,
        alert.time,
        alert.status as alert_status,
        drug.id as drug_id,
        drug.name, 
        drug.image, 
        drug.dose_type, 
        drug.dose,
        drug.status as drug_status,
        drug.quantity
      FROM alert 
      INNER JOIN drug ON drug.id = alert.drug_id
      WHERE drug.status != "archived" && alert.status != "aware" && alert.status != "taken";
    ''');

    List<DrugsScheduling> drugs = [];
    for (final drug in data) {
      final int id = drug['drug_id'] as int;
      final int alertId = drug['alert_id'] as int;
      final String time = drug['time'] as String;
      final String status = getAlertStatus(time);

      await updateAlertStatus(alertId, status);

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
              time: time)));
    }

    return drugs;
  }

  Future<List<DrugsScheduling>> getAllDrugs() async {
    await getDB();

    final data = await database!.rawQuery('''
      SELECT 
        alert.id,
        alert.time,
        alert.drug_id,
        drug.name, 
        drug.image, 
        drug.dose_type, 
        drug.dose,
        drug.status,
        drug.quantity
      FROM alert 
      INNER JOIN drug ON drug.id = alert.drug_id;
    ''');

    List<DrugsScheduling> drugs = [];
    for (final drug in data) {
      drugs.add(DrugsScheduling(
          id: drug['drug_id'] as int,
          name: drug['name'] as String,
          doseType: drug['dose_type'] as String,
          dose: drug['dose'] as double,
          image: drug['image'] as String?,
          status: drug['status'] as String,
          quantity: drug['quantity'] as double,
          alert: Alert(
              drugId: drug['drug_id'] as int,
              status: drug['status'] as String,
              time: drug['time'] as String,
              id: drug['id'] as int)));
    }

    return drugs;
  }

  Future<FullDrug> getFullDrugData(int id) async {
    await getDB();

    final drug_data =
        (await database!.query('drug', where: 'id=?', whereArgs: [id])).first;
    final notification_data = (await database!
            .query('notification', where: 'drug_id=?', whereArgs: [id]))
        .first;
    final alerts_data =
        await database!.query('alert', where: 'drug_id=?', whereArgs: [id]);

    final notification = NotificationSettings(
        drugId: notification_data['drug_id'] as int,
        expirationOffset: notification_data['expiration_offset'] as int,
        quantityOffset: notification_data['quantity_offset'] as int,
        id: notification_data['id'] as int);
    List<Alert> schedule = [];
    for (final alert in alerts_data) {
      final int alertId = alert['id'] as int;
      final String time = alert['time'] as String;
      final String status = getAlertStatus(time);

      await updateAlertStatus(alertId, status);

      schedule.add(Alert(
          drugId: alert['drug_id'] as int, time: time, id: id, status: status));
    }

    return FullDrug(
        dose: drug_data['dose'] as double,
        doseType: drug_data['dose_type'] as String,
        expirationDate: drug_data['expiration_date'] as String,
        name: drug_data['name'] as String,
        id: id,
        quantity: drug_data['quantity'] as double,
        recurrent: drug_data['recurrent'] == 1,
        image: drug_data['image'] as String?,
        lastDay: drug_data['last_day'] as String?,
        leaflet: drug_data['leaflet'] as String?,
        status: drug_data['status'] as String,
        frequency: drug_data['frequency'] as String,
        startingTime: drug_data['starting_time'] as String,
        notification: notification,
        schedule: schedule);
  }

  Future<void> deleteDrug(int id) async {
    await getDB();

    await database!.delete('notification', where: 'drug_id=?', whereArgs: [id]);
    await database!.delete('alert', where: 'drug_id=?', whereArgs: [id]);
    await database!.delete('drug', where: 'id=?', whereArgs: [id]);
  }

  Future<void> deleteAlerts(int drugId) async {
    await getDB();
    await database!.delete('alert', where: 'drug_id=?', whereArgs: [drugId]);
  }

  Future<void> deleteNotificationSettings(int drugId) async {
    await getDB();
    await database!
        .delete('notification', where: 'drug_id=?', whereArgs: [drugId]);
  }

  Future<void> archiveDrug(int id) async {
    await getDB();

    await database!.update('drug', {'status': 'archived'},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<void> unarchiveDrug(int id) async {
    await getDB();

    await database!.update('drug', {'status': 'current'},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateDrug(Drug drug) async {
    await getDB();

    await database!.update('drug', drug.toMap(),
        where: 'id=?',
        whereArgs: [drug.id],
        conflictAlgorithm: ConflictAlgorithm.fail);
  }

  Future<void> updateAlertStatus(int id, String status) async {
    await getDB();

    await database!.update('alert', {'id': id, 'status': status},
        where: 'id=?',
        whereArgs: [id],
        conflictAlgorithm: ConflictAlgorithm.fail);
  }
}
