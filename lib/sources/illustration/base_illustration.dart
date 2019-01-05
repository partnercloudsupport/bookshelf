import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';

import 'package:bookshelf/models/model.dart';
import 'package:bookshelf/utils/global_var.dart';

abstract class BaseIllustrationSource {
  final String sourceName = '';
  final String baseUrl = '';
  final Dio client = Dio()..cookieJar = PersistCookieJar(GlobalVar().tempPath.path + '/.cookies/');

  Future<SearchIllustrationResultModel> searchBooks(String keyword, {int page = 1});
  Future<IllustrationBookModel> getBookDetail(String bookId);
}
