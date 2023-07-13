
import 'package:mobile/app/database/open_database.dart';
import 'package:mobile/app/models/user.dart';
import 'package:sqflite/sqflite.dart';

class UserDao {
  create(User user) async {
    final Database db = await getDatabase();

    db.insert('USERS',  user.toMap());
  }

  Future<List<User>> getUsers() async {
    final Database db = await getDatabase();

    final List<Map<String, dynamic>> maps = await db.query('Users');

    return List.generate(maps.length, (index) {
      return User(
        id: maps[index]['id'],
        name: maps[index]['name'],
        email: maps[index]['email'],
      );
    });
  }
}