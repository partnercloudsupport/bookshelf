import 'package:meta/meta.dart';

import 'package:bookshelf/models/model.dart';
import 'package:bookshelf/sources/source.dart';

class DoujinshiBookModel {
  DoujinshiBookModel({
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

class SearchDoujinshiResultModel {
  SearchDoujinshiResultModel({
    @required this.source,
    @required this.result,
    @required this.totalPages,
  });

  final BaseDoujinshiSource source;
  final List<DoujinshiBookModel> result;
  final int totalPages;
}

class DoujinshiSourceModel {
  DoujinshiSourceModel({
    @required this.source,
    this.enable = true,
    this.filter,
  });

  final BaseDoujinshiSource source;
  final bool enable;
  final List<FilterModel> filter;
}
