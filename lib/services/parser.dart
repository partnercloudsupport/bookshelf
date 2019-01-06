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
  Future<List<SearchDoujinshiResultModel>> search({
    @required String keyword,
    @required List<BaseDoujinshiSource> sources,
    int page = 1,
  }) async {
    List<SearchDoujinshiResultModel> result = [];

    for (BaseDoujinshiSource source in sources) {
      SearchDoujinshiResultModel searchResult =
          await source.searchBooks(keyword, page: page);
      if (searchResult.result.length > 0) result.add(searchResult);
    }

    return result;
  }

  Future<DoujinshiBookModel> getDetail({
    @required BaseDoujinshiSource source,
    @required String bookId,
  }) async {
    return await source.getBookDetail(bookId);
  }
}
