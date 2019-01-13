import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

import 'package:bookshelf/blocs/bloc.dart';
import 'package:bookshelf/models/model.dart';
import 'package:bookshelf/sources/source.dart';
import 'package:bookshelf/locales/locale.dart';
import 'package:bookshelf/views/widgets/search_button.dart';

class DoujinshiShelf extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ShelfPageBloc shelfPageBloc = BlocProvider.of<ShelfPageBloc>(context);
    final ThemeData theme = Theme.of(context);
    final I18n i18n = I18n.of(context);

    Widget booksGrid(
        Map<BaseDoujinshiSource, List<DoujinshiBookModel>> collections) {
      return Scrollbar(
        child: ListView(
          padding: const EdgeInsets.all(0.0),
          children: collections.keys.map((BaseDoujinshiSource source) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 160.0,
                  height: 50.0,
                  margin: EdgeInsets.only(
                      top: collections.keys.first == source ? 10.0 : 30.0),
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(50.0),
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(50.0),
                      ),
                      // onTap: () {},
                      child: Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(left: 25.0),
                        child: Text(
                          source.sourceName,
                          style: theme.primaryTextTheme.subtitle,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Wrap(
                    children:
                        collections[source].map((DoujinshiBookModel book) {
                      return InkWell(
                        onTap: () {
                          BlocProvider.of<AppBloc>(context)
                              .dispatch(SetCurrentDetailData(book));
                          Navigator.of(context).pushNamed('/doujinshi_detail');
                        },
                        child: Column(
                          children: <Widget>[
                            Hero(
                              tag: book.hashCode,
                              child: Container(
                                width: 130.0,
                                height: 190.0,
                                alignment: Alignment.center,
                                child: Card(
                                  margin: const EdgeInsets.all(7.0),
                                  elevation: 10.0,
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                  ),
                                  child: TransitionToImage(
                                    image: NetworkImage(book.coverUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 130.0,
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                book.originalName,
                                style: theme.textTheme.subtitle.copyWith(
                                  fontSize: 12.0,
                                  color: theme.textTheme.subtitle.color
                                      .withOpacity(0.8),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      );
    }

    return Column(
      children: <Widget>[
        AppBar(
          title: Text(I18n.of(context).text('doujinshi')),
          elevation: 0,
          actions: <Widget>[SearchButton()],
        ),
        Expanded(
          child: BlocBuilder(
            bloc: shelfPageBloc,
            builder: (BuildContext context, ShelfPageBlocState state) {
              Map<BaseDoujinshiSource, List<DoujinshiBookModel>>
                  favoriteDoujinshi = Map(),
                  recentDoujinshi = Map(),
                  downloadedDoujinshi = Map();
              state.favoriteDoujinshi.forEach((DoujinshiBookModel book) {
                if (favoriteDoujinshi.keys.contains(book.source))
                  favoriteDoujinshi[book.source].add(book);
                else
                  favoriteDoujinshi[book.source] = <DoujinshiBookModel>[book];
              });
              state.recentDoujinshi.forEach((DoujinshiBookModel book) {
                if (recentDoujinshi.keys.contains(book.source))
                  recentDoujinshi[book.source].add(book);
                else
                  recentDoujinshi[book.source] = <DoujinshiBookModel>[book];
              });
              state.downloadedDoujinshi.forEach((DoujinshiBookModel book) {
                if (downloadedDoujinshi.keys.contains(book.source))
                  downloadedDoujinshi[book.source].add(book);
                else
                  downloadedDoujinshi[book.source] = <DoujinshiBookModel>[book];
              });

              return DefaultTabController(
                length: 3,
                child: Column(
                  children: <Widget>[
                    Material(
                      color: theme.primaryColor,
                      child: TabBar(
                        tabs: <Widget>[
                          Tab(text: i18n.text('favourite')),
                          Tab(text: i18n.text('recent')),
                          Tab(text: i18n.text('downloaded')),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: <Widget>[
                          booksGrid(favoriteDoujinshi),
                          booksGrid(recentDoujinshi),
                          booksGrid(downloadedDoujinshi),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
