import 'package:test/test.dart';
import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  group('cherryPickup', () {
    test('small grid', () {
      final grid = [
        [0, 1, -1],
        [1, 0, -1],
        [1, 1, 1],
      ];
      expect(cherryPickup(grid), greaterThanOrEqualTo(0));
    });
  });
}
