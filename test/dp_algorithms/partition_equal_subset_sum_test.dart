import 'package:test/test.dart';
import 'package:lunaris_engine/dp_algorithms/partition_equal_subset_sum.dart';

void main() {
  group('Partition Equal Subset Sum', () {
    test('Standard cases', () {
      expect(canPartition([1, 5, 11, 5]), isTrue);
      expect(canPartition([1, 2, 3, 5]), isFalse);
    });
    test('Empty list', () {
      expect(canPartition([]), isTrue);
    });
    test('Single element', () {
      expect(canPartition([2]), isFalse);
    });
    test('All zeros', () {
      expect(canPartition([0, 0, 0, 0]), isTrue);
    });
  });
}
