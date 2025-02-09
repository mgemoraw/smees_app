import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:smees/login_page.dart';
import 'package:smees/main.dart';


void main() {

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login Page Integration Test', () {
    testWidgets("Successful login navigates to home page", (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(MaterialApp(
        home: Login(),
      ));

      // Enter username
      final usernameField = find.byType(TextField).at(0);
      await tester.enterText(usernameField, 'testuser');

      // Enter password
      final passwordField = find.byType(TextField).at(1);
      await tester.enterText(passwordField, 'testpassword');

      // tap the login button 
      final loginButton = find.text('Login');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // verify that the app navigates to the ome page
      expect(find.text('Welcome to SMEES'), findsOneWidget);

    });

    testWidgets('Invalid login shows error message', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(MaterialApp(
        home: Login(),
      ));

      // Enter invalid username
      // Enter username
      final usernameField = find.byType(TextField).at(0);
      await tester.enterText(usernameField, 'testuser');

      // Enter password
      final passwordField = find.byType(TextField).at(1);
      await tester.enterText(passwordField, 'testpassword');

      // tap the login button 
      final loginButton = find.text('Login');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // verify that the app navigates to the ome page
      expect(find.text('Welcome to SMEES'), findsOneWidget);
    });

 
    //
  }); 
  testWidgets('end-to-end test', (WidgetTester tester) async {
    // build the main app
    await tester.pumpWidget(SmeesApp());

    // find a widget with specific content
    expect(find.text('Hello, World!'), findsOneWidget);

    // tap a button and verity the result
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // verify that the counter has incremented
    expect(find.text('1'), findsOneWidget);

  });
  
}

// to run this test code
// flutter test integration_test/app_test.dart
