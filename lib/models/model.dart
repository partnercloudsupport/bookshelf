import 'package:meta/meta.dart';

export 'package:bookshelf/models/manga.dart';
export 'package:bookshelf/models/doujinshi.dart';
export 'package:bookshelf/models/illustration.dart';

enum BookType {
  Manga,
  Doujinshi,
  Illustration,
}

enum SearchState {
  Idle,
  IsLoading,
  IsEnd,
}

class SearchPageModel {
  SearchPageModel({
    @required this.currentPage,
    @required this.totalPages,
  });

  final int currentPage;
  final int totalPages;
}

class FilterModel {
  FilterModel({
    @required this.tag,
    this.exclude = false,
    this.enable = true,
  });

  final String tag;
  final bool exclude;
  final bool enable;
}
