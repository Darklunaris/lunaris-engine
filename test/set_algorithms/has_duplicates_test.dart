import 'package:lunaris_engine/Set/has_duplicates.dart';
import 'package:test/test.dart';

void main() {
  group('hasDuplicates', () {
    test('detects duplicates in int list', () {
      expect(hasDuplicates([1, 2, 3, 4, 2, 5]), isTrue);
    });

    test('detects no duplicates in int list', () {
      expect(hasDuplicates([10, 20, 30, 40]), isFalse);
    });

    test('detects duplicates in string list', () {
      expect(hasDuplicates(['a', 'b', 'c', 'a']), isTrue);
    });

    test('detects no duplicates in string list', () {
      expect(hasDuplicates(['x', 'y', 'z']), isFalse);
    });

    test('empty list returns false', () {
      expect(hasDuplicates([]), isFalse);
    });

    test('single element list returns false', () {
      expect(hasDuplicates([1]), isFalse);
    });
  });
}
