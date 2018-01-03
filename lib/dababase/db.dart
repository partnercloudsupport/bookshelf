import 'dart:io';

import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';

class Db {
  Database db;

  Db([Function f]) {
    getApplicationDocumentsDirectory().then((Directory _path) {
      String _dbPath = join(_path.path, 'bookshelf_database.db');
      ioDatabaseFactory.openDatabase(_dbPath).then((Database _db) {
        db = _db;
        if (f != null) f(); // ignore: invocation_of_non_function
      });
    });
  }

  get(String key) async {
    try { return await db.get(key); } catch (_) {}
  }
  set(String key, var value) async {
    try { return await db.put(value, key); } catch (_) {}
  }
  remove(String key) async {
    try { return await db.delete(key); } catch (_) {}
  }
}
