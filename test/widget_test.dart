import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:myapp/main.dart';

void main() {
  testWidgets('HomePage should display welcome message', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SchoolApp());

    // Verify that our app has the correct title in the AppBar.
    expect(find.text('School Home Page'), findsOneWidget);

    // Verify that the welcome text is present.
    expect(find.text('Welcome to the School App!'), findsOneWidget);

    // Verify that the counter icon is NOT present.
    expect(find.byIcon(Icons.add), findsNothing);
  });
}
