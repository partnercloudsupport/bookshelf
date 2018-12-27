// import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bookshelf/views/base.dart';

void main() {
  testWidgets('App Run', (WidgetTester tester) async {
    await tester.pumpWidget(BookshelfApp());
  });
}
