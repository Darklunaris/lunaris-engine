import 'package:lunaris_engine/map/length_of_longest_substring.dart';
import 'package:test/test.dart';

void main() {
  group('Length Of Longest Substring Tests', () {
    test('Basic test cases', () {
      expect(lengthOfLongestSubstring("abcabcbb"), 3);
      expect(lengthOfLongestSubstring("bbbbb"), 1);
      expect(lengthOfLongestSubstring("pwwkew"), 3);
      expect(lengthOfLongestSubstring(""), 0);
      expect(lengthOfLongestSubstring("au"), 2);
      expect(lengthOfLongestSubstring("dvdf"), 3);
    });
  });
}
