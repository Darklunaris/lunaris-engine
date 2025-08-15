import 'package:test/test.dart';
import 'package:lunaris_engine/ListAdvancedSorts/max_product_subarray.dart';

void main() {
  group('Maximum Product Subarray', () {
    test('Standard case', () {
      expect(maxProductSubarray([2.0, 3.0, -2.0, 4.0]), equals(6.0));
    });
    test('All negative', () {
      expect(maxProductSubarray([-2.0, -3.0, -4.0]), equals(12.0));
    });
    test('Single element', () {
      expect(maxProductSubarray([5.0]), equals(5.0));
    });
    test('Throws on empty list', () {
      expect(() => maxProductSubarray([]), throwsArgumentError);
    });
    test('Zeros in array', () {
      expect(maxProductSubarray([0.0, 2.0, -1.0, 0.0, 3.0, -2.0]), equals(3.0));
    });
  });
}
