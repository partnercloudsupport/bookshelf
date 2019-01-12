import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:bookshelf/models/model.dart';

class ShelfPageBloc extends Bloc<_ShelfPageEvent, ShelfPageBlocState> {
  @override
  ShelfPageBlocState get initialState => ShelfPageBlocState.init();

  @override
  Stream<ShelfPageBlocState> mapEventToState(
      ShelfPageBlocState currentState, _ShelfPageEvent event) async* {
    if (event is SetCurrentShelf)
      yield currentState.copyWith(
        currentShelf: event.currentShelf,
      );
    if (event is SetFavoriteBook) {
      if (event.book is MangaBookModel) {
        if (currentState.favoriteManga.contains(event.book) &&
            !event.setFavourite)
          currentState.favoriteManga.remove(event.book);
        else if (!currentState.favoriteManga.contains(event.book) &&
            event.setFavourite)
          currentState.favoriteManga.insert(0, event.book);
      } else if (event.book is DoujinshiBookModel) {
        if (currentState.favoriteDoujinshi.contains(event.book) &&
            !event.setFavourite)
          currentState.favoriteDoujinshi.remove(event.book);
        else if (!currentState.favoriteDoujinshi.contains(event.book) &&
            event.setFavourite)
          currentState.favoriteDoujinshi.insert(0, event.book);
      } else if (event.book is IllustrationBookModel) {
        if (currentState.favoriteIllustration.contains(event.book) &&
            !event.setFavourite)
          currentState.favoriteIllustration.remove(event.book);
        else if (!currentState.favoriteIllustration.contains(event.book) &&
            event.setFavourite)
          currentState.favoriteIllustration.insert(0, event.book);
      }
      currentState.favoriteManga.toSet().toList();
      currentState.favoriteDoujinshi.toSet().toList();
      currentState.favoriteIllustration.toSet().toList();
      yield currentState.copyWith();
    }
  }
}

abstract class _BlocState extends Equatable {
  _BlocState([Iterable props]) : super(props);
}

class ShelfPageBlocState extends _BlocState {
  ShelfPageBlocState({
    this.currentShelf,
    this.recentBook,
    this.favoriteManga,
    this.favoriteDoujinshi,
    this.favoriteIllustration,
    this.recentManga,
    this.recentDoujinshi,
    this.recentIllustration,
    this.downloadedManga,
    this.downloadedDoujinshi,
    this.downloadedIllustration,
  }) : super([
          currentShelf,
          recentBook,
          favoriteManga,
          favoriteDoujinshi,
          favoriteIllustration,
          recentManga,
          recentDoujinshi,
          recentIllustration,
          downloadedManga,
          downloadedDoujinshi,
          downloadedIllustration,
        ]);

  final BookType currentShelf;
  final dynamic recentBook;
  final List<MangaBookModel> favoriteManga;
  final List<DoujinshiBookModel> favoriteDoujinshi;
  final List<IllustrationBookModel> favoriteIllustration;
  final List<MangaBookModel> recentManga;
  final List<DoujinshiBookModel> recentDoujinshi;
  final List<IllustrationBookModel> recentIllustration;
  final List<MangaBookModel> downloadedManga;
  final List<DoujinshiBookModel> downloadedDoujinshi;
  final List<IllustrationBookModel> downloadedIllustration;

  factory ShelfPageBlocState.init() {
    return ShelfPageBlocState(
      currentShelf: BookType.Doujinshi,
      recentBook: null,
      favoriteManga: [],
      favoriteDoujinshi: [],
      favoriteIllustration: [],
      recentManga: [],
      recentDoujinshi: [],
      recentIllustration: [],
      downloadedManga: [],
      downloadedDoujinshi: [],
      downloadedIllustration: [],
    );
  }

  ShelfPageBlocState copyWith({
    BookType currentShelf,
    dynamic recentBook,
    List<MangaBookModel> favoriteManga,
    List<DoujinshiBookModel> favoriteDoujinshi,
    List<IllustrationBookModel> favoriteIllustration,
    List<MangaBookModel> recentManga,
    List<DoujinshiBookModel> recentDoujinshi,
    List<IllustrationBookModel> recentIllustration,
    List<MangaBookModel> downloadedManga,
    List<DoujinshiBookModel> downloadedDoujinshi,
    List<IllustrationBookModel> downloadedIllustration,
  }) {
    return ShelfPageBlocState(
      currentShelf: currentShelf ?? this.currentShelf,
      recentBook: recentBook ?? this.recentBook,
      favoriteManga: favoriteManga ?? this.favoriteManga,
      favoriteDoujinshi: favoriteDoujinshi ?? this.favoriteDoujinshi,
      favoriteIllustration: favoriteIllustration ?? this.favoriteIllustration,
      recentManga: recentManga ?? this.recentManga,
      recentDoujinshi: recentDoujinshi ?? this.recentDoujinshi,
      recentIllustration: recentIllustration ?? this.recentIllustration,
      downloadedManga: downloadedManga ?? this.downloadedManga,
      downloadedDoujinshi: downloadedDoujinshi ?? this.downloadedDoujinshi,
      downloadedIllustration:
          downloadedIllustration ?? this.downloadedIllustration,
    );
  }

  @override
  String toString() => '''ShelfPageBlocState {
        currentShelf: $currentShelf,
        recentBook: $recentBook,
        favoriteManga: $favoriteManga,
        favoriteDoujinshi: $favoriteDoujinshi,
        favoriteIllustration: $favoriteIllustration,
        recentManga: $recentManga,
        recentDoujinshi: $recentDoujinshi,
        recentIllustration: $recentIllustration,
        downloadedManga: $downloadedManga,
        downloadedDoujinshi: $downloadedDoujinshi,
        downloadedIllustration: $downloadedIllustration,
      }''';
}

abstract class _ShelfPageEvent extends Equatable {}

class SetCurrentShelf extends _ShelfPageEvent {
  SetCurrentShelf(this.currentShelf);

  final BookType currentShelf;

  @override
  String toString() => 'Set Current Shelf';
}

class SetFavoriteBook extends _ShelfPageEvent {
  SetFavoriteBook(this.book, this.setFavourite);

  final dynamic book;
  final bool setFavourite;

  @override
  String toString() => 'Set Favourite Book';
}

class SetRecentBook extends _ShelfPageEvent {
  SetRecentBook(this.book, this.setClear);

  final dynamic book;
  final bool setClear;

  @override
  String toString() => 'Set Recent Book';
}

class SetDownloadedBook extends _ShelfPageEvent {
  SetDownloadedBook(this.book, this.setDownloaded);

  final dynamic book;
  final bool setDownloaded;

  @override
  String toString() => 'Set Downloaded Book';
}
