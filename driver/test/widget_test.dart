// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:driver/main.dart';
import 'package:driver/FieldValidator.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
    test('Valid Email', () {
      var result = FieldValidator().validateEmail();
      expect(result, 'Invalid Email');
    });


    test('Valid Button', () {
      var result = FieldValidator().validateClick();
      expect(result, 'Invalid Button');
    });
    test('Long Name', () {
      var result = FieldValidator().validateLongName();
      expect(result, 'Long Name');
    });
    test('Long Pass', () {
      var result = FieldValidator().validateLongPass();
      expect(result, 'Long Pass');
    });

    test('Long Phone Number', () {
      var result = FieldValidator()..validateLongPhoneNumber();
      expect(result, 'Long Phone Number');
    });

    test('Valid Short Phone Number', () {
      var result = FieldValidator().validateShortPhoneNumber();
      expect(result, 'Short Phone Number');
    });
    test('Validate Short Pass', () {
      var result = FieldValidator().validateShortPass();
      expect(result, 'Short Pass');
      });
    }
    );
  }