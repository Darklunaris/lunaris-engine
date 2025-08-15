import 'package:lunaris_engine/String/reverse_string.dart';
import 'package:test/test.dart';

void main() {
  group('Reverse String Tests', () {
    test('Basic string reversal', () {
      expect(reverseString('dart'), 'trad');
      expect(reverseString('hello'), 'olleh');
      expect(reverseString(''), '');
      expect(reverseString('a'), 'a');
      expect(reverseString('ab'), 'ba');
    });
  });
}
