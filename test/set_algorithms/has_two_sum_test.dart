import 'package:lunaris_engine/Set/has_two_sum.dart';
import 'package:test/test.dart';

void main() {
  group('hasTwoSum', () {
    test('pair exists', () {
      expect(hasTwoSum([2, 7, 11, 15], 9), isTrue);
    });

    test('no valid pair', () {
      expect(hasTwoSum([1, 2, 3, 4], 10), isFalse);
    });

    test('pair at beginning and end', () {
      expect(hasTwoSum([1, 3, 5, 7, 9], 10), isTrue);
    });

    test('duplicate numbers forming pair', () {
      expect(hasTwoSum([5, 3, 5], 10), isTrue);
    });

    test('decimal numbers', () {
      expect(hasTwoSum([1.5, 3.5, 2.0], 5.0), isTrue);
      expect(hasTwoSum([1.1, 2.2, 3.3], 10.0), isFalse);
    });
  });
}
