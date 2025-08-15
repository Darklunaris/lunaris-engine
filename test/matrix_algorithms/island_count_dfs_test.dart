import 'package:test/test.dart';
import 'package:lunaris_engine/matrix/island_count_dfs.dart';

void main() {
  group('Island Count (DFS)', () {
    test('Standard grid', () {
      final grid = [
        ['1', '1', '0', '0', '0'],
        ['1', '1', '0', '0', '0'],
        ['0', '0', '1', '0', '0'],
        ['0', '0', '0', '1', '1'],
      ];
      expect(numIslandsDFS(grid), equals(3));
    });
    test('No islands', () {
      final grid = [
        ['0', '0'],
        ['0', '0'],
      ];
      expect(numIslandsDFS(grid), equals(0));
    });
    test('All land', () {
      final grid = [
        ['1', '1'],
        ['1', '1'],
      ];
      expect(numIslandsDFS(grid), equals(1));
    });
  });
}
