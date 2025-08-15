import 'package:test/test.dart';
import 'package:lunaris_engine/dp_algorithms/matrix_path_sum.dart';

void main() {
  group('Matrix Path Sum', () {
    test('Standard grid', () {
      final grid = [
        [1, 3, 1],
        [1, 5, 1],
        [4, 2, 1],
      ];
      expect(minPathSum(grid), equals(7));
    });
    test('Single row', () {
      expect(
        minPathSum([
          [1, 2, 3],
        ]),
        equals(6),
      );
    });
    test('Single column', () {
      expect(
        minPathSum([
          [1],
          [2],
          [3],
        ]),
        equals(6),
      );
    });
    test('Empty grid', () {
      expect(() => minPathSum([]), throwsArgumentError);
      expect(() => minPathSum([[]]), throwsArgumentError);
    });
  });
}
