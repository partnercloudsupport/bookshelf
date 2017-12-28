abstract class ApiParser {
  String baseUrl;
  int versionId;
  String mainLang;

  searchBooks(String keyword);

  getBookDetail(String bid);

  getChapterContent(String bid, String cid);

}
