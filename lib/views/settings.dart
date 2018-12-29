import 'package:flutter/material.dart';

import 'package:bookshelf/i18n.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.of(context).text('settings')),
        elevation: 0,
      ),
      body: Container(),
    );
  }
}
