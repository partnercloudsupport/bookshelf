import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bookshelf/blocs/bloc.dart';
import 'package:bookshelf/models/model.dart';

import 'package:bookshelf/locales/locale.dart';

class DoujinshiDetailPage extends StatefulWidget {
  DoujinshiDetailPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DoujinshiDetailPageState();
}

class _DoujinshiDetailPageState extends State<DoujinshiDetailPage> {
  DoujinshiBookModel doujinshiData;

  getDetailData() {}

  @override
  Widget build(BuildContext context) {
    final AppBloc _appBloc = BlocProvider.of<AppBloc>(context);

    return BlocBuilder(
      bloc: _appBloc,
      builder: (BuildContext context, AppBlocState state) {
        doujinshiData = state.currentDetailData as DoujinshiBookModel;

        return Scaffold(
          appBar: AppBar(
            title: Text(I18n.of(context).text('doujinshi_detail')),
            elevation: 0,
          ),
          body: Container(),
        );
      },
    );
  }
}
