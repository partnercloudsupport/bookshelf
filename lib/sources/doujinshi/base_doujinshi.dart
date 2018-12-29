import 'package:bookshelf/models/model.dart';

abstract class BaseDoujinshiSource {
  Future<SearchDoujinshiResult> searchBooks(String keyword, {int page = 1});
  Future<DoujinshiBook> getBookDetail(String bookId);
}
