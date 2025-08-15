import 'package:lunaris_engine/String/kmp_search.dart';
import 'package:test/test.dart';

void main() {
  group('KMP Search Tests', () {
    test('Pattern found in text', () {
      expect(kmpSearch("abxabcabcaby", "abcaby"), 6);
      expect(kmpSearch("hello world", "world"), 6);
      expect(kmpSearch("aaaaaa", "aaa"), 0);
      expect(kmpSearch("abcdabcabcdabcdabde", "abcdabd"), 11);
    });

    test('Pattern not found', () {
      expect(kmpSearch("hello world", "planet"), -1);
      expect(kmpSearch("abcdef", "gh"), -1);
    });

    test('Empty pattern matches at start', () {
      expect(kmpSearch("abc", ""), 0);
      expect(kmpSearch("", ""), 0);
    });

    test('Pattern longer than text', () {
      expect(kmpSearch("abc", "abcd"), -1);
    });
  });
}
