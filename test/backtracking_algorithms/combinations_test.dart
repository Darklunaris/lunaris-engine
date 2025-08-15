import 'package:test/test.dart';
import 'package:lunaris_engine/Backtracking/combinations.dart';

void main() {
  group('Combinations', () {
    test('n=4, k=2', () {
      final result = combine(4, 2);
      expect(
        result,
        containsAll([
          [1, 2],
          [1, 3],
          [1, 4],
          [2, 3],
          [2, 4],
          [3, 4],
        ]),
      );
      expect(result.length, equals(6));
    });
    test('n=1, k=1', () {
      expect(
        combine(1, 1),
        equals([
          [1],
        ]),
      );
    });
    test('k=0', () {
      expect(combine(3, 0), equals([[]]));
    });
  });
}
