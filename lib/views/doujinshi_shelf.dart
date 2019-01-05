import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bookshelf/blocs/bloc.dart';
import 'package:bookshelf/locales/locale.dart';
import 'package:bookshelf/views/widgets/search_button.dart';

class DoujinshiShelf extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ShelfPageBloc _shelfPageBloc =
        BlocProvider.of<ShelfPageBloc>(context);

    return Column(
      children: <Widget>[
        AppBar(
          title: Text(I18n.of(context).text('doujinshi')),
          elevation: 0,
          actions: <Widget>[SearchButton()],
        ),
        Expanded(
          child: BlocBuilder(
            bloc: _shelfPageBloc,
            builder: (BuildContext context, ShelfPageBlocState state) {
              return Container();
            },
          ),
        ),
      ],
    );
  }
}
