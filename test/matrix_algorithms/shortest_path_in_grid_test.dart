import 'package:test/test.dart';
import 'package:lunaris_engine/matrix/shortest_path_in_grid.dart';

void main() {
  group('Shortest Path in Grid', () {
    test('Standard grid', () {
      final grid = [
        [1, 1, 0, 1],
        [1, 1, 1, 1],
        [0, 1, 0, 1],
        [1, 1, 1, 1],
      ];
      expect(shortestPathInGrid(grid), equals(7));
    });
    test('No path', () {
      final grid = [
        [1, 0],
        [0, 1],
      ];
      expect(shortestPathInGrid(grid), equals(-1));
    });
    test('Blocked start or end', () {
      expect(
        shortestPathInGrid([
          [0, 1],
          [1, 1],
        ]),
        equals(-1),
      );
      expect(
        shortestPathInGrid([
          [1, 1],
          [1, 0],
        ]),
        equals(-1),
      );
    });
  });
}
