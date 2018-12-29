import 'package:flutter/foundation.dart';

import 'package:bookshelf/sources/doujinshi/doujinshi.dart';

class DoujinshiBook {
  DoujinshiBook({
    this.bookId,
    this.name,
    this.originalName,
    this.source,
    this.coverUrl,
    this.parodies,
    this.characters,
    this.tags,
    this.artists,
    this.groups,
    this.languages,
    this.categories,
    this.uploadDate,
    this.previewPages,
    this.pages,
  });

  final String bookId;
  final String name;
  final String originalName;
  final DoujinshiSource source;
  final String coverUrl;
  final List<String> parodies;
  final List<String> characters;
  final List<String> tags;
  final List<String> artists;
  final List<String> groups;
  final List<String> languages;
  final List<String> categories;
  final DateTime uploadDate;
  final List<String> previewPages;
  final List<String> pages;
}

class SearchDoujinshiResult {
  SearchDoujinshiResult({
    @required this.result,
    @required this.isLastPage,
  });

  final List<DoujinshiBook> result;
  final bool isLastPage;
}
