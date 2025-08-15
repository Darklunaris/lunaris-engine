import 'package:test/test.dart';
import 'package:lunaris_engine/dp_algorithms/knapsack_01.dart';

void main() {
  group('0/1 Knapsack', () {
    test('Basic example', () {
      final weights = [1, 2, 3];
      final values = [6, 10, 12];
      final capacity = 5;
      expect(knapsack01(weights, values, capacity), equals(22));
    });

    test('Zero capacity', () {
      expect(knapsack01([1, 2, 3], [6, 10, 12], 0), equals(0));
    });

    test('No items', () {
      expect(knapsack01([], [], 10), equals(0));
    });

    test('Single item fits', () {
      expect(knapsack01([5], [99], 5), equals(99));
    });

    test('Single item does not fit', () {
      expect(knapsack01([10], [99], 5), equals(0));
    });
  });
}
