import 'dart:io';

class GlobalVar {
  static final GlobalVar _singleton = GlobalVar._internal();

  factory GlobalVar() => _singleton;

  GlobalVar._internal();

  Directory tempPath;
}
