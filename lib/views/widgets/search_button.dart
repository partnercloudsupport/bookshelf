import 'package:flutter/material.dart';

import 'package:bookshelf/views/widgets/search.dart';

class SearchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SearchBooksDelegate _searchBooksDelegate =
        SearchBooksDelegate(context);
    return IconButton(
      icon: Icon(Icons.search),
      onPressed: () async {
        await showSearch(
          context: context,
          delegate: _searchBooksDelegate,
        );
      },
    );
  }
}
