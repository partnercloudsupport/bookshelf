import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:equatable/equatable.dart';

import 'package:bookshelf/models/model.dart';
import 'package:bookshelf/utils/global_var.dart';

abstract class BaseDoujinshiSource extends Equatable {
  BaseDoujinshiSource()
      : super([
          sourceId,
        ]);

  static String sourceId = '';
  final String sourceName = '';
  final String baseUrl = '';
  final Dio client = Dio()
    ..cookieJar = PersistCookieJar(GlobalVar().tempPath.path + '/.cookies/');

  Future<SearchDoujinshiResultModel> searchBooks(String keyword,
      {int page = 1});
  Future<DoujinshiBookModel> getBookDetail(String bookId);
}
