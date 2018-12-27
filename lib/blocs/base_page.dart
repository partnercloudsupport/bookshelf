import 'package:bloc/bloc.dart';

class BasePageBloc extends Bloc<_BasePageEvent, BasePageBlocState> {
  @override
  BasePageBlocState get initialState => BasePageBlocState();

  @override
  Stream<BasePageBlocState> mapEventToState(
      BasePageBlocState currentState, _BasePageEvent event) async* {
    if (event is DisplayMangaShelf)
      yield BasePageBlocState(
        currentShelf: ShelfTypes.Manga,
        books: null,
      );
    if (event is DisplayDoujinshiShelf)
      yield BasePageBlocState(
        currentShelf: ShelfTypes.Doujinshi,
        books: null,
      );
  }
}

enum ShelfTypes {
  Manga,
  Doujinshi,
}

class BasePageBlocState {
  BasePageBlocState({
    this.currentShelf = ShelfTypes.Manga,
    this.books,
  });

  final ShelfTypes currentShelf;
  final List books;
}

abstract class _BasePageEvent {}

class DisplayMangaShelf extends _BasePageEvent {}

class DisplayDoujinshiShelf extends _BasePageEvent {}
