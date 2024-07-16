import 'dart:async';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  late Database database;

  Future<void> initDB() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'food.db'),
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE Users(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, username TEXT, password TEXT, name TEXT, email TEXT, gender TEXT, phoneNumber TEXT)');
        await db.execute(
            'CREATE TABLE Event(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title TEXT, description TEXT)');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion == 2) {
          await db.execute(
              'CREATE TABLE Comment(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, text TEXT)');
        }
      },
      version: 3,
    );
  }
}
