import 'package:bookshelf/sources/source.dart';

abstract class MangaSource extends BaseMangaSource {
  Future<bool> login(String account, String password);
  Future<List<String>> getFavoriteBooks();
}
