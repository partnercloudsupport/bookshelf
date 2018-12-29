import 'package:bookshelf/sources/source.dart';

class DmzjSource extends MangaSource {
  @override
  Future<List<String>> searchBooks(String keyword, {int page = 1}) {
    return null;
  }

  @override
  Future<Map> getBookDetail(String bookId) {
    return null;
  }

  @override
  Future<List<String>> getChapterContent(String bookId, String chapterId) {
    return null;
  }

  @override
  Future<bool> login(String account, String password) {
    return null;
  }

  @override
  Future<List<String>> getFavoriteBooks() {
    return null;
  }
}
