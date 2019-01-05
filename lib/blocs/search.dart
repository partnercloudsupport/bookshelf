import 'package:bloc/bloc.dart';

import 'package:bookshelf/models/model.dart';
import 'package:bookshelf/services/parser.dart';
import 'package:bookshelf/sources/source.dart';

class SearchBloc extends Bloc<_SearchEvent, SearchBlocState> {
  @override
  SearchBlocState get initialState => SearchBlocState.init();

  @override
  Stream<SearchBlocState> mapEventToState(
      SearchBlocState currentState, _SearchEvent event) async* {
    if (event is SetCurrentSearchShelf)
      yield currentState.copyWith(
        currentSearchShelf: event.currentSearchShelf,
      );
    if (event is SetSearchHistory)
      yield currentState.copyWith(
        searchHistory: event.history,
      );
    if (event is SetSearchRefresh)
      yield currentState.copyWith(
        refresh: event.refresh,
      );
    if (event is SearchResult) {
      String keyword = event.keyword ?? currentState.history[0];

      switch (currentState.currentSearchShelf) {
        case BookType.Manga:
          Map<BaseMangaSource, List<MangaBookModel>> result = {};
          this.dispatch(SetSearchRefresh(false));
          yield currentState.copyWith(mangaResult: result);
          break;

        case BookType.Doujinshi:
          List<SearchDoujinshiResultModel> searchResult =
              await DoujinshiSearchService(
            keyword: keyword,
            sources: <BaseDoujinshiSource>[
              NHentaiSource(),
            ],
          ).search();
          Map<BaseDoujinshiSource, List<DoujinshiBookModel>> result = {};
          Map<BaseDoujinshiSource, SearchState> state = {};
          Map<BaseDoujinshiSource, SearchPageModel> page = {};
          for (SearchDoujinshiResultModel res in searchResult) {
            result[res.source] = res.result;
            page[res.source] =
                SearchPageModel(currentPage: 1, totalPages: res.totalPages);
            if (res.totalPages > 1)
              state[res.source] = SearchState.Idle;
            else
              state[res.source] = SearchState.IsEnd;
          }
          yield currentState.copyWith(
            doujinshiResult: result,
            doujinshiState: state,
            doujinshiPage: page,
            refresh: false,
          );
          break;

        case BookType.Illustration:
          this.dispatch(SetSearchRefresh(false));
          break;

        default:
          break;
      }
    }
    if (event is SetLoadMoreState) {
      if (event.source is BaseMangaSource) {
      } else if (event.source is BaseDoujinshiSource) {
        if (currentState.doujinshiState.containsKey(event.source) &&
            (currentState.doujinshiState[event.source] == SearchState.Idle)) {
          currentState.doujinshiState[event.source] = SearchState.IsLoading;
          this.dispatch(SearchMoreDoujinshi(event.source));
          yield currentState.copyWith();
        }
      } else if (event.source is BaseIllustrationSource) {}
    }
    if (event is SearchMoreManga) {}
    if (event is SearchMoreDoujinshi) {
      int nextPage = currentState.doujinshiPage[event.source].currentPage + 1;
      if (nextPage <= currentState.doujinshiPage[event.source].totalPages ||
          currentState.doujinshiState[event.source] != SearchState.IsEnd) {
        SearchDoujinshiResultModel searchResult = (await DoujinshiSearchService(
          keyword: currentState.history[0],
          sources: <BaseDoujinshiSource>[
            event.source,
          ],
          page: nextPage,
        ).search())[0];

        var result = currentState.doujinshiResult;
        result[event.source].addAll(searchResult.result);

        var state = currentState.doujinshiState;
        state[event.source] = nextPage >= searchResult.totalPages
            ? SearchState.IsEnd
            : SearchState.Idle;

        var page = currentState.doujinshiPage;
        page[event.source] = SearchPageModel(
          currentPage: nextPage,
          totalPages: searchResult.totalPages,
        );

        yield currentState.copyWith();

        // var result = Map.from(currentState.doujinshiResult);
        // var books = List.from(result[event.source]);
        // books.addAll(searchResult.result);
        // result[event.source] = books;

        // var state = Map.from(currentState.doujinshiState);
        // state[event.source] = nextPage >= searchResult.totalPages
        //     ? SearchState.IsEnd
        //     : SearchState.Idle;

        // var page = Map.from(currentState.doujinshiPage);
        // page[event.source] = SearchPageModel(
        //   currentPage: nextPage,
        //   totalPages: searchResult.totalPages,
        // );

        // yield currentState.copyWith(
        //   doujinshiResult: result,
        //   doujinshiState: state,
        //   doujinshiPage: page,
        // );
      }
    }
    if (event is SearchMoreIllustration) {}
  }
}

class SearchBlocState {
  SearchBlocState({
    this.currentSearchShelf,
    this.history,
    this.refresh,
    this.mangaResult,
    this.doujinshiResult,
    this.illustrationResult,
    this.mangaState,
    this.doujinshiState,
    this.illustrationState,
    this.mangaPage,
    this.doujinshiPage,
    this.illustrationPage,
  });

