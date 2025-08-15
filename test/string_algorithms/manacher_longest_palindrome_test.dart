import 'package:test/test.dart';
import 'package:lunaris_engine/String/manacher_longest_palindrome.dart';

void main() {
  test('manacherLongestPalindrome basic', () {
    expect(manacherLongestPalindrome('babad'), anyOf('bab', 'aba'));
    expect(manacherLongestPalindrome('cbbd'), equals('bb'));
    expect(manacherLongestPalindrome('a'), equals('a'));
    expect(manacherLongestPalindrome(''), equals(''));
  });
}
