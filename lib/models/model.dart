import 'package:meta/meta.dart';

export 'package:bookshelf/models/manga.dart';
export 'package:bookshelf/models/doujinshi.dart';

enum BookType {
  Manga,
  Doujinshi,
  Illustration,
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
