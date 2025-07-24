import 'package:blood_camp_finder_project/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Login screen loads correctly', (WidgetTester tester) async {
    // Provide the required parameter to MyApp
    await tester.pumpWidget(const MyApp(isLoggedIn: false));

    await tester.pumpAndSettle();

    // Check that login elements are on screen
    expect(find.text("Welcome Back!"), findsOneWidget);
    expect(find.byIcon(Icons.email), findsOneWidget);
    expect(find.byIcon(Icons.lock), findsOneWidget);
    expect(find.text("Login"), findsOneWidget);
    expect(find.text("Don't have an account? Register here"), findsOneWidget);
  });
}