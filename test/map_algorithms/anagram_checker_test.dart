import 'package:lunaris_engine/map/anagram_checker.dart';
import 'package:test/test.dart';

void main() {
  group('Anagram Tests', () {
    test('String anagrams with case and spaces ignored', () {
      expect(isAnagram<String>("Listen".split(''), "Silent".split('')), isTrue);
      expect(
        isAnagram<String>(
          "Dormitory".split(''),
          "Dirty room".replaceAll(' ', '').split(''),
        ),
        isTrue,
      );
      expect(isAnagram<String>("Hello".split(''), "Olelh".split('')), isTrue);
      expect(isAnagram<String>("Hello".split(''), "World".split('')), isFalse);
    });

    test('List of integers anagrams', () {
      expect(isAnagram<int>([1, 2, 3], [3, 2, 1]), isTrue);
      expect(isAnagram<int>([1, 2, 2], [2, 1, 1]), isFalse);
    });

    test('Empty lists', () {
      expect(isAnagram<String>([], []), isTrue);
      expect(isAnagram<int>([], [1]), isFalse);
    });
  });
}
