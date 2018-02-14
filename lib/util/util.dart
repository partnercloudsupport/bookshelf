import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:bookshelf/database/db.dart';
import 'package:bookshelf/util/eventbus.dart';
import 'package:crypto/crypto.dart';
import 'package:quiver/collection.dart';
import 'package:flutter_keepscreenon/flutter_keepscreenon.dart';
import 'package:shared_preferences/shared_preferences.dart';

Color invertColor(Color color) {
  return new Color.fromARGB(color.alpha, 255-color.red, 255-color.green, 255-color.blue);
}
String uid(String str) {
  return md5.convert(UTF8.encode(str)).toString().toLowerCase().substring(0, 9);
}
String fileSize(int size, [int round = 2, bool decimal = false]){
  /// from filesize.dart
  int divider = 1024;
  size = int.parse(size.toString());
  if(decimal) divider = 1000;
  if(size < divider) return size.toString() + "B";
  if(size < divider*divider && size % divider == 0) return "${(size/divider).toStringAsFixed(0)}KB";
  if(size < divider*divider) return "${(size/divider).toStringAsFixed(round)} KB";
  if(size < divider*divider*divider && size % divider == 0) return "${(size/(divider*divider)).toStringAsFixed(0)}MB";
  if(size < divider*divider*divider) return "${(size/divider/divider).toStringAsFixed(round)}MB";
  if(size < divider*divider*divider*divider && size % divider == 0) { return "${(size/(divider*divider*divider)).toStringAsFixed(0)}GB"; }
  else return "${(size/divider/divider/divider).toStringAsFixed(round)}GB";
}

Future<bool> activateKeepAwake() async {
  try {
    await FlutterKeepscreenon.activateKeepScreenOn;
    return true;
  } on PlatformException catch (e) {
    print(e.message);
    return false;
  }
}
Future<bool> deactivateKeepAwake() async {
  try {
    await FlutterKeepscreenon.deactivateKeepScreenOn;
    return true;
  } on PlatformException catch (e) {
    print(e.message);
    return false;
  }
}

LruMap networkRequestCache = new LruMap(maximumSize: 512);
Db defaultDb = new Db(() { bus.fire('reload_bookshelf'); });
Future<SharedPreferences> sharedPreferences = SharedPreferences.getInstance();
