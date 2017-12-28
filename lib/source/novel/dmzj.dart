import 'package:bookshelf/source/api_parser.dart';
import 'package:bookshelf/util/constant.dart';

class NovelDmzj extends ApiParser {
  final String baseUrl = 'http://v2.api.dmzj.com';
  final int versionId = 1;
  final String mainLang = 'cn';
  Map headers = ua;

  @override
  getBookDetail(String bid) {
    // TODO: implement getBookdetail
  }

  @override
  getChapterContent(String bid, String cid) {
    // TODO: implement getChaptercontent
  }

  @override
  searchBooks(String keyword) {
    // TODO: implement searchBooks
  }
}
