import 'package:test/test.dart';
import 'package:lunaris_engine/matrix/flood_fill.dart';

void main() {
  group('Flood Fill', () {
    test('Standard fill', () {
      final image = [
        [1, 1, 1],
        [1, 1, 0],
        [1, 0, 1],
      ];
      final result = floodFill(image, 1, 1, 2);
      expect(
        result,
        equals([
          [2, 2, 2],
          [2, 2, 0],
          [2, 0, 1],
        ]),
      );
    });
    test('No change if color is same', () {
      final image = [
        [0, 0, 0],
        [0, 1, 1],
      ];
      final result = floodFill(image, 1, 1, 1);
      expect(
        result,
        equals([
          [0, 0, 0],
          [0, 1, 1],
        ]),
      );
    });
  });
}
