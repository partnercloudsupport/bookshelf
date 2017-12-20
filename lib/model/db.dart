import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';

class DB {
  Database _db;

  init() async {
    Directory _path = await getApplicationDocumentsDirectory();
    String _dbPath = join(_path.path, 'bookshelf_database.db');
    _db = await ioDatabaseFactory.openDatabase(_dbPath);
  }

  get(String key) async {
    try { return await _db.get(key); } catch (_) {}
  }
  set(String key, var value) async {
    try { return await _db.put(value, key); } catch (_) {}
  }
  remove(String key) async {
    try { return await _db.delete(key); } catch (_) {}
  }
}
