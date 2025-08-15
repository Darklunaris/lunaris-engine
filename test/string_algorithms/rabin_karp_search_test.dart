import 'package:lunaris_engine/String/rabin_karp_search.dart';
import 'package:test/test.dart';

void main() {
  group('Rabin-Karp Search Tests', () {
    test('Pattern found in text', () {
      expect(rabinKarpSearch("hello world", "world"), 6);
      expect(rabinKarpSearch("abcdef", "abc"), 0);
      expect(rabinKarpSearch("abcdef", "def"), 3);
      expect(rabinKarpSearch("aaaaaa", "aaa"), 0);
    });

    test('Pattern not found', () {
      expect(rabinKarpSearch("hello world", "planet"), -1);
      expect(rabinKarpSearch("abcdef", "gh"), -1);
    });

    test('Empty pattern matches at start', () {
      expect(rabinKarpSearch("abc", ""), 0);
      expect(rabinKarpSearch("", ""), 0);
    });

    test('Pattern longer than text', () {
      expect(rabinKarpSearch("abc", "abcd"), -1);
    });
  });
}
