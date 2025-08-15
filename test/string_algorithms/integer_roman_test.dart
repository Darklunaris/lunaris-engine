import 'package:test/test.dart';
import 'package:lunaris_engine/String/integer_roman.dart';

void main() {
  test('intToRoman and romanToInt', () {
    expect(intToRoman(1994), equals('MCMXCIV'));
    expect(romanToInt('MCMXCIV'), equals(1994));
    expect(intToRoman(58), equals('LVIII'));
    expect(romanToInt('LVIII'), equals(58));
  });
}
