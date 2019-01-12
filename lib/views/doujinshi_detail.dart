import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

import 'package:bookshelf/blocs/bloc.dart';
import 'package:bookshelf/models/model.dart';
import 'package:bookshelf/locales/locale.dart';

class DoujinshiDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppBloc appBloc = BlocProvider.of<AppBloc>(context);
    final ShelfPageBloc shelfPageBloc = BlocProvider.of<ShelfPageBloc>(context);
    final ThemeData theme = Theme.of(context);
    final I18n i18n = I18n.of(context);

    return BlocBuilder(
      bloc: appBloc,
      builder: (BuildContext context, AppBlocState state) {
        DoujinshiBookModel book = state.currentDetailData as DoujinshiBookModel;

        return Material(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(book.coverUrl),
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
              child: Container(
                color: theme.cardColor.withOpacity(0.1),
                child: Column(
                  children: <Widget>[
                    AppBar(
                      title: Text(i18n.text('doujinshi_detail')),
                      backgroundColor: theme.primaryColor.withOpacity(0.3),
                      elevation: 0,
                      actions: <Widget>[
                        BlocBuilder(
                          bloc: shelfPageBloc,
                          builder:
                              (BuildContext context, ShelfPageBlocState state) {
                            return IconButton(
                              icon: state.favoriteDoujinshi.contains(book)
                                  ? Icon(Icons.favorite)
                                  : Icon(Icons.favorite_border),
                              onPressed: () => shelfPageBloc.dispatch(
                                  SetFavoriteBook(book,
                                      !state.favoriteDoujinshi.contains(book))),
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          ListView(
                            padding: EdgeInsets.zero,
                            children: <Widget>[
                              Container(
                                height: 250.0,
                                color: theme.primaryColor.withOpacity(0.3),
                                child: Row(
                                  children: <Widget>[
                                    Hero(
                                      tag: book.hashCode,
                                      child: Container(
                                        width: 170.0,
                                        child: Card(
                                          margin: const EdgeInsets.all(12.0),
                                          elevation: 10.0,
                                          clipBehavior: Clip.antiAlias,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(7.0),
                                          ),
                                          child: TransitionToImage(
                                            image: NetworkImage(book.coverUrl),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            5.0, 24.0, 12.0, 20.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              book.name,
                                              style: theme
                                                  .primaryTextTheme.title
                                                  .copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 4,
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0)),
                                            Text(
                                              book.originalName,
                                              style: theme
                                                  .primaryTextTheme.subtitle
                                                  .copyWith(
                                                color: theme.primaryTextTheme
                                                    .subtitle.color
                                                    .withOpacity(0.8),
                                                fontSize: 14.0,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 4,
                                            ),
                                            Expanded(
                                              child: Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Text(
                                                  i18n.dateFormat(
                                                      book.uploadDate),
                                                  style: theme
                                                      .primaryTextTheme.subtitle
                                                      .copyWith(
                                                    color: theme
                                                        .primaryTextTheme
                                                        .subtitle
                                                        .color
                                                        .withOpacity(0.8),
                                                    fontSize: 12.0,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 5,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                color: theme.cardColor.withOpacity(0.5),
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 20.0, 10.0, 20.0),
                                height: book.previewPages != null &&
                                        book.previewPages.length > 0
                                    ? null
                                    : 600.0,
                                child: Column(
                                  children: <Widget>[
                                    TagWidget(
                                        i18n.text('parody'), book.parodies),
                                    TagWidget(i18n.text('character'),
                                        book.characters),
                                    TagWidget(i18n.text('tag'), book.tags),
                                    TagWidget(
                                        i18n.text('artist'), book.artists),
                                    TagWidget(i18n.text('group'), book.groups),
                                    TagWidget(
                                        '${i18n.text('language')}${book.languages.contains('translated') ? '(${i18n.text('translated')})' : ''}',
                                        book.languages
                                            .where((String lang) =>
                                                lang != 'translated')
                                            .toList()),
                                    TagWidget(
                                        i18n.text('category'), book.categories),
                                  ],
                                ),
                              ),
                              book.previewPages != null &&
                                      book.previewPages.length > 0
                                  ? Container(
                                      color: theme.cardColor.withOpacity(0.5),
                                      height: 200.0,
                                      padding: const EdgeInsets.fromLTRB(
                                          10.0, 10.0, 10.0, 20.0),
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: book.previewPages.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Container(
                                            width: 130.0,
                                            padding: index == 0
                                                ? null
                                                : const EdgeInsets.only(
                                                    left: 10.0),
                                            child: Image(
                                              image: NetworkImage(
                                                  book.previewPages[index]),
                                              fit: BoxFit.fitWidth,
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                          Positioned(
                            right: 20.0,
                            bottom: 20.0,
                            child: FloatingActionButton(
                              child: Icon(Icons.import_contacts),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class TagWidget extends StatelessWidget {
  TagWidget(this.label, this.tags);

  final String label;
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return tags != null && tags.length > 0
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 90.0,
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.body1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Wrap(
                    spacing: 5.0,
                    runSpacing: 5.0,
                    children: tags.map((String tag) {
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50.0),
                          child: Ink(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              color: theme.primaryColor,
                            ),
                            padding:
                                const EdgeInsets.fromLTRB(13.0, 5.0, 13.0, 5.0),
                            child: Text(
                              tag,
                              style: theme.textTheme.body1.copyWith(
                                fontSize: 14.0,
                                color: theme.primaryTextTheme.subtitle.color,
                              ),
                            ),
                          ),
                          onTap: () {},
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          )
        : Container();
  }
}
