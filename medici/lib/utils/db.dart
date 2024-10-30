import 'package:medici/models/drug.dart';
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
          recurrent BOOL NOT NULL,
          leaflet TEXT)
      ''');

      db.execute('''
        CREATE TABLE alert(
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          time INTEGER,
          drug_id INTEGER,
          FOREIGN KEY(drug_id) REFERENCES drug(id)
        )
      ''');

      db.execute('''
        CREATE TABLE notification(
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          expiration_offset INTEGER,
          quantity_offset NUMERIC,
          drug_id INTEGER,
          FOREIGN KEY(drug_id) REFERENCES drug(id)
        )
      ''');
    }, version: 1);
  }

  Future<void> addDrug(Drug drug) async {
    await getDB();

    await database!.insert('drug', drug.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail);
  }
}
