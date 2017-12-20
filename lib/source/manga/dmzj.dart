import 'dart:convert';

import 'package:bookshelf/source/api_parser.dart';
import 'package:bookshelf/util/constant.dart';
import 'package:http/http.dart' as http;

class MangaDmzj extends ApiParser {
  final String parserName = 'manga_dmzj';
  final String baseUrl = 'http://v2.api.dmzj.com';
  final int versionId = 1;
  final String mainLang = 'cn';
  final Map headers = ua;

  @override
  searchBooks(String keyword) async {
    String url = baseUrl + '/search/show/0/$keyword/0.json';
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
        'type': 'manga'
      });
    }).toList();
  }

  @override
  getBookdetail(String bid) async {
    String url = baseUrl + '/comic/$bid.json';
    Map response = JSON.decode((await http.get(url, headers: headers)).body);
    List<Map> chapters = response['chapters'][0]['data'].map((Map chapter) {
      return {
        'chapter_id': chapter['chapter_id'].toString(),
        'chapter_title': chapter['chapter_title'],
      };
    }).toList();

    return {
      'title': response['title'],
      'description': response['description'],
      'coverurl': response['cover'],
      'coverurl_header': {'Referer': 'http://v2.api.dmzj.com'},
      'chapters': chapters,
      'types': response['types'].map((Map type) {
        return type['tag_name'];
      }).toList(),
      'status': response['status'][0]['tag_name'],
      'authors': response['authors'].map((Map type) {
        return type['tag_name'];
      }).toList(),
      'last_updatetime': response['last_updatetime'],
    };
  }

  @override
  getChaptercontent(String bid, String cid) async {
    String url = baseUrl + '/chapter/$bid/$cid.json';
    Map response = JSON.decode((await http.get(url, headers: headers)).body);
    return {
      'picture_urls': response['page_url'],
      'picture_header': {'Referer': 'http://v2.api.dmzj.com'},
    };
  }

//  getRecommend() {
//    String url = baseUrl + '/v3/recommend.json';
//    Map response = httpGet(url, headers);
//    List info = response[1]['data'];
//    info.map((Map data) {
//      return {
//        'title': data['title'],
//        'id': data['obj_id'],
//        'type': data['type'],
//      };
//    }).toList();
//  }

}
