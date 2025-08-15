import 'package:test/test.dart';
import 'package:lunaris_engine/Backtracking/combination_sum.dart';

void main() {
  group('Combination Sum', () {
    test('candidates = [2,3,6,7], target = 7', () {
      final result = combinationSum([2, 3, 6, 7], 7);
      expect(
        result,
        containsAll([
          [7],
          [2, 2, 3],
        ]),
      );
    });
    test('candidates = [2,3,5], target = 8', () {
      final result = combinationSum([2, 3, 5], 8);
      expect(
        result,
        containsAll([
          [2, 2, 2, 2],
          [2, 3, 3],
          [3, 5],
        ]),
      );
    });
    test('No solution', () {
      expect(combinationSum([2], 1), equals([]));
    });
  });
}
