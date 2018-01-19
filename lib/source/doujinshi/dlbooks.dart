import 'dart:async';
import 'dart:convert';

import 'package:bookshelf/source/doujinshi/doujinshi.dart';
import 'package:bookshelf/util/constant.dart';
import 'package:http/http.dart' as http;

class DoujinshiDlbooks extends DoujinshiParser {
  final String parserName = 'doujinshi_dlbooks';
  final String baseUrl = 'http://dlbooks.to';
  final int versionId = 1;
  final String mainLang = 'ja';
  final Map headers = ua;
  final String type = 'doujinshi';

  @override
  searchBooks(String keyword, [int order=0]) async {
  }

  @override
  getBookDetail(String bid) async {
  }

  @override
  getChapterContent(String bid, String cid) async {
  }
}
