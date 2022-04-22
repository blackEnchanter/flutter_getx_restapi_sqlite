import 'package:flutter_getx_restapi_sqlite/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbData {
  static Future<DbData> init() async {
    final aux = DbData();
    await aux._init();
    return aux;
  }

  late final Database db;

  Future<void> _init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'user.db');
    db = await openDatabase(path, version: 2,
        onCreate: (Database newDb, int version) async {
      await newDb.execute('''
          CREATE TABLE user
          (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            lastName TEXT,
            city TEXT,
            thumbnail TEXT
          )
        ''');
    });
  }

  Future<int> save(User toSave) {
    return db.insert(
      'user',
      toSave.toMapForDb(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> delete(User toDelete) {
    return db.delete(
      'user',
      where: 'name = ? AND lastName = ?',
      whereArgs: [toDelete.name, toDelete.lastName],
    );
  }

  Future<List<User>> getAllUsers() async {
    const query =
        'SELECT user.name, user.lastName, user.city, user.thumbnail FROM user';
    final queryResult = await db.rawQuery(query);
    return queryResult.map((e) => User.fromMap(e)).toList();
  }
}
