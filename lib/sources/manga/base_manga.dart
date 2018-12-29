abstract class BaseMangaSource {
  Future<List<String>> searchBooks(String keyword, {int page = 1});
  Future<Map> getBookDetail(String bookId);
  Future<List<String>> getChapterContent(String bookId, String chapterId);
}
