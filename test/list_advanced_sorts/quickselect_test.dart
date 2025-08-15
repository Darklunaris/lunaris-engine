import 'package:test/test.dart';
import 'package:lunaris_engine/ListAdvancedSorts/quickselect.dart';

void main() {
  group('Quickselect', () {
    test('Finds k-th smallest integer', () {
      final arr = [7, 10, 4, 3, 20, 15];
      expect(quickselect(List<int>.from(arr), 2), equals(7));
      expect(quickselect(List<int>.from(arr), 0), equals(3));
      expect(quickselect(List<int>.from(arr), 5), equals(20));
    });
    test('Finds k-th smallest double', () {
      final arr = [3.2, 1.5, 4.8, 2.1];
      expect(quickselect(List<double>.from(arr), 2), equals(3.2));
    });
    test('Throws on out of bounds', () {
      expect(() => quickselect([1, 2, 3], -1), throwsArgumentError);
      expect(() => quickselect([1, 2, 3], 3), throwsArgumentError);
    });
  });
}
