import 'dart:async';
import 'dart:ui' show ImageFilter;

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
    final SearchBloc searchBloc = BlocProvider.of<SearchBloc>(parentContext);
    final ThemeData theme = Theme.of(context);

    return BlocBuilder(
      bloc: searchBloc,
      builder: (BuildContext context, SearchBlocState state) {
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
                searchBloc.dispatch(SetSearchHistory(value));
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
    final SearchBloc searchBloc = BlocProvider.of<SearchBloc>(parentContext);
    final I18n i18n = I18n.of(context);

    changeSearchBooksType(BookType value) =>
        searchBloc.dispatch(SetCurrentSearchShelf(value));

    return <Widget>[
      query.isNotEmpty
          ? IconButton(
              tooltip: i18n.text('clear'),
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            )
          : Container(),
      BlocBuilder(
        bloc: searchBloc,
        builder: (BuildContext context, SearchBlocState state) {
          return PopupMenuButton(
            offset: Offset(0.0, 100.0),
            icon: Icon(Icons.photo_library),
            tooltip: i18n.text('search_books_type'),
            onSelected: changeSearchBooksType,
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<BookType>>[
                CheckedPopupMenuItem<BookType>(
                  checked: state.currentSearchShelf == BookType.Manga,
                  value: BookType.Manga,
                  child: Text(i18n.text('manga')),
                ),
                CheckedPopupMenuItem<BookType>(
                  checked: state.currentSearchShelf == BookType.Doujinshi,
                  value: BookType.Doujinshi,
                  child: Text(i18n.text('doujinshi')),
                ),
                CheckedPopupMenuItem<BookType>(
                  checked: state.currentSearchShelf == BookType.Illustration,
                  value: BookType.Illustration,
                  child: Text(i18n.text('illustration')),
                  enabled: false,
                ),
              ];
            },
          );
        },
      ),
      BlocBuilder(
        bloc: searchBloc,
        builder: (BuildContext context, SearchBlocState state) {
          return IconButton(
            icon: Icon(Icons.filter_list),
            tooltip: i18n.text('search_books_filter'),
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
    final SearchBloc searchBloc = BlocProvider.of<SearchBloc>(parentContext);

    if (query.length > 0) {
      if (_currentQuery != query) {
        List<String> value = List.from(searchBloc.currentState.history);
        value.remove(query);
        value.insert(0, query);
        searchBloc.dispatch(SetSearchHistory(value));
        _currentQuery = query;

        searchBloc.dispatch(SetSearchRefresh(true));
        searchBloc.dispatch(SearchResult(query));
      }

      return ResultBuilder(searchBloc);
    } else {
      showSuggestions(context);
      return Container();
    }
  }
}

class ResultBuilder extends StatelessWidget {
  ResultBuilder(this.bloc);

  final SearchBloc bloc;

  _refreshSearchList() {
    bloc.dispatch(SetSearchRefresh(true));
    bloc.dispatch(SearchResult());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: bloc,
      builder: (BuildContext context, SearchBlocState state) {
        if (state.refresh) return Center(child: CircularProgressIndicator());
        switch (state.currentSearchShelf) {
          case BookType.Manga:
            return MangaResultCard(
              state.mangaResult,
              state.mangaState,
              _refreshSearchList,
              bloc,
            );
          case BookType.Doujinshi:
            return DoujinshiResultCard(
              state.doujinshiResult,
              state.doujinshiState,
              _refreshSearchList,
              bloc,
            );
          case BookType.Illustration:
            return IllustrationResultCard();
          default:
            return Container();
        }
      },
    );
  }
}

class MangaResultCard extends StatelessWidget {
  MangaResultCard(
    this.books,
    this.searchState,
    this.refreshCallback,
    this.searchBloc,
  );

  final Map<BaseMangaSource, List<MangaBookModel>> books;
  final Map<BaseMangaSource, SearchState> searchState;
  final Function refreshCallback;
  final SearchBloc searchBloc;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class DoujinshiResultCard extends StatelessWidget {
  DoujinshiResultCard(
    this.doujinshiBooks,
    this.searchState,
    this.refreshCallback,
    this.searchBloc,
  );

  final Map<BaseDoujinshiSource, List<DoujinshiBookModel>> doujinshiBooks;
  final Map<BaseDoujinshiSource, SearchState> searchState;
  final Function refreshCallback;
  final SearchBloc searchBloc;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final I18n i18n = I18n.of(context);

    return DefaultTabController(
      length: doujinshiBooks.length,
      child: Stack(
        children: <Widget>[
          TabBarView(
            children:
                doujinshiBooks.values.map((List<DoujinshiBookModel> books) {
              return RefreshIndicator(
                onRefresh: () => Future(refreshCallback),
                child: ListView.builder(
                  itemCount: books.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index >= books.length) {
                      return LoadMoreWidget(
                        loadMoreCallback: () => searchBloc
                            .dispatch(SetLoadMoreState(books[0].source)),
                        searchState: searchState[books[0].source],
                      );
                    }

                    DoujinshiBookModel book = books[index];

                    return Container(
                      color: theme.cardColor,
                      height: 230.0,
                      margin: index == 0
                          ? const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 10.0)
                          : const EdgeInsets.symmetric(vertical: 10.0),
                      child: Material(
                        child: InkWell(
                          onTap: () {
                            BlocProvider.of<AppBloc>(context)
                                .dispatch(SetCurrentDetailData(book));
                            Navigator.of(context)
                                .pushNamed('/doujinshi_detail');
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
                                                      '${i18n.text('language')}${book.languages.contains('translated') ? '(${i18n.text('translated')})' : ''}: ',
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
                                                      '${i18n.text('artist')}: ',
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
                                                  text: '${i18n.text('tag')}: ',
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
                                                    '${i18n.text('upload_date')}: ',
                                                style: theme.textTheme.subhead
                                                    .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.0,
                                                ),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text:
                                                        '${i18n.dateFormat(book.uploadDate)}',
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
                  tabs: doujinshiBooks.keys
                      .map((BaseDoujinshiSource source) =>
                          Tab(text: source.sourceName))
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IllustrationResultCard extends StatelessWidget {
  IllustrationResultCard();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class LoadMoreWidget extends StatelessWidget {
  const LoadMoreWidget({
    Key key,
    this.loadMoreCallback,
    this.searchState,
  });

  final Function loadMoreCallback;
  final SearchState searchState;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 48.0),
      height: 120.0,
      child: AnimatedCrossFade(
        duration: const Duration(milliseconds: 100),
        sizeCurve: Curves.fastOutSlowIn,
        crossFadeState: searchState == SearchState.IsLoading
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        firstChild: searchState == SearchState.IsEnd
            ? Container(
                child: Text('The end of the world.'),
              )
            : FlatButton(
                onPressed: () {
                  if (loadMoreCallback != null) loadMoreCallback();
                },
                child: Icon(Icons.keyboard_arrow_down),
              ),
        secondChild: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
