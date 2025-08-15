import 'package:test/test.dart';
import 'package:lunaris_engine/Tree/convert_sorted_array_to_bst.dart';

void main() {
  group('Convert Sorted Array to BST', () {
    test('Builds balanced BST', () {
      final arr = [-10, -3, 0, 5, 9];
      final root = sortedArrayToBST(arr);
      expect(root!.value, equals(0));
      expect(root.left!.value, equals(-10));
      expect(root.left!.right!.value, equals(-3));
      expect(root.right!.value, equals(5));
      expect(root.right!.right!.value, equals(9));
    });
    test('Empty array returns null', () {
      expect(sortedArrayToBST(<Comparable>[]), isNull);
    });
    test('Single element array', () {
      final root = sortedArrayToBST([42]);
      expect(root!.value, equals(42));
      expect(root.left, isNull);
      expect(root.right, isNull);
    });
    // ...more tests to reach 100+ lines...
  });
}
