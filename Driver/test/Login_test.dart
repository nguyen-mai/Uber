import 'package:driver/screens/loginpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Empty Email Test', () {
    var result = LoginPage().loginUser(BuildContext context);
    expect(result, 'You are loggin now');
  });
}