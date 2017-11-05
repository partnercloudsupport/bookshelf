import 'package:bookshelf/source/api_parser.dart';
import 'package:bookshelf/network/request.dart';
import 'package:bookshelf/util/constant.dart';

class Dmzj extends ApiParser {
  final String baseUrl = 'http://v2.api.dmzj.com';
  final int versionId = 1;
  final String mainLang = 'cn';
  Map headers = ua;

  @override
  searchBooks(String keyword) {
    String url = baseUrl + '/search/show/0/$keyword/0.json';
    Map info = httpGet(url, headers);
    return {
      'id': info['id'],
      'title': info['title'],
      'status': info['status'],
      'cover': info['cover'],
      'authors': info['authors'],
      'types': info['types']
    };
  }

  @override
  getBookdetail(String bid) {
    String url = baseUrl + '/comic/$bid.json';
    Map info = httpGet(url, headers);
    List<Map> chaptersInfo = info['chapters']['data'];
    List<Map> chapters;
    chaptersInfo.map((Map chapter) {
      chapters.add({
        'chapter_id': chapter['chapter_id'],
        'chapter_title': chapter['chapter_title'],
      });
    });

    return {
      'description': info['description'],
      'chapters': chapters,
    };
  }

  @override
  getChaptercontent(String bid, String cid) {
    String url = baseUrl + '/chapter/$bid/$cid.json';
    Map info = httpGet(url, headers);
    return {
      'page_url': info['page_url']
    };
  }

  @override
  checkUpdate() {
  }
}
