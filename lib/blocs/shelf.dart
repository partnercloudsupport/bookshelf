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
  }
}

abstract class _BlocState extends Equatable {
  _BlocState([Iterable props]) : super(props);
}

class ShelfPageBlocState extends _BlocState {
  ShelfPageBlocState({
    this.currentShelf,
  }) : super([
          currentShelf,
        ]);

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
  String toString() => '''ShelfPageBlocState {
        currentShelf: $currentShelf,
      }''';
}

abstract class _ShelfPageEvent extends Equatable {}

class SetCurrentShelf extends _ShelfPageEvent {
  SetCurrentShelf(this.currentShelf);

  final BookType currentShelf;

  @override
  String toString() => 'Set Current Shelf';
}
