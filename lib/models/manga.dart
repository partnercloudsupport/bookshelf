import 'package:flutter/foundation.dart';

import 'package:bookshelf/sources/manga/manga.dart';

class MangaBook {
  MangaBook(
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

class SearchMangaResult {
  SearchMangaResult({
    @required this.result,
    @required this.lastPage,
  });

  final List<MangaBook> result;
  final bool lastPage;
}
