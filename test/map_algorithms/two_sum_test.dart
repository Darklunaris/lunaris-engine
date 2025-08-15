import 'package:lunaris_engine/map/two_sum.dart';
import 'package:test/test.dart';

void main() {
  group('Two Sum Tests', () {
    test('Find indices for integer list', () {
      expect(twoSum<int>([2, 7, 11, 15], 9), [0, 1]);
      expect(twoSum<int>([3, 2, 4], 6), [1, 2]);
      expect(twoSum<int>([3, 3], 6), [0, 1]);
      expect(twoSum<int>([1, 2, 3], 7), null);
    });

    test('Empty list returns null', () {
      expect(twoSum<int>([], 5), null);
    });
  });
}
