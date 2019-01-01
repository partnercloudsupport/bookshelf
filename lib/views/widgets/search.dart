import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bookshelf/blocs/bloc.dart';
import 'package:bookshelf/models/model.dart';
import 'package:bookshelf/locales/locale.dart';

class SearchBooksDelegate extends SearchDelegate<int> {
  SearchBooksDelegate(this.parentContext);

  final BuildContext parentContext;

  String _currentQuery;

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: I18n.of(context).text('back'),
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final ShelfPageBloc _shelfPageBloc =
        BlocProvider.of<ShelfPageBloc>(parentContext);
    final ThemeData theme = Theme.of(context);

    return BlocBuilder(
      bloc: _shelfPageBloc,
      builder: (BuildContext context, ShelfPageBlocState state) {
        final Iterable<String> suggestions =
            state.history.where((String str) => str.startsWith(query));

        return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (BuildContext context, int i) {
            final String suggestion = suggestions.toList()[i];

            return Dismissible(
              key: Key(suggestion),
              onDismissed: (_) {
                List<String> value = List.from(state.history);
                value.removeAt(i);
                _shelfPageBloc.dispatch(SetSearchHistory(value));
              },
              background: Container(color: theme.primaryColor),
              child: ListTile(
                leading: Icon(Icons.history),
                title: RichText(
                  text: TextSpan(
                    text: suggestion.substring(0, query.length),
                    style: theme.textTheme.subhead.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: suggestion.substring(query.length),
                        style: theme.textTheme.subhead,
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  query = suggestion;
                  showResults(context);
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    final ShelfPageBloc _shelfPageBloc =
        BlocProvider.of<ShelfPageBloc>(parentContext);

    changeSearchBooksType(BookType value) =>
        _shelfPageBloc.dispatch(SetCurrentSearchShelf(value));

    return <Widget>[
      query.isNotEmpty
          ? IconButton(
              tooltip: I18n.of(context).text('clear'),
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            )
          : Container(),
      BlocBuilder(
        bloc: _shelfPageBloc,
        builder: (BuildContext context, ShelfPageBlocState state) {
          return PopupMenuButton(
            offset: Offset(0.0, 100.0),
            icon: Icon(Icons.photo_library),
            tooltip: I18n.of(context).text('search_books_type'),
            onSelected: changeSearchBooksType,
            itemBuilder: (BuildContext context) {
              return [
                CheckedPopupMenuItem(
                  checked: state.currentSearchShelf == BookType.Manga,
                  value: BookType.Manga,
                  child: Text(I18n.of(context).text('manga')),
                ),
                CheckedPopupMenuItem(
                  checked: state.currentSearchShelf == BookType.Doujinshi,
                  value: BookType.Doujinshi,
                  child: Text(I18n.of(context).text('doujinshi')),
                ),
                CheckedPopupMenuItem(
                  checked: state.currentSearchShelf == BookType.Illustration,
                  value: BookType.Illustration,
                  child: Text(I18n.of(context).text('illustration')),
                  enabled: false,
                ),
              ];
            },
          );
        },
      ),
      BlocBuilder(
        bloc: _shelfPageBloc,
        builder: (BuildContext context, ShelfPageBlocState state) {
          return IconButton(
            icon: Icon(Icons.filter_list),
            tooltip: I18n.of(context).text('search_books_filter'),
            onPressed: () {
              // TODO: popup a dialog for the search filter
            },
          );
        },
      ),
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    final ShelfPageBloc _shelfPageBloc =
        BlocProvider.of<ShelfPageBloc>(parentContext);

    if (query.length > 0) {
      if (_currentQuery != query) {
        List<String> value = List.from(_shelfPageBloc.currentState.history);
        value.remove(query);
        value.insert(0, query);
        _shelfPageBloc.dispatch(SetSearchHistory(value));
        _currentQuery = query;

        _shelfPageBloc.dispatch(SearchResult(query));
      }

      return _resultBuilder(_shelfPageBloc);
    } else {
      showSuggestions(context);
      return Container();
    }
  }

  Widget _resultBuilder(ShelfPageBloc bloc) {
    return BlocBuilder(
      bloc: bloc,
      builder: (BuildContext context, ShelfPageBlocState state) {
        switch (bloc.currentState.currentSearchShelf) {
          case BookType.Manga:
            return _mangaResultCard(state.searchMangaResult);
          case BookType.Doujinshi:
            return _doujinshiResultCard(state.searchDoujinshiResult);
          case BookType.Illustration:
            return _illustrationResultCard();
          default:
            return Container();
        }
      },
    );
  }

  Widget _mangaResultCard(List<MangaBookModel> books) {
    return ListView(
      children: books.map((MangaBookModel book) {
        return ListTile(
          title: Text(book.name),
        );
      }).toList(),
    );
  }

  Widget _doujinshiResultCard(List<DoujinshiBookModel> books) {
    final ThemeData theme = Theme.of(parentContext);

    return ListView(
      children: books.map((DoujinshiBookModel book) {
        return Container(
          color: theme.cardColor,
          height: 200.0,
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 150.0,
                child: Card(
                  margin: const EdgeInsets.all(12.0),
                  elevation: 10.0,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0)),
                  child: Image.network(book.coverUrl, fit: BoxFit.cover),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(12.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        book.name,
                        style: theme.textTheme.subhead.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      Text(
                        book.originalName,
                        style: theme.textTheme.subhead.copyWith(
                          fontSize: 12.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _illustrationResultCard() => Container();
}
