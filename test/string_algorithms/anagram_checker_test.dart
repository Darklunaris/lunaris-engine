import 'package:lunaris_engine/String/anagram_checker.dart';
import 'package:test/test.dart';

void main() {
  group('Anagram Checker Tests', () {
    test('Valid anagrams', () {
      expect(areAnagrams("listen", "silent"), isTrue);
      expect(areAnagrams("Triangle", "Integral"), isTrue);
      expect(areAnagrams("a gentleman", "elegant man"), isTrue);
    });

    test('Invalid anagrams', () {
      expect(areAnagrams("hello", "world"), isFalse);
      expect(areAnagrams("rat", "car"), isFalse);
    });

    test('Case insensitivity and spaces', () {
      expect(areAnagrams("Dormitory", "Dirty room"), isTrue);
      expect(areAnagrams("School master", "The classroom"), isTrue);
    });

    test('Empty strings', () {
      expect(areAnagrams("", ""), isTrue);
      expect(areAnagrams("", "a"), isFalse);
    });
  });
}
