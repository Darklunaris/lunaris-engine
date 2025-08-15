import 'package:lunaris_engine/String/count_vowels_consonants.dart';
import 'package:test/test.dart';

void main() {
  group('Count Vowels and Consonants', () {
    test('Basic tests', () {
      var result = countVowelsAndConsonants("Hello World! This is an Example.");
      expect(result['vowels'], 9);
      expect(result['consonants'], 16);

      result = countVowelsAndConsonants("");
      expect(result['vowels'], 0);
      expect(result['consonants'], 0);

      result = countVowelsAndConsonants("aeiou");
      expect(result['vowels'], 5);
      expect(result['consonants'], 0);

      result = countVowelsAndConsonants("bcdfg");
      expect(result['vowels'], 0);
      expect(result['consonants'], 5);

      result = countVowelsAndConsonants("12345!@#");
      expect(result['vowels'], 0);
      expect(result['consonants'], 0);
    });
  });
}
