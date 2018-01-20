import 'dart:async';
import 'dart:convert';

import 'package:bookshelf/source/manga/manga.dart';
import 'package:bookshelf/util/constant.dart';
import 'package:bookshelf/util/util.dart';
import 'package:http/http.dart' as http;

class MangaDmzj extends MangaParser {
  final String parserName = 'manga_dmzj';
  final String baseUrl = 'http://v2.api.dmzj.com';
  final int versionId = 1;
  final String mainLang = 'cn';
  final Map headers = ua;
  final String type = 'manga';

  @override
  Future<List> searchBooks(String keyword, [int order=0]) async {
    String url = baseUrl + '/search/show/0/$keyword/$order.json';
    try {
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
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Map> getBookDetail(String bid) async {
    String url = baseUrl + '/comic/$bid.json';
    Map response = JSON.decode((await http.get(url, headers: headers)).body);
    try {
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
        'parser': parserName,
        'type': type
      };
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Map> getChapterContent(String bid, String cid) async {
    String url = baseUrl + '/chapter/$bid/$cid.json';
    String uId = uid(url);
    Map response = {};
    try {
      if (networkRequestCache != null && networkRequestCache.containsKey(uId)) {
        response = networkRequestCache[uId];
      } else {
        response = JSON.decode((await http.get(url, headers: headers)).body);
        networkRequestCache[uId] = response;
      }
      return {
        'picture_urls': response['page_url'],
        'picture_header': {'Referer': 'http://v2.api.dmzj.com'},
      };
    } catch (_) {
      return null;
    }
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
