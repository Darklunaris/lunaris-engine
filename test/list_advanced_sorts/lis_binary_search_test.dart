import 'package:test/test.dart';
import 'package:lunaris_engine/ListAdvancedSorts/lis_binary_search.dart';

void main() {
  group('LIS Binary Search', () {
    test('Standard case', () {
      expect(lisBinarySearch([10, 9, 2, 5, 3, 7, 101, 18]), equals(4));
    });
    test('All increasing', () {
      expect(lisBinarySearch([1, 2, 3, 4, 5]), equals(5));
    });
    test('All decreasing', () {
      expect(lisBinarySearch([5, 4, 3, 2, 1]), equals(1));
    });
    test('Empty list', () {
      expect(lisBinarySearch([]), equals(0));
    });
    test('Single element', () {
      expect(lisBinarySearch([42]), equals(1));
    });
  });
}
