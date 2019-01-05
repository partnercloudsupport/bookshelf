import 'package:meta/meta.dart';

import 'package:bookshelf/sources/source.dart';
import 'package:bookshelf/models/model.dart';

class MangaBookModel {
  MangaBookModel(
    this.name,
    this.source,
    this.chapters,
    this.pages,
  );

  final String name;
  final MangaSource source;
  final List<String> chapters;
  final List<String> pages;
}

class SearchMangaResultModel {
  SearchMangaResultModel({
    @required this.source,
    @required this.result,
    @required this.totalPages,
  });

  final BaseMangaSource source;
  final List<MangaBookModel> result;
  final int totalPages;
}

class MangaSourceModel {
  MangaSourceModel({
    @required this.source,
    this.enable = true,
    this.filter,
  });

  final BaseMangaSource source;
  final bool enable;
  final List<FilterModel> filter;
}
