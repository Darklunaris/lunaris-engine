import 'package:lunaris_engine/Set/set_difference.dart';
import 'package:test/test.dart';

void main() {
  group('setDifference', () {
    test('integers - basic difference', () {
      expect(setDifference([1, 2, 3], [2, 4]), equals([1, 3]));
    });

    test('integers - no difference', () {
      expect(setDifference([1, 2], [1, 2]), isEmpty);
    });

    test('integers - disjoint sets', () {
      expect(setDifference([1, 2], [3, 4]), equals([1, 2]));
    });

    test('strings - mixed', () {
      expect(setDifference(['a', 'b', 'c'], ['b']), equals(['a', 'c']));
    });

    test('duplicate elements', () {
      expect(setDifference([1, 2, 2, 3], [2]), equals([1, 3]));
    });
  });
}
