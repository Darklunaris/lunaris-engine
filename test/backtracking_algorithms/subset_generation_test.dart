import 'package:test/test.dart';
import 'package:lunaris_engine/Backtracking/subset_generation.dart';

void main() {
  group('Subset Generation', () {
    test('Subsets of [1,2,3]', () {
      final result = subsets([1, 2, 3]);
      expect(
        result,
        containsAll([
          [],
          [1],
          [2],
          [3],
          [1, 2],
          [1, 3],
          [2, 3],
          [1, 2, 3],
        ]),
      );
      expect(result.length, equals(8));
    });
    test('Empty list', () {
      expect(subsets([]), equals([[]]));
    });
    test('Single element', () {
      expect(
        subsets([42]),
        equals([
          [],
          [42],
        ]),
      );
    });
  });
}
