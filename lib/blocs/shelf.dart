import 'package:bloc/bloc.dart';

import 'package:bookshelf/models/model.dart';
import 'package:bookshelf/services/parser.dart';
import 'package:bookshelf/sources/source.dart';

class ShelfPageBloc extends Bloc<_BasePageEvent, ShelfPageBlocState> {
  @override
  ShelfPageBlocState get initialState => ShelfPageBlocState.init();

  @override
  Stream<ShelfPageBlocState> mapEventToState(
      ShelfPageBlocState currentState, _BasePageEvent event) async* {
    if (event is SetCurrentShelf)
      yield currentState.copyWith(
        currentShelf: event.currentShelf,
      );
    if (event is SetCurrentSearchShelf)
      yield currentState.copyWith(
        currentSearchShelf: event.currentSearchShelf,
      );
    if (event is SetSearchHistory)
      yield currentState.copyWith(
        history: event.history,
      );
    if (event is SetSearchState)
      yield currentState.copyWith(
        searching: event.searching,
      );
    if (event is SearchResult) {
      String keyword = event.keyword ?? currentState.history[0];

      switch (currentState.currentSearchShelf) {
        case BookType.Manga:
          List<MangaBookModel> result = [];
          yield currentState.copyWith(searchMangaResult: result);
          break;
        case BookType.Doujinshi:
          List<DoujinshiBookModel> result = await DoujinshiSearchService(
            keyword: keyword,
            sources: <BaseDoujinshiSource>[
              NHentaiSource(),
            ],
          ).search();
          this.dispatch(SetSearchState(false));
          yield currentState.copyWith(searchDoujinshiResult: result);
          break;
        case BookType.Illustration:
          this.dispatch(SetSearchState(false));
          break;
        default:
          break;
      }
    }
  }
}

class ShelfPageBlocState {
  ShelfPageBlocState({
    this.currentShelf,
    this.currentSearchShelf,
    this.history,
    this.searchMangaResult,
    this.searchDoujinshiResult,
    this.searching,
  });

  final BookType currentShelf;
  final BookType currentSearchShelf;
  final List<String> history;
  final List<MangaBookModel> searchMangaResult;
  final List<DoujinshiBookModel> searchDoujinshiResult;
  final bool searching;

  factory ShelfPageBlocState.init() {
    return ShelfPageBlocState(
      currentShelf: BookType.Manga,
      currentSearchShelf: BookType.Manga,
      history: [],
      searchMangaResult: [],
      searchDoujinshiResult: [],
      searching: false,
    );
  }

  ShelfPageBlocState copyWith({
    BookType currentShelf,
    BookType currentSearchShelf,
    List<String> history,
    List<MangaBookModel> searchMangaResult,
    List<DoujinshiBookModel> searchDoujinshiResult,
    bool searching,
  }) {
    return ShelfPageBlocState(
      currentShelf: currentShelf ?? this.currentShelf,
      currentSearchShelf: currentSearchShelf ?? this.currentSearchShelf,
      history: history ?? this.history,
      searchMangaResult: searchMangaResult ?? this.searchMangaResult,
      searchDoujinshiResult:
          searchDoujinshiResult ?? this.searchDoujinshiResult,
      searching: searching ?? this.searching,
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
      other is ShelfPageBlocState &&
          runtimeType == other.runtimeType &&
          currentShelf == other.currentShelf &&
          currentSearchShelf == other.currentSearchShelf &&
          history == other.history &&
          searchMangaResult == other.searchMangaResult &&
          searchDoujinshiResult == other.searchDoujinshiResult &&
          searching == other.searching;

  @override
  int get hashCode =>
      currentShelf.hashCode ^
      currentSearchShelf.hashCode ^
      history.hashCode ^
      searchMangaResult.hashCode ^
      searchDoujinshiResult.hashCode ^
      searching.hashCode;

  @override
  String toString() => '''ShelfPageBlocState {
        currentShelf: $currentShelf,
        currentSearchShelf: $currentSearchShelf,
        history: $history,
        searchMangaResult: $searchMangaResult,
        searchDoujinshiResult: $searchDoujinshiResult,
        searching: $searching,
      }''';
}

abstract class _BasePageEvent {}

class SetCurrentShelf extends _BasePageEvent {
  SetCurrentShelf(this.currentShelf);

  final BookType currentShelf;
}

class SetCurrentSearchShelf extends _BasePageEvent {
  SetCurrentSearchShelf(this.currentSearchShelf);

  final BookType currentSearchShelf;
}

class SetSearchHistory extends _BasePageEvent {
  SetSearchHistory(this.history);

  final List<String> history;
}

class SearchResult extends _BasePageEvent {
  SearchResult([this.keyword]);

  final String keyword;
}

class SetSearchState extends _BasePageEvent {
  SetSearchState(this.searching);

  final bool searching;
}
