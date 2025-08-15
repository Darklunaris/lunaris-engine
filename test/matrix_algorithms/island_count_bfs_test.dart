import 'package:test/test.dart';
import 'package:lunaris_engine/matrix/island_count_bfs.dart';

void main() {
  group('Island Count (BFS)', () {
    test('Standard grid', () {
      final grid = [
        ['1', '1', '0', '0', '0'],
        ['1', '1', '0', '0', '0'],
        ['0', '0', '1', '0', '0'],
        ['0', '0', '0', '1', '1'],
      ];
      expect(numIslandsBFS(grid), equals(3));
    });
    test('No islands', () {
      final grid = [
        ['0', '0'],
        ['0', '0'],
      ];
      expect(numIslandsBFS(grid), equals(0));
    });
    test('All land', () {
      final grid = [
        ['1', '1'],
        ['1', '1'],
      ];
      expect(numIslandsBFS(grid), equals(1));
    });
  });
}
