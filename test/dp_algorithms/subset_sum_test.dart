import 'package:test/test.dart';
import 'package:lunaris_engine/dp_algorithms/subset_sum.dart';

void main() {
  group('Subset Sum', () {
    test('Standard cases', () {
      expect(subsetSum([3, 34, 4, 12, 5, 2], 9), isTrue);
      expect(subsetSum([3, 34, 4, 12, 5, 2], 30), isFalse);
    });
    test('Empty list', () {
      expect(subsetSum(<int>[], 0), isTrue);
      expect(subsetSum(<int>[], 1), isFalse);
    });
    test('Single element', () {
      expect(subsetSum([5], 5), isTrue);
      expect(subsetSum([5], 3), isFalse);
    });
  });
}
