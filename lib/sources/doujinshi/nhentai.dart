import 'dart:io' show ContentType;

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:dio/dio.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as htmlDom;

import 'package:bookshelf/sources/source.dart';
import 'package:bookshelf/models/model.dart';

class NHentaiSource extends DoujinshiSource {
  static String sourceId = 'nhentai';
  final String sourceName = 'nhentai';
  final String baseUrl = 'https://nhentai.net';

  @override
  Future<SearchDoujinshiResultModel> searchBooks(String keyword,
      {int page = 1}) async {
    keyword = keyword.replaceAll(' ', '+');
    String searchUrl =
        '$baseUrl/api/galleries/search?query=$keyword&page=$page';

    Response searchResponse = await client.get(searchUrl);
    List searchResult = searchResponse.data['result'];
    int totalPages = searchResponse.data['num_pages'];

    List<DoujinshiBookModel> books = searchResult.map((res) {
      List<String> parodies = [];
      List<String> characters = [];
      List<String> tags = [];
      List<String> artists = [];
      List<String> groups = [];
      List<String> languages = [];
      List<String> categories = [];
      for (Map tag in res['tags']) {
        switch (tag['type'].toString()) {
          case 'parody':
            parodies.add(tag['name'].toString());
            break;
          case 'character':
            characters.add(tag['name'].toString());
            break;
          case 'tag':
            tags.add(tag['name'].toString());
            break;
          case 'artist':
            artists.add(tag['name'].toString());
            break;
          case 'group':
            groups.add(tag['name'].toString());
            break;
          case 'language':
            languages.add(tag['name'].toString());
            break;
          case 'category':
            categories.add(tag['name'].toString());
            break;
          default:
            tags.add(tag['name'].toString());
        }
      }

      return DoujinshiBookModel(
        bookId: res['id'].toString(),
        name: res['title']['english'].toString(),
        originalName: res['title']['japanese'].toString(),
        source: this,
        coverUrl: 'https://t.nhentai.net/galleries/' +
            res["media_id"].toString() +
            '/thumb' +
            (res['images']['thumbnail']['t'].toString() == 'j'
                ? '.jpg'
                : '.png'),
        parodies: parodies,
        characters: characters,
        tags: tags,
        artists: artists,
        groups: groups,
        languages: languages,
        categories: categories,
        uploadDate: DateTime.fromMillisecondsSinceEpoch(
            int.parse(res['upload_date'].toString() + '000')),
      );
    }).toList();

    return SearchDoujinshiResultModel(
      source: this,
      result: books,
      totalPages: totalPages,
    );
  }

  @override
  Future<DoujinshiBookModel> getBookDetail(String bookId) async {
    String bookUrl = '$baseUrl/api/gallery/$bookId';

    Map bookResult = (await client.get(bookUrl)).data;
    List<String> parodies = [];
    List<String> characters = [];
    List<String> tags = [];
    List<String> artists = [];
    List<String> groups = [];
    List<String> languages = [];
    List<String> categories = [];
    for (Map tag in bookResult['tags']) {
      switch (tag['type'].toString()) {
        case 'parody':
          parodies.add(tag['name'].toString());
          break;
        case 'character':
          characters.add(tag['name'].toString());
          break;
        case 'tag':
          tags.add(tag['name'].toString());
          break;
        case 'artist':
          artists.add(tag['name'].toString());
          break;
        case 'group':
          groups.add(tag['name'].toString());
          break;
        case 'language':
          languages.add(tag['name'].toString());
          break;
        case 'category':
          categories.add(tag['name'].toString());
          break;
        default:
          tags.add(tag['name'].toString());
      }
    }
    List<String> previewPages = [];
    List<String> pages = [];

    int count = 0;
    bookResult['images']['pages'].forEach((page) {
      count += 1;
      previewPages.add('https://t.nhentai.net/galleries/' +
          bookResult["media_id"].toString() +
          '/${count}t' +
          (page['t'].toString() == 'j' ? '.jpg' : '.png'));
      pages.add('https://i.nhentai.net/galleries/' +
          bookResult["media_id"].toString() +
          '/$count' +
          (page['t'].toString() == 'j' ? '.jpg' : '.png'));
    });

    return DoujinshiBookModel(
      bookId: bookResult['id'].toString(),
      name: bookResult['title']['english'].toString(),
      originalName: bookResult['title']['japanese'].toString(),
      source: this,
      coverUrl: 'https://t.nhentai.net/galleries/' +
          bookResult["media_id"].toString() +
          '/cover' +
          (bookResult['images']['cover']['t'].toString() == 'j'
              ? '.jpg'
              : '.png'),
      parodies: parodies,
      characters: characters,
      tags: tags,
      artists: artists,
      groups: groups,
      languages: languages,
      categories: categories,
      uploadDate: DateTime.fromMillisecondsSinceEpoch(
          int.parse(bookResult['upload_date'].toString() + '000')),
      previewPages: previewPages,
      pages: pages,
    );
  }

