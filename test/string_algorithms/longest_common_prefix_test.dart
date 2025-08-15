import 'package:lunaris_engine/String/longest_common_prefix.dart';
import 'package:test/test.dart';

void main() {
  group('Longest Common Prefix Tests', () {
    test('Common prefix exists', () {
      expect(longestCommonPrefix(["flower", "flow", "flight"]), "fl");
      expect(
        longestCommonPrefix(["interview", "internet", "interval"]),
        "inter",
      ); // صححنا هنا
      expect(longestCommonPrefix(["single"]), "single");
    });

    test('No common prefix', () {
      expect(longestCommonPrefix(["dog", "racecar", "car"]), "");
      expect(longestCommonPrefix([]), "");
    });
  });
}
