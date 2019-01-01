import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

import 'package:bookshelf/blocs/bloc.dart';
import 'package:bookshelf/views/shelf.dart';
import 'package:bookshelf/utils/global_var.dart';

main() {
  FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
  FlutterStatusbarcolor.setNavigationBarColor(Colors.blue);

  BlocSupervisor().delegate = SimpleBlocDelegate();

  getTemporaryDirectory().then((Directory dir) => GlobalVar().tempPath = dir);

  runApp(BookshelfApp());
}
