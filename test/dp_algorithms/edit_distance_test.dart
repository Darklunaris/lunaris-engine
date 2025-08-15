import 'package:test/test.dart';
import 'package:lunaris_engine/dp_algorithms/edit_distance.dart';

void main() {
  group('Edit Distance', () {
    test('Standard cases', () {
      expect(editDistance('kitten', 'sitting'), equals(3));
      expect(editDistance('flaw', 'lawn'), equals(2));
      expect(editDistance('intention', 'execution'), equals(5));
    });
    test('Empty string', () {
      expect(editDistance('', 'abc'), equals(3));
      expect(editDistance('abc', ''), equals(3));
      expect(editDistance('', ''), equals(0));
    });
    test('Identical strings', () {
      expect(editDistance('dart', 'dart'), equals(0));
    });
  });
}
