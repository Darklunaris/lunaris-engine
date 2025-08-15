import 'package:test/test.dart';
import 'package:lunaris_engine/dp_algorithms/longest_common_subsequence.dart';

void main() {
  group('Longest Common Subsequence', () {
    test('Standard case', () {
      expect(longestCommonSubsequence('abcde', 'ace'), equals(3));
      expect(longestCommonSubsequence('abc', 'abc'), equals(3));
      expect(longestCommonSubsequence('abc', 'def'), equals(0));
    });
    test('Empty string', () {
      expect(longestCommonSubsequence('', 'abc'), equals(0));
      expect(longestCommonSubsequence('abc', ''), equals(0));
    });
    test('Single character', () {
      expect(longestCommonSubsequence('a', 'a'), equals(1));
      expect(longestCommonSubsequence('a', 'b'), equals(0));
    });
  });
}
