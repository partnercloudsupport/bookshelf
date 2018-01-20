import 'dart:async';
import 'dart:convert';

import 'package:bookshelf/source/doujinshi/doujinshi.dart';
import 'package:bookshelf/util/constant.dart';
import 'package:bookshelf/util/util.dart';
import 'package:http/http.dart' as http;

class DoujinshiNhentai extends DoujinshiParser {
  final String parserName = 'doujinshi_nhentai';
  final String baseUrl = 'https://nhentai.net';
  final int versionId = 1;
  final String mainLang = 'multi';
  final Map headers = ua;
  final String type = 'doujinshi';

  @override
  Future<List> searchBooks(String keyword, [int order=0]) async {
    keyword = keyword.replaceAll(' ', '+');
    order += 1;
    String url = baseUrl + '/api/galleries/search?query=$keyword&language=japanese+chinese&page=$order';
    try {
      List response = JSON.decode((await http.get(url, headers: headers)).body)['result'];
      return response.map((Map res) {
        String lang = '';
        String authors = '';
        String tags = '';
        String group = '';
        for (Map tag in res['tags']) {
          if (tag['type'] == 'language' && tag['name'] != 'translated') {
            lang = (tag['name'] ?? '');
          } else if (tag['type'] == 'artist') {
            authors = authors + tag['name'] + ' ';
          } else if (tag['type'] == 'tag') {
            tags = tags + tag['name'] + ' ';
          } else if (tag['type'] == 'group') {
            group = group + tag['name'] + ' ';
          }
        }
        return ({
          'id': res['id'].toString(),
          'title': res['title']['japanese'] ?? res['title']['english'],
          'status': (lang.length > 0) ? ('语言: ' + lang) : '',
          'coverurl': 'https://t.nhentai.net/galleries/'
              + res['media_id'].toString()
              + '/thumb'
              + (res['images']['thumbnail']['t'] == 'j' ? '.jpg' : '.png'),
          'coverurl_header': {'Referer': 'http://nhentai.net'},
          'authors': (authors.length > 0) ? ('作者: ' + authors) : '',
          'types': (tags.length > 0) ? ('标签: ' + tags) : '',
          'last_chapter': (group.length > 0) ? ('社团: ' + group) : '',
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
    String url = baseUrl + '/api/gallery/$bid';
    try {
      String uId = uid(url);
      Map response = {};
      if (networkRequestCache != null && networkRequestCache.containsKey(uId)) {
        response = networkRequestCache[uId];
      } else {
        response = JSON.decode((await http.get(url, headers: headers)).body);
        networkRequestCache[uId] = response;
      }
      String lang = '';
      List authors = [];
      String tags = '';
      List group = [];
      for (Map tag in response['tags']) {
        if (tag['type'] == 'language' && tag['name'] != 'translated') {
          lang = (tag['name'] ?? '');
        } else if (tag['type'] == 'artist') {
          authors.add(tag['name']);
        } else if (tag['type'] == 'tag') {
          tags = tags + tag['name'] + '  ';
        } else if (tag['type'] == 'group') {
          group.add(tag['name']);
        }
      }

      return {
        'title': response['title']['japanese'] ?? response['title']['english'],
        'description': (lang.length > 0) ? ('标签: ' + tags) : '',
        'coverurl': 'https://t.nhentai.net/galleries/'
              + response['media_id'].toString()
              + '/cover'
              + (response['images']['cover']['t'] == 'j' ? '.jpg' : '.png'),
        'coverurl_header': {'Referer': 'http://nhentai.net'},
        'chapters': [{
          'chapter_id': bid,
          'chapter_title': '1话',
        }],
        'types': (lang.length > 0) ? (['语言:', lang]) : [],
        'status': '',
        'authors': (authors.length > 0) ? (new List.from(['作者:'])..addAll(authors)) : [],
        'last_updatetime': response['upload_date'],
        'parser': parserName,
        'type': type
      };
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Map> getChapterContent(String bid, String cid) async {
    String url = baseUrl + '/api/gallery/$bid';
    try {
      String uId = uid(url);
      Map response = {};
      if (networkRequestCache != null && networkRequestCache.containsKey(uId)) {
        response = networkRequestCache[uId];
      } else {
        response = JSON.decode((await http.get(url, headers: headers)).body);
        networkRequestCache[uId] = response;
      }
      int pageNum = 0;
      return {
        'picture_urls': response['images']['pages'].map((Map page) {
          pageNum += 1;
          return 'https://i.nhentai.net/galleries/'
              + response['media_id']
              + '/'
              + pageNum.toString()
              + (page['t'] == 'j' ? '.jpg' : '.png');
        }).toList(),
        'picture_header': {'Referer': 'http://nhentai.net'},
      };
    } catch (_) {
      return null;
    }
  }
}
