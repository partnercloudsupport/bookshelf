// import 'dart:io' show ContentType;

// import 'package:flutter/foundation.dart' show debugPrint;
import 'package:dio/dio.dart';
// import 'package:html/parser.dart' as htmlParser;
// import 'package:html/dom.dart' as htmlDom;

import 'package:bookshelf/sources/source.dart';
import 'package:bookshelf/models/model.dart';

class EHentaiSource extends DoujinshiSource {
  final String sourceName = 'E-Hentai';
  final String baseUrl = 'https://e-hentai.org';

  @override
  Future<SearchDoujinshiResultModel> searchBooks(String keyword, {int page = 1}) {
    return null;
  }

  @override
  Future<DoujinshiBookModel> getBookDetail(String bookId) {
    return null;
  }

  @override
  Future<bool> login(String account, String password) {
    return null;
  }

  @override
  Future<List<DoujinshiBookModel>> getFavoriteBooks() {
    return null;
  }
}
