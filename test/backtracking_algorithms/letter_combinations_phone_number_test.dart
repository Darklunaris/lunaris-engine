import 'package:test/test.dart';
import 'package:lunaris_engine/Backtracking/letter_combinations_phone_number.dart';

void main() {
  group('Letter Combinations of Phone Number', () {
    test('digits = "23"', () {
      final result = letterCombinations('23');
      expect(
        result,
        containsAll(['ad', 'ae', 'af', 'bd', 'be', 'bf', 'cd', 'ce', 'cf']),
      );
      expect(result.length, equals(9));
    });
    test('Empty input', () {
      expect(letterCombinations(''), equals([]));
    });
    test('Single digit', () {
      final result = letterCombinations('2');
      expect(result, containsAll(['a', 'b', 'c']));
    });
  });
}
