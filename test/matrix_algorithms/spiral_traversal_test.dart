import 'package:test/test.dart';
import 'package:lunaris_engine/matrix/spiral_traversal.dart';

void main() {
  group('Spiral Traversal', () {
    test('3x3 matrix', () {
      final matrix = [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9],
      ];
      expect(spiralOrder(matrix), equals([1, 2, 3, 6, 9, 8, 7, 4, 5]));
    });
    test('Single row', () {
      expect(
        spiralOrder([
          [1, 2, 3],
        ]),
        equals([1, 2, 3]),
      );
    });
    test('Single column', () {
      expect(
        spiralOrder([
          [1],
          [2],
          [3],
        ]),
        equals([1, 2, 3]),
      );
    });
    test('Empty matrix', () {
      expect(spiralOrder([]), equals([]));
    });
  });
}