  final BookType currentSearchShelf;
  final List<String> history;
  final Map<BaseMangaSource, List<MangaBookModel>> mangaResult;
  final Map<BaseDoujinshiSource, List<DoujinshiBookModel>> doujinshiResult;
  final Map<BaseIllustrationSource, List<IllustrationBookModel>>
      illustrationResult;
  final bool refresh;
  final Map<BaseMangaSource, SearchState> mangaState;
  final Map<BaseDoujinshiSource, SearchState> doujinshiState;
  final Map<BaseIllustrationSource, SearchState> illustrationState;
  final Map<BaseMangaSource, SearchPageModel> mangaPage;
  final Map<BaseDoujinshiSource, SearchPageModel> doujinshiPage;
  final Map<BaseIllustrationSource, SearchPageModel> illustrationPage;

  factory SearchBlocState.init() {
    return SearchBlocState(
      currentSearchShelf: BookType.Manga,
      history: [],
      mangaResult: {},
      doujinshiResult: {},
      illustrationResult: {},
      refresh: false,
      mangaState: {},
      doujinshiState: {},
      illustrationState: {},
      mangaPage: {},
      doujinshiPage: {},
      illustrationPage: {},
    );
  }

  SearchBlocState copyWith({
    BookType currentSearchShelf,
    List<String> searchHistory,
    Map<BaseMangaSource, List<MangaBookModel>> mangaResult,
    Map<BaseDoujinshiSource, List<DoujinshiBookModel>> doujinshiResult,
    Map<BaseIllustrationSource, List<IllustrationBookModel>> illustrationResult,
    bool refresh,
    Map<BaseMangaSource, SearchState> mangaState,
    Map<BaseDoujinshiSource, SearchState> doujinshiState,
    Map<BaseIllustrationSource, SearchState> illustrationState,
    Map<BaseMangaSource, SearchPageModel> mangaPage,
    Map<BaseDoujinshiSource, SearchPageModel> doujinshiPage,
    Map<BaseIllustrationSource, SearchPageModel> illustrationPage,
  }) {
    return SearchBlocState(
      currentSearchShelf: currentSearchShelf ?? this.currentSearchShelf,
      history: searchHistory ?? this.history,
      mangaResult: mangaResult ?? this.mangaResult,
      doujinshiResult: doujinshiResult ?? this.doujinshiResult,
      illustrationResult: illustrationResult ?? this.illustrationResult,
      refresh: refresh ?? this.refresh,
      mangaState: mangaState ?? this.mangaState,
      doujinshiState: doujinshiState ?? this.doujinshiState,
      illustrationState: illustrationState ?? this.illustrationState,
      mangaPage: mangaPage ?? this.mangaPage,
      doujinshiPage: doujinshiPage ?? this.doujinshiPage,
      illustrationPage: illustrationPage ?? this.illustrationPage,
    );
  }

  @override
  bool operator ==(
    Object other,
  ) =>
      identical(
        this,
        other,
      ) ||
      other is SearchBlocState &&
          runtimeType == other.runtimeType &&
          currentSearchShelf == other.currentSearchShelf &&
          history == other.history &&
          mangaResult == other.mangaResult &&
          doujinshiResult == other.doujinshiResult &&
          illustrationResult == other.illustrationResult &&
          refresh == other.refresh &&
          mangaState == other.mangaState &&
          doujinshiState == other.doujinshiState &&
          illustrationState == other.illustrationState &&
          mangaPage == other.mangaPage &&
          doujinshiPage == other.doujinshiPage &&
          illustrationPage == other.illustrationPage;

  @override
  int get hashCode =>
      currentSearchShelf.hashCode ^
      history.hashCode ^
      mangaResult.hashCode ^
      doujinshiResult.hashCode ^
      illustrationResult.hashCode ^
      refresh.hashCode ^
      mangaState.hashCode ^
      doujinshiState.hashCode ^
      illustrationState.hashCode ^
      mangaPage.hashCode ^
      doujinshiPage.hashCode ^
      illustrationPage.hashCode;

  @override
  String toString() => '''SearchBlocState {
        currentSearchShelf: $currentSearchShelf,
        history: $history,
        mangaResult: $mangaResult,
        doujinshiResult: $doujinshiResult,
        illustrationResult: $illustrationResult,
        refresh: $refresh,
        mangaState: $mangaState,
        doujinshiState: $doujinshiState,
        illustrationState: $illustrationState,
        mangaPage: $mangaPage,
        doujinshiPage: $doujinshiPage,
        illustrationPage: $illustrationPage,
      }''';
}

abstract class _SearchEvent {}

class SetCurrentSearchShelf extends _SearchEvent {
  SetCurrentSearchShelf(this.currentSearchShelf);

  final BookType currentSearchShelf;
}

class SetSearchHistory extends _SearchEvent {
  SetSearchHistory(this.history);

  final List<String> history;
}

class SetSearchRefresh extends _SearchEvent {
  SetSearchRefresh(this.refresh);

  final bool refresh;
}

class SetLoadMoreState extends _SearchEvent {
  SetLoadMoreState(this.source);

  final dynamic source;
}

class SearchResult extends _SearchEvent {
  SearchResult([this.keyword]);

  final String keyword;
}

class SearchMoreManga extends _SearchEvent {
  SearchMoreManga(this.source);

  final BaseMangaSource source;
}

class SearchMoreDoujinshi extends _SearchEvent {
  SearchMoreDoujinshi(this.source);

  final BaseDoujinshiSource source;
}

class SearchMoreIllustration extends _SearchEvent {
  SearchMoreIllustration(this.source);

  final BaseIllustrationSource source;
}
