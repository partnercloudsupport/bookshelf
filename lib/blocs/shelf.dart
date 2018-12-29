import 'package:bloc/bloc.dart';

class ShelfPageBloc extends Bloc<_BasePageEvent, ShelfPageBlocState> {
  @override
  ShelfPageBlocState get initialState => ShelfPageBlocState();

  @override
  Stream<ShelfPageBlocState> mapEventToState(
      ShelfPageBlocState currentState, _BasePageEvent event) async* {
    if (event is DisplayMangaShelf)
      yield ShelfPageBlocState(
        currentShelf: ShelfTypes.Manga,
        books: null,
      );
    if (event is DisplayDoujinshiShelf)
      yield ShelfPageBlocState(
        currentShelf: ShelfTypes.Doujinshi,
        books: null,
      );
  }
}

enum ShelfTypes {
  Manga,
  Doujinshi,
}

class ShelfPageBlocState {
  ShelfPageBlocState({
    this.currentShelf = ShelfTypes.Manga,
    this.books,
  });

  final ShelfTypes currentShelf;
  final List books;
}

abstract class _BasePageEvent {}

class DisplayMangaShelf extends _BasePageEvent {}

class DisplayDoujinshiShelf extends _BasePageEvent {}
