import 'package:flutter/material.dart';

import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:bloc/bloc.dart';

import 'package:bookshelf/blocs/bloc.dart';
import 'package:bookshelf/views/shelf.dart';

main() {
  FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
  FlutterStatusbarcolor.setNavigationBarColor(Colors.blue);
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(BookshelfApp());
}
