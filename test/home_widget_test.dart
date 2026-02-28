import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets("Basit text görünür mü", (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Text("Test Title"),
        ),
      ),
    );

    expect(find.text("Test Title"), findsOneWidget);
  });
}
