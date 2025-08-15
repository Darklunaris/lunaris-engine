import 'package:test/test.dart';
import 'package:lunaris_engine/String/longest_repeating_substring.dart';

void main() {
  test('longestRepeatingSubstring basic', () {
    expect(longestRepeatingSubstring('banana'), equals('ana'));
    expect(longestRepeatingSubstring('abcd'), equals(''));
  });
}
