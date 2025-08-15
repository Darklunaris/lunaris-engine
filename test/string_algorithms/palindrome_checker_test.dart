import 'package:lunaris_engine/String/palindrome_checker.dart';
import 'package:test/test.dart';

void main() {
  group('Palindrome Checker Tests', () {
    test('Various palindrome and non-palindrome strings', () {
      expect(isPalindromes("racecar"), isTrue);
      expect(isPalindromes("Level"), isTrue);
      expect(isPalindromes("A man a plan a canal Panama"), isTrue);
      expect(isPalindromes("Hello"), isFalse);
      expect(isPalindromes("No lemon no melon"), isTrue);
    });

    test('Empty and single character strings', () {
      expect(isPalindromes(""), isTrue);
      expect(isPalindromes("a"), isTrue);
      expect(isPalindromes(" "), isTrue);
    });
  });
}
