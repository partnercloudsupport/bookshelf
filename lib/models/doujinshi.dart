import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:bookshelf/models/model.dart';
import 'package:bookshelf/sources/source.dart';

class DoujinshiBookModel extends Equatable {
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
  }) : super([
          bookId,
          name,
          originalName,
          source,
        ]);

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

class SearchDoujinshiResultModel extends Equatable {
  SearchDoujinshiResultModel({
    @required this.source,
    @required this.result,
    @required this.totalPages,
  }) : super([
          source,
          result,
          totalPages,
        ]);

  final BaseDoujinshiSource source;
  final List<DoujinshiBookModel> result;
  final int totalPages;
}

class DoujinshiSourceModel extends Equatable {
  DoujinshiSourceModel({
    @required this.source,
    this.enable = true,
    this.filter,
  }) : super([
          source,
          enable,
          filter,
        ]);

  final BaseDoujinshiSource source;
  final bool enable;
  final List<FilterModel> filter;
}