  @override
  Future<bool> login(String account, String password) async {
    String loginUrl = '$baseUrl/login/';
    final Map<String, String> loginHeaders = {'referer': loginUrl};

    if ((await client.get(baseUrl)).data.toString().contains('/$account')) {
      debugPrint('Token valid.');
      return true;
    } else {
      debugPrint('Token outdated.');
    }

    Response csrfResponse = await client.get(loginUrl);
    String csrfToken = htmlParser
        .parse(csrfResponse.data)
        .querySelectorAll('input')
        .where((htmlDom.Node el) {
          return el.attributes['name'] == 'csrfmiddlewaretoken';
        })
        .first
        .attributes['value'];

    Map<String, String> loginPayload = {
      'csrfmiddlewaretoken': csrfToken,
      'username_or_email': account,
      'password': password,
    };
    Response loginResponse = await client
        .post(
      loginUrl,
      data: loginPayload,
      options: Options(
        contentType: ContentType.parse("application/x-www-form-urlencoded"),
        headers: loginHeaders,
        validateStatus: (int statusCode) => statusCode < 400,
      ),
    )
        .catchError((e) {
      if (e is DioError &&
          e.response != null &&
          e.response.data.toString().contains('CSRF Token Invalid'))
        throw Exception('CSRF Token Invalid.');
      throw e;
    });
    if (loginResponse.data
        .toString()
        .contains('Invalid username (or email) or password'))
      throw Exception(
          'Invalid username (or email) or password. Make sure you capitalize it correctly.');
    if ((await client.get(baseUrl)).data.toString().contains('/$account')) {
      debugPrint('Login successful.');
      return true;
    } else {
      debugPrint('Login failed.');
      return false;
    }
  }

  @override
  Future<List<DoujinshiBookModel>> getFavoriteBooks() async {
    String favoriteUrl = '$baseUrl/favorites/';
    final Map<String, String> favoriteHeaders = {'referer': baseUrl};

    Response favoriteResponse = await client.get(favoriteUrl,
        options: Options(headers: favoriteHeaders));
    htmlDom.Element countElement =
        htmlParser.parse(favoriteResponse.data).querySelector('span.count');
    if (countElement == null) throw Exception('Need login.');

    int count =
        int.parse(countElement.text.replaceAll('(', '').replaceAll(')', ''));
    int pages = (count / 25).ceil();
    List<String> favoriteBookIds = [];

    for (int page in List<int>.generate(pages, (i) => i + 1)) {
      Response currentFavoriteResponse;
      if (page == 1)
        currentFavoriteResponse = favoriteResponse;
      else
        currentFavoriteResponse = await client.get('$favoriteUrl?page=$page',
            options: Options(headers: favoriteHeaders));
      favoriteBookIds.addAll(htmlParser
          .parse(currentFavoriteResponse.data)
          .querySelectorAll(
              '#favcontainer > div.gallery-favorite > div.gallery > a.cover')
          .map((htmlDom.Node el) =>
              el.attributes['href'].replaceAll('/g/', '').replaceAll('/', '')));
    }

    List<DoujinshiBookModel> favoriteBooks = [];
    for (String bookId in favoriteBookIds) {
      favoriteBooks.add(await this.getBookDetail(bookId));
    }

    return favoriteBooks;
  }
}
