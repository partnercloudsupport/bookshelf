import 'dart:async';
import 'dart:convert';

import 'package:bookshelf/source/novel/novel.dart';
import 'package:bookshelf/util/constant.dart';
import 'package:http/http.dart' as http;

class NovelDmzj extends NovelParser {
  final String parserName = 'novel_dmzj';
  final String baseUrl = 'http://v2.api.dmzj.com';
  final int versionId = 1;
  final String mainLang = 'cn';
  final Map headers = ua;
  final String type = 'novel';

  @override
  Future<List> searchBooks(String keyword, [int order=0]) async {
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
  Future<Map> getBookDetail(String bid) async {
    String urlBook = baseUrl + '/novel/$bid.json';
    String urlChapter = baseUrl + '/novel/chapter/$bid.json';
    Map responseBook = JSON.decode((await http.get(urlBook, headers: headers)).body);
    List responseChapter = JSON.decode((await http.get(urlChapter, headers: headers)).body);
    List<Map> chapters = responseChapter.map((Map volume) {
      String vid = volume['volume_id'].toString();
      return {
        'volume_title': volume['volume_name'].trim(),
        'chapters': volume['chapters'].map((Map chapter) {
          return {
            'volume_id': vid,
            'chapter_id': chapter['chapter_id'],
            'chapter_title': chapter['chapter_name'].trim()
          };
        }).toList()};
    }).toList();

    return {
      'title': responseBook['name'],
      'description': responseBook['introduction'],
      'coverurl': responseBook['cover'],
      'coverurl_header': {'Referer': 'http://v2.api.dmzj.com'},
      'chapters': chapters,
      'types': [responseBook['types'][0].replaceAll('/', '  ')],
      'status': responseBook['status'],
      'authors': [responseBook['authors']],
      'last_updatetime': responseBook['last_update_time'],
    };
  }

  @override
  Future<String> getChapterContent(String bid, String vid ,String cid) async {
    String url = baseUrl + '/novel/download/$bid\_$vid\_$cid.txt';
    return (UTF8.decode((await http.get(url)).bodyBytes)
      .replaceAll('&nbsp;', ' ')
      .replaceAll('<br />', '')
      .replaceAll('<br/>', '\n')
      .replaceAll('&hellip;', '…')
      .replaceAll('&mdash;', '—')
//      .replaceAll(new RegExp('<img\s*|\s*src=[\'"]\s*|\s*alt=[\'"]\d*\w*\s*[\'"]\s*|[\'"] *\/>'), '')
//      .replaceAll(new RegExp('width=[\'"][0|1|2|3|4|5|6|7|8|9|0]*[\'"]'), '')
//      .replaceAll(new RegExp('height=[\'"][0|1|2|3|4|5|6|7|8|9|0]*[\'"]'), '')
      .trim()
    );
  }
}
