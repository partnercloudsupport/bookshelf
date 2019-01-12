import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

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
    if (event is SetHistory)
      yield currentState.copyWith(
        searchHistory: event.history,
      );
    if (event is SetRefresh)
      yield currentState.copyWith(
        refresh: event.refresh,
      );
    if (event is SearchResult) {
      String keyword = event.keyword ?? currentState.history[0];

      switch (currentState.currentSearchShelf) {
        case BookType.Manga:
          Map<BaseMangaSource, List<MangaBookModel>> result = {};
          this.dispatch(SetRefresh(false));
          yield currentState.copyWith(mangaResult: result);
          break;

        case BookType.Doujinshi:
          List<SearchDoujinshiResultModel> searchResult =
              await DoujinshiSearchService().search(
            keyword: keyword,
            sources: <BaseDoujinshiSource>[
              NHentaiSource(),
              EHentaiSource(),
            ],
          );
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
          this.dispatch(SetRefresh(false));
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
        SearchDoujinshiResultModel searchResult =
            (await DoujinshiSearchService().search(
          keyword: currentState.history[0],
          sources: <BaseDoujinshiSource>[
            event.source,
          ],
          page: nextPage,
        ))[0];

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
      }
    }
    if (event is SearchMoreIllustration) {}
  }
}

abstract class _BlocState extends Equatable {
  _BlocState([Iterable props]) : super(props);
}

class SearchBlocState extends _BlocState {
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
  }) : super([
          currentSearchShelf,
          history,
          mangaResult,
          doujinshiResult,
          illustrationResult,
          mangaState,
          doujinshiState,
          illustrationState,
          mangaPage,
          doujinshiPage,
          illustrationPage,
        ]);

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
      currentSearchShelf: BookType.Doujinshi,
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

abstract class _SearchEvent extends Equatable {}

class SetCurrentSearchShelf extends _SearchEvent {
  SetCurrentSearchShelf(this.currentSearchShelf);

  final BookType currentSearchShelf;

  @override
  String toString() => 'Set Current Search Shelf';
}

class SetHistory extends _SearchEvent {
  SetHistory(this.history);

  final List<String> history;

  @override
  String toString() => 'Set History';
}

class SetRefresh extends _SearchEvent {
  SetRefresh(this.refresh);

  final bool refresh;

  @override
  String toString() => 'Set Refresh';
}

class SetLoadMoreState extends _SearchEvent {
  SetLoadMoreState(this.source);

  final dynamic source;

  @override
  String toString() => 'Set loadmore State';
}

class SearchResult extends _SearchEvent {
  SearchResult([this.keyword]);

  final String keyword;

  @override
  String toString() => 'Search Result';
}

class SearchMoreManga extends _SearchEvent {
  SearchMoreManga(this.source);

  final BaseMangaSource source;

  @override
  String toString() => 'Search More Manga';
}

class SearchMoreDoujinshi extends _SearchEvent {
  SearchMoreDoujinshi(this.source);

  final BaseDoujinshiSource source;

  @override
  String toString() => 'Search More Doujinshi';
}

class SearchMoreIllustration extends _SearchEvent {
  SearchMoreIllustration(this.source);

  final BaseIllustrationSource source;

  @override
  String toString() => 'Search More Illustration';
}
