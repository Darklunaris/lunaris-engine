import 'package:test/test.dart';
import 'package:lunaris_engine/matrix/surrounded_regions.dart';

void main() {
  group('Surrounded Regions', () {
    test('Standard board', () {
      final board = [
        ['X', 'X', 'X', 'X'],
        ['X', 'O', 'O', 'X'],
        ['X', 'X', 'O', 'X'],
        ['X', 'O', 'X', 'X'],
      ];
      solveSurroundedRegions(board);
      expect(
        board,
        equals([
          ['X', 'X', 'X', 'X'],
          ['X', 'X', 'X', 'X'],
          ['X', 'X', 'X', 'X'],
          ['X', 'O', 'X', 'X'],
        ]),
      );
    });
    test('No surrounded regions', () {
      final board = [
        ['O', 'O'],
        ['O', 'O'],
      ];
      solveSurroundedRegions(board);
      expect(
        board,
        equals([
          ['O', 'O'],
          ['O', 'O'],
        ]),
      );
    });
  });
}
