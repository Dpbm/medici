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
          quantity NUMERIC NOT NULL, 
          dose_type TEXT NOT NULL, 
          dose NUMERIC NOT NULL, 
          recurrent INTEGER NOT NULL,
          leaflet TEXT)
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

  Future<List<Drug>> getDrugs() async {
    await getDB();

    final data = await database!.query('drug');
    print(data);
    return [
      for (final {
            'id': id as int,
            'dose': dose as double,
            'dose_type': doseType as String,
            'expiration_date': expirationDate as String,
            'name': name as String,
            'quantity': quantity as double,
            'recurrent': recurrent as bool,
            'image': image as String?,
            'last_day': lastDay as String?,
            'leaflet': leaflet as String?
          } in data)
        Drug(
            id: id,
            dose: dose,
            doseType: doseType,
            expirationDate: expirationDate,
            name: name,
            quantity: quantity,
            recurrent: recurrent,
            image: image,
            lastDay: lastDay,
            leaflet: leaflet)
    ];
  }
}
