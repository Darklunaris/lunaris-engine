import 'package:test/test.dart';
import 'package:lunaris_engine/dp_algorithms/rod_cutting.dart';

void main() {
  group('Rod Cutting', () {
    test('Standard cases', () {
      expect(rodCutting([1, 5, 8, 9, 10, 17, 17, 20], 8), equals(22));
      expect(rodCutting([2, 5, 7, 8], 5), equals(12));
    });
    test('Zero length', () {
      expect(rodCutting([1, 2, 3], 0), equals(0));
    });
    test('Single length', () {
      expect(rodCutting([5], 1), equals(5));
    });
    test('No prices', () {
      expect(rodCutting([], 5), equals(0));
    });
  });
}
