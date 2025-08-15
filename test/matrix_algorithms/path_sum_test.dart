import 'package:test/test.dart';
import 'package:lunaris_engine/matrix/path_sum.dart';

void main() {
  group('Path Sum in Matrix', () {
    test('Path exists', () {
      final matrix = [
        [5, 4, 2],
        [1, 9, 1],
        [1, 1, 1],
      ];
      // Path: 5->4->2->1->1 = 13 (only right and down moves allowed)
      // No path exists that sums to 14
      expect(hasPathSum(matrix, 13), isTrue);
      expect(hasPathSum(matrix, 14), isFalse);
    });
    test('No path', () {
      final matrix = [
        [1, 2],
        [3, 4],
      ];
      expect(hasPathSum(matrix, 100), isFalse);
    });
    test('Empty matrix', () {
      expect(hasPathSum(<List<int>>[], 0), isFalse);
    });
  });
}
