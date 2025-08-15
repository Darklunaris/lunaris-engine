import 'package:lunaris_engine/Set/find_intersection.dart';
import 'package:test/test.dart';

void main() {
  group('findIntersection', () {
    test('integers with intersection', () {
      expect(findIntersection([1, 2, 3, 4], [3, 4, 5]), equals([3, 4]));
    });

    test('integers with no intersection', () {
      expect(findIntersection([1, 2], [3, 4]), isEmpty);
    });

    test('strings', () {
      expect(
        findIntersection(['apple', 'banana'], ['banana', 'cherry']),
        equals(['banana']),
      );
    });

    test('mixed order', () {
      expect(
        findIntersection([5, 10, 15, 20], [20, 15, 10]),
        equals([20, 15, 10]),
      );
    });

    test('duplicates in second list', () {
      expect(
        findIntersection([1, 2, 3], [2, 2, 3, 3, 4]),
        equals([2, 2, 3, 3]),
      );
    });
  });
}
