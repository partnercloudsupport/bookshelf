import 'package:meta/meta.dart';

import 'package:bookshelf/sources/manga/manga.dart';

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
    @required this.result,
    @required this.lastPage,
  });

  final List<MangaBookModel> result;
  final bool lastPage;
}
