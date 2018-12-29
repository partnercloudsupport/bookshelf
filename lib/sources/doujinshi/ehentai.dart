import 'dart:io' show ContentType;

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as htmlDom;

import 'package:bookshelf/sources/source.dart';
import 'package:bookshelf/models/model.dart';

class EHentaiSource extends DoujinshiSource {
  static String sourceName = 'E-Hentai';
  final String baseUrl = 'https://e-hentai.org';
  final Dio client = Dio()..cookieJar = PersistCookieJar();

  @override
  Future<SearchDoujinshiResult> searchBooks(String keyword, {int page = 1}) {
    return null;
  }

  @override
  Future<DoujinshiBook> getBookDetail(String bookId) {
    return null;
  }

  @override
  Future<bool> login(String account, String password) {
    return null;
  }

  @override
  Future<List<DoujinshiBook>> getFavoriteBooks() {
    return null;
  }
}
