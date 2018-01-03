import 'dart:convert';
import 'dart:ui';

import 'package:bookshelf/dababase/db.dart';
import 'package:bookshelf/util/eventbus.dart';
import 'package:crypto/crypto.dart';
import 'package:quiver/collection.dart';

Color invertColor(Color color) {
  return new Color.fromARGB(color.alpha, 255-color.red, 255-color.green, 255-color.blue);
}
String uid(String str) {
  return md5.convert(UTF8.encode(str)).toString().toLowerCase().substring(0, 9);
}

LruMap networkRequestCache = new LruMap(maximumSize: 512);

Db defaultDb = new Db(() => bus.post('reload_bookshelf'));
