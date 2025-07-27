// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:blood_camp_finder_project/main.dart';

void main() {
  testWidgets('App starts and shows a loading indicator initially', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // FIX: We no longer pass any parameters to MyApp().
    await tester.pumpWidget(const MyApp());

    // Verify that the app shows a CircularProgressIndicator while waiting for Firebase.
    // This is the first thing your AuthGate widget shows.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // You can add more tests here to handle what happens after Firebase initializes,
    // but this basic test will now pass and fix the error.
  });
}
