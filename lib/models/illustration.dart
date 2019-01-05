import 'package:meta/meta.dart';

import 'package:bookshelf/models/model.dart';
import 'package:bookshelf/sources/source.dart';

class IllustrationBookModel {
  IllustrationBookModel({
    this.bookId,
  });

  final String bookId;
}

class SearchIllustrationResultModel {
  SearchIllustrationResultModel({
    @required this.source,
    @required this.result,
    @required this.totalPages,
  });

  final BaseDoujinshiSource source;
  final List<IllustrationBookModel> result;
  final int totalPages;
}

class IllustrationSourceModel {
  IllustrationSourceModel({
    @required this.source,
    this.enable = true,
    this.filter,
  });

  final BaseDoujinshiSource source;
  final bool enable;
  final List<FilterModel> filter;
}
