import 'package:mobile/app/database/open_database.dart';
import 'package:sqflite/sqflite.dart';

class ConfigDao {
  create(bool isDarkMode) async {
    final Database db = await getDatabase();
    final darkMode = await db.rawQuery("SELECT darkmode FROM config");
    final Map<String, dynamic> data = {'darkmode': isDarkMode ? 1 : 0};

    if (darkMode.isEmpty || darkMode.first['darkmode'] == null) {
      await db.insert('config', data,
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      await db.update('config', data);
    }
  }

  Future<bool> getDarkMode() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('config');

    if (maps.isNotEmpty) {
      final bool darkMode = maps.first['darkmode'] == 1;

      return darkMode;
    }

    return false;
  }
}
