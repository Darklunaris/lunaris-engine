import 'package:test/test.dart';
import 'package:lunaris_engine/matrix/matrix_rotation.dart';

void main() {
  group('Matrix Rotation', () {
    test('3x3 matrix', () {
      final matrix = [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9],
      ];
      rotateMatrix(matrix);
      expect(
        matrix,
        equals([
          [7, 4, 1],
          [8, 5, 2],
          [9, 6, 3],
        ]),
      );
    });
    test('4x4 matrix', () {
      final matrix = [
        [5, 1, 9, 11],
        [2, 4, 8, 10],
        [13, 3, 6, 7],
        [15, 14, 12, 16],
      ];
      rotateMatrix(matrix);
      expect(
        matrix,
        equals([
          [15, 13, 2, 5],
          [14, 3, 4, 1],
          [12, 6, 8, 9],
          [16, 7, 10, 11],
        ]),
      );
    });
  });
}
