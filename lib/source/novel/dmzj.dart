import 'dart:convert';

import 'package:bookshelf/source/novel/novel.dart';
import 'package:bookshelf/util/constant.dart';
import 'package:bookshelf/util/util.dart';
import 'package:http/http.dart' as http;

class NovelDmzj extends NovelParser {
  final String parserName = 'novel_dmzj';
  final String baseUrl = 'http://v2.api.dmzj.com';
  final int versionId = 1;
  final String mainLang = 'cn';
  final Map headers = ua;
  final String type = 'manga';

  @override
  searchBooks(String keyword, [int order=0]) async {
    String url = baseUrl + '/search/show/1/$keyword/$order.json';
    List response = JSON.decode((await http.get(url, headers: headers)).body);
    return response.map((Map<String, String> res) {
      return ({
        'id': res['id'].toString(),
        'title': res['title'],
        'status': res['status'],
        'coverurl': res['cover'],
        'coverurl_header': {'Referer': 'http://v2.api.dmzj.com'},
        'authors': res['authors'],
        'types': res['types'],
        'last_chapter': res['last_name'],
        'parser': parserName,
        'type': type
      });
    }).toList();
  }

  @override
  getBookDetail(String bid) async {
    String urlBook = baseUrl + '/novel/$bid.json';
    String urlChapter = baseUrl + '/novel/chapter/$bid.json';
    Map responseBook = JSON.decode((await http.get(urlBook, headers: headers)).body);
    List responseChapter = JSON.decode((await http.get(urlChapter, headers: headers)).body);
    List<Map> chapters = responseChapter.map((Map volume) {
      String vid = volume['volume_id'];
      return volume['chapters'].map((Map chapter) {
        return {
          'book_id': bid,
          'volume_id': vid,
          'chapter_id': chapter['chapter_id'],
          'chapter_title': chapter['chapter_name']
        };
      }).toList();
    }).toList();

    return {
      'title': responseBook['name'],
      'description': responseBook['introduction'],
      'coverurl': responseBook['cover'],
      'coverurl_header': {'Referer': 'http://v2.api.dmzj.com'},
      'chapters': chapters,
      'types': responseBook['types'][0],
      'status': responseBook['status'][0]['tag_name'],
      'authors': responseBook['authors'],
      'last_updatetime': responseBook['last_update_time'],
    };
  }

  @override
  getChapterContent(String bid, String vid ,String cid) {
    
  }
}
