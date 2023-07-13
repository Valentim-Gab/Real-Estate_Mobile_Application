import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'db');

  return openDatabase(
    path,
    onCreate: (db, version) async {
      await db.execute('''CREATE TABLE USERS (id INTEGER PRIMARY KEY, name TEXT,
          email TEXT, password TEXT)''');

      try {
        await db.execute('''CREATE TABLE SESSION (access_token TEXT)''');
      } catch (e) {
        debugPrint('Erro ao criar a tabela SESSION: $e');
      }

      try {
        await db.execute('''CREATE TABLE config (darkmode boolean)''');
      } catch (e) {
        debugPrint('Erro ao criar a tabela SESSION: $e');
      }
    },
    version: 2,
    onUpgrade: (db, oldVersion, newVersion) async {
      try {
        await db.execute('''CREATE TABLE SESSION (access_token TEXT)''');
      } catch (e) {
        debugPrint('Erro ao criar a tabela SESSION: $e');
      }

      try {
        await db.execute('''CREATE TABLE config (darkmode boolean)''');
      } catch (e) {
        debugPrint('Erro ao criar a tabela SESSION: $e');
      }
    },
  );
}
