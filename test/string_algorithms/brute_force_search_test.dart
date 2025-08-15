import 'package:lunaris_engine/String/brute_force_search.dart';
import 'package:test/test.dart';

void main() {
  group('Brute Force Search Tests', () {
    test('Pattern found in text', () {
      expect(bruteForceSearch("hello world", "world"), 6);
      expect(bruteForceSearch("abcdef", "abc"), 0);
      expect(bruteForceSearch("abcdef", "def"), 3);
      expect(bruteForceSearch("aaaaaa", "aaa"), 0);
    });

    test('Pattern not found', () {
      expect(bruteForceSearch("hello world", "planet"), -1);
      expect(bruteForceSearch("abcdef", "gh"), -1);
    });

    test('Empty pattern matches at start', () {
      expect(bruteForceSearch("abc", ""), 0);
      expect(bruteForceSearch("", ""), 0);
    });

    test('Pattern longer than text', () {
      expect(bruteForceSearch("abc", "abcd"), -1);
    });
  });
}
