import 'package:driver/screens/loginpage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Empty Email Test', () {
    var result = FieldValidator.validateEmail('');
    expect(result, 'Enter Email!');
  });


  test('Invalid Email Test', () {
    var result = FieldValidator.validateEmail('');
    expect(result, 'Enter Valid Email!');
  });

}