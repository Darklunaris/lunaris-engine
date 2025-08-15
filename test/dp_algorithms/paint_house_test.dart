import 'package:test/test.dart';
import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  group('minCostPaintHouse', () {
    test('example', () {
      final costs = [
        [17, 2, 17],
        [16, 16, 5],
        [14, 3, 19],
      ];
      expect(minCostPaintHouse(costs), equals(10));
    });

    test('single house', () {
      expect(
        minCostPaintHouse([
          [5, 7, 3],
        ]),
        equals(3),
      );
    });

    test('empty', () {
      expect(minCostPaintHouse([]), equals(0));
    });
  });
}
