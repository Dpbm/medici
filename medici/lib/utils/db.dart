import 'package:medici/models/alert.dart';
import 'package:medici/models/drug.dart';
import 'package:medici/models/notification_settings.dart';
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
          status TEXT NOT NULL)
      ''');

      db.execute('''
        CREATE TABLE alert(
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          time TEXT,
          drug_id INTEGER,
          FOREIGN KEY(drug_id) REFERENCES drug(id)
        )
      ''');

      db.execute('''
        CREATE TABLE notification(
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          expiration_offset INTEGER,
          quantity_offset INTEGER,
          drug_id INTEGER,
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
        alert.id,
        alert.time,
        alert.drug_id,
        drug.name, 
        drug.image, 
        drug.dose_type, 
        drug.dose,
        drug.status
      FROM alert 
      INNER JOIN drug ON drug.id = alert.drug_id
      WHERE drug.status != "archived";
    ''');

    List<DrugsScheduling> drugs = [];
    for (final drug in data) {
      drugs.add(DrugsScheduling(
          id: drug['id'] as int,
          drugId: drug['drug_id'] as int,
          time: drug['time'] as String,
          name: drug['name'] as String,
          doseType: drug['dose_type'] as String,
          dose: drug['dose'] as double,
          image: drug['image'] as String?,
          status: drug['status'] as String));
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
      schedule.add(Alert(
          drugId: alert['drug_id'] as int,
          time: alert['time'] as String,
          id: alert['id'] as int));
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
        notification: notification,
        schedule: schedule);
  }

  Future<void> deleteDrug(int id) async {
    await getDB();

    await database!.delete('notification', where: 'drug_id=?', whereArgs: [id]);
    await database!.delete('alert', where: 'drug_id=?', whereArgs: [id]);
    await database!.delete('drug', where: 'id=?', whereArgs: [id]);
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
}
