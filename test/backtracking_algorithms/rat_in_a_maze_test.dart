import 'package:test/test.dart';
import 'package:lunaris_engine/Backtracking/rat_in_a_maze.dart';

void main() {
  group('Rat in a Maze', () {
    test('Standard case', () {
      final maze = [
        [1, 0, 0, 0],
        [1, 1, 0, 1],
        [0, 1, 0, 0],
        [1, 1, 1, 1],
      ];
      final result = ratInMaze(maze);
      expect(result, equals(['DRDDRR']));
    });
    test('No path', () {
      final maze = [
        [1, 0],
        [0, 1],
      ];
      expect(ratInMaze(maze), equals([]));
    });
    test('Single cell open', () {
      expect(
        ratInMaze([
          [1],
        ]),
        equals(['']),
      );
    });
    test('Single cell blocked', () {
      expect(
        ratInMaze([
          [0],
        ]),
        equals([]),
      );
    });
  });
}
