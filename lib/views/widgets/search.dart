import 'dart:ui';

import 'package:bookshelf/sources/source.dart';
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
    _refreshSearchList() => bloc.dispatch(SearchResult());

    return BlocBuilder(
      bloc: bloc,
      builder: (BuildContext context, ShelfPageBlocState state) {
        switch (bloc.currentState.currentSearchShelf) {
          case BookType.Manga:
            return _mangaResultCard(
                state.searchMangaResult, _refreshSearchList);
          case BookType.Doujinshi:
            return _doujinshiResultCard(
                state.searchDoujinshiResult, _refreshSearchList);
          case BookType.Illustration:
            return _illustrationResultCard();
          default:
            return Container();
        }
      },
    );
  }

  Widget _mangaResultCard(
      List<MangaBookModel> books, Function refreshCallback) {
    return ListView(
      children: books.map((MangaBookModel book) {
        return ListTile(
          title: Text(book.name),
        );
      }).toList(),
    );
  }

  Widget _doujinshiResultCard(
      List<DoujinshiBookModel> books, Function refreshCallback) {
    final ThemeData theme = Theme.of(parentContext);

    Map<BaseDoujinshiSource, List<DoujinshiBookModel>> doujinshiCollection = {};
    for (DoujinshiBookModel book in books) {
      if (doujinshiCollection.containsKey(book.source))
        doujinshiCollection[book.source].add(book);
      else
        doujinshiCollection[book.source] = [book];
    }

    return DefaultTabController(
      length: doujinshiCollection.length,
      child: Stack(
        children: <Widget>[
          TabBarView(
            children: doujinshiCollection.values
                .map((List<DoujinshiBookModel> doujinshiBooks) {
              return RefreshIndicator(
                onRefresh: () => Future(refreshCallback),
                child: ListView.builder(
                  itemCount: doujinshiBooks.length,
                  itemBuilder: (BuildContext context, int index) {
                    DoujinshiBookModel book = doujinshiBooks[index];

                    return Container(
                      color: theme.cardColor,
                      height: 230.0,
                      margin: index == 0
                          ? const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 10.0)
                          : index == books.length - 1
                              ? const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 48.0)
                              : const EdgeInsets.symmetric(vertical: 10.0),
                      child: Material(
                        child: InkWell(
                          onTap: () {
                            print('$index: book.toString()');
                          },
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
                                  child: Image.network(book.coverUrl,
                                      fit: BoxFit.cover),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.fromLTRB(
                                      5.0, 12.0, 12.0, 12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      Divider(),
                                      book.languages != null &&
                                              book.languages.length > 0
                                          ? Container(
                                              padding: const EdgeInsets.only(
                                                  bottom: 5.0),
                                              child: RichText(
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                text: TextSpan(
                                                  text:
                                                      '${I18n.of(context).text('language')}${book.languages.contains('translated') ? '(${I18n.of(context).text('translated')})' : ''}: ',
                                                  style: theme.textTheme.subhead
                                                      .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12.0,
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: book.languages
                                                          .where(
                                                              (String lang) =>
                                                                  lang !=
                                                                  'translated')
                                                          .join(' '),
                                                      style: theme
                                                          .textTheme.subhead
                                                          .copyWith(
                                                        fontSize: 12.0,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Container(),
                                      book.artists != null &&
                                              book.artists.length > 0
                                          ? Container(
                                              padding: const EdgeInsets.only(
                                                  bottom: 5.0),
                                              child: RichText(
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                text: TextSpan(
                                                  text:
                                                      '${I18n.of(context).text('artist')}: ',
                                                  style: theme.textTheme.subhead
                                                      .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12.0,
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: book.artists
                                                          .join(' '),
                                                      style: theme
                                                          .textTheme.subhead
                                                          .copyWith(
                                                        fontSize: 12.0,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Container(),
                                      book.tags != null && book.tags.length > 0
                                          ? Container(
                                              padding: const EdgeInsets.only(
                                                  bottom: 5.0),
                                              child: RichText(
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                text: TextSpan(
                                                  text:
                                                      '${I18n.of(context).text('tag')}: ',
                                                  style: theme.textTheme.subhead
                                                      .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12.0,
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: book.tags.join(' '),
                                                      style: theme
                                                          .textTheme.subhead
                                                          .copyWith(
                                                        fontSize: 12.0,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Container(),
                                      book.uploadDate != null
                                          ? RichText(
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              text: TextSpan(
                                                text:
                                                    '${I18n.of(context).text('upload_date')}: ',
                                                style: theme.textTheme.subhead
                                                    .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.0,
                                                ),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text:
                                                        '${I18n.of(context).dateFormat(book.uploadDate)}',
                                                    style: theme
                                                        .textTheme.subhead
                                                        .copyWith(
                                                      fontSize: 12.0,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                alignment: Alignment.bottomCenter,
                color: Color(0),
                child: TabBar(
                  isScrollable: true,
                  labelColor: theme.primaryColor,
                  tabs: doujinshiCollection.keys
                      .map((BaseDoujinshiSource source) => Tab(
                            text: source.sourceName,
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // return ;
  }

  Widget _illustrationResultCard() => Container();
}
