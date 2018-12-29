// import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bookshelf/views/shelf.dart';

main() {
  testWidgets('App Run', (WidgetTester tester) async {
    await tester.pumpWidget(BookshelfApp());
  });
}
