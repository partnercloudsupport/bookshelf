import 'package:flutter/material.dart';

import 'package:bookshelf/i18n.dart';

class ThemePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.of(context).text('theme')),
        elevation: 0,
      ),
      body: Container(),
    );
  }
}
