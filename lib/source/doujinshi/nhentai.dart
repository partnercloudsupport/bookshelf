import 'dart:async';
import 'dart:convert';

import 'package:bookshelf/source/doujinshi/doujinshi.dart';
import 'package:bookshelf/util/constant.dart';
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
    String url = baseUrl + '/api/galleries/search?query=$keyword&page=$order';
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
          'title': res['title']['japanese'],
          'status': lang,
          'coverurl': 'https://t.nhentai.net/galleries/'
              + res['media_id'].toString()
              + '/thumb'
              + (res['images']['thumbnail']['t'] == 'j' ? '.jpg' : '.png'),
          'coverurl_header': {'Referer': 'http://nhentai.net'},
          'authors': authors,
          'types': tags,
          'last_chapter': group,
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
      Map response = JSON.decode((await http.get(url, headers: headers)).body);

      return {
        'title': response['title'],
        'description': response['description'],
        'coverurl': response['cover'],
        'coverurl_header': {'Referer': 'http://nhentai.net'},
        'chapters': '',
        'types': response['types'].map((Map type) {
          return type['tag_name'];
        }).toList(),
        'status': response['status'][0]['tag_name'],
        'authors': response['authors'].map((Map type) {
          return type['tag_name'];
        }).toList(),
        'last_updatetime': response['upload_date'],
      };
    } catch (_) {
      return null;
    }
  }

  @override
  getChapterContent(String bid, String cid) {
  }
}
