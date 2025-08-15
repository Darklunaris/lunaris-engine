import 'package:test/test.dart';
import 'package:lunaris_engine/Backtracking/permutations.dart';

void main() {
  group('Permutations', () {
    test('Permutations of [1,2,3]', () {
      final result = permutations([1, 2, 3]);
      expect(
        result,
        containsAll([
          [1, 2, 3],
          [1, 3, 2],
          [2, 1, 3],
          [2, 3, 1],
          [3, 1, 2],
          [3, 2, 1],
        ]),
      );
      expect(result.length, equals(6));
    });
    test('Empty list', () {
      expect(permutations([]), equals([[]]));
    });
    test('Single element', () {
      expect(
        permutations([42]),
        equals([
          [42],
        ]),
      );
    });
  });
}
