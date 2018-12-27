import 'package:flutter/material.dart';

import 'package:bookshelf/i18n.dart';

class DoujinshiShelf extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AppBar(
          title: Text(I18n.of(context).text('doujinshi')),
        )
      ],
    );
  }
}
