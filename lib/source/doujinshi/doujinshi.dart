import 'package:bookshelf/source/parser.dart';

abstract class DoujinshiParser extends Parser {
  String baseUrl;
  int versionId;
  String mainLang;

  searchBooks(String keyword);

  getBookDetail(String bid);

  getChapterContent(String bid, String cid);

}
