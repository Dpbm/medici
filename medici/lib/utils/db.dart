import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDB() async {
  final database = openDatabase(join(await getDatabasesPath(), 'data.db'),
      onCreate: (db, version) {
    db.execute(
      '''
        CREATE TABLE drug (
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          name TEXT NOT NULL, 
          image TEXT, 
          expiration_date INTEGER, 
          quantity NUMERIC, 
          dose_type TEXT, 
          dose NUMERIC, 
          leaflet TEXT)
      ''');

    db.execute(
      '''
        CREATE TABLE alert(
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          time INTEGER,
          drug_id INTEGER,
          FOREIGN KEY(drug_id) REFERENCES drug(id)
        )
      ''');

    db.execute(
      '''
        CREATE TABLE notification(
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          expiration_offset INTEGER,
          quantity_offset NUMERIC,
          drug_id INTEGER,
          FOREIGN KEY(drug_id) REFERENCES drug(id)
        )
      ''');
  }, version: 1);

  return database;
}
