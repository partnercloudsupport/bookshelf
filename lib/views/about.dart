import 'package:flutter/material.dart';

import 'package:bookshelf/locales/locale.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.of(context).text('about')),
        elevation: 0,
      ),
      body: Container(),
    );
  }
}
