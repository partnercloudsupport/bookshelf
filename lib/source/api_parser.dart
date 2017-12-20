abstract class ApiParser {
  String baseUrl;
  int versionId;
  String mainLang;

  searchBooks(String keyword);

  getBookdetail(String bid);

  getChaptercontent(String bid, String cid);

}
