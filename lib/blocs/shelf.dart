import 'package:bloc/bloc.dart';

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
  }
}

class ShelfPageBlocState {
  ShelfPageBlocState({
    this.currentShelf,
  });

  final BookType currentShelf;

  factory ShelfPageBlocState.init() {
    return ShelfPageBlocState(
      currentShelf: BookType.Manga,
    );
  }

  ShelfPageBlocState copyWith({
    BookType currentShelf,
  }) {
    return ShelfPageBlocState(
      currentShelf: currentShelf ?? this.currentShelf,
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
          currentShelf == other.currentShelf;

  @override
  int get hashCode =>
      currentShelf.hashCode;

  @override
  String toString() => '''ShelfPageBlocState {
        currentShelf: $currentShelf,
      }''';
}

abstract class _ShelfPageEvent {}

class SetCurrentShelf extends _ShelfPageEvent {
  SetCurrentShelf(this.currentShelf);

  final BookType currentShelf;
}
