import 'package:test/test.dart';
import 'package:lunaris_engine/dp_algorithms/unique_paths_with_obstacles.dart';

void main() {
  group('Unique Paths With Obstacles', () {
    test('example grid', () {
      final grid = [
        [0, 0, 0],
        [0, 1, 0],
        [0, 0, 0],
      ];
      expect(uniquePathsWithObstacles(grid), equals(2));
    });
    test('blocked start', () {
      final grid = [
        [1],
      ];
      expect(uniquePathsWithObstacles(grid), equals(0));
    });
    test('single free cell', () {
      expect(
        uniquePathsWithObstacles([
          [0],
        ]),
        equals(1),
      );
    });
  });
}
