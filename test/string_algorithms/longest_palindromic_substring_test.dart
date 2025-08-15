import 'package:lunaris_engine/String/longest_palindromic_substring.dart';
import 'package:test/test.dart';

void main() {
  group('Longest Palindromic Substring Tests', () {
    test('Basic test cases', () {
      var result1 = longestPalindrome("babad");
      expect(["bab", "aba"], contains(result1)); // both valid answers

      var result2 = longestPalindrome("cbbd");
      expect(result2, "bb");

      var result3 = longestPalindrome("");
      expect(result3, "");

      var result4 = longestPalindrome("a");
      expect(result4, "a");

      var result5 = longestPalindrome("ac");
      expect(["a", "c"], contains(result5));
    });
  });
}
