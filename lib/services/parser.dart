import 'package:meta/meta.dart';

import 'package:bookshelf/sources/source.dart';
import 'package:bookshelf/models/model.dart';

abstract class SearchService {}

class MangaSearchService extends SearchService {
  MangaSearchService({
    this.keyword,
    this.sources,
    this.searchBooksType,
  });

  final String keyword;
  final List<BaseMangaSource> sources;
  final BookType searchBooksType;
}

class DoujinshiSearchService extends SearchService {
  DoujinshiSearchService({
    @required this.keyword,
    @required this.sources,
    this.page = 1,
  });

  final String keyword;
  final List<BaseDoujinshiSource> sources;
  final int page;

  List<Map<BaseDoujinshiSource, int>> pageLimit = [];

  Future<List<DoujinshiBookModel>> search() async {
    List<DoujinshiBookModel> books = [];

    for (BaseDoujinshiSource source in sources) {
      if (pageLimit
              .where((value) =>
                  (value.keys.first == source) && value.values.first < page)
              .length >
          0) {
      } else {
        SearchDoujinshiResultModel searchResult =
            await source.searchBooks(keyword, page: page);
        books.addAll(searchResult.result);
        pageLimit.add({source: searchResult.totalPages});
      }
    }

    return books;
  }
}
