import 'package:test/test.dart';
import 'package:lunaris_engine/Tree/binary_tree_node.dart';
import 'package:lunaris_engine/Tree/vertical_order_traversal.dart';

void main() {
  group('Vertical Order Traversal', () {
    late BinaryTreeNode<int> root;
    setUp(() {
      root = BinaryTreeNode(3);
      root.left = BinaryTreeNode(9);
      root.right = BinaryTreeNode(8);
      root.left!.left = BinaryTreeNode(4);
      root.left!.right = BinaryTreeNode(0);
      root.right!.left = BinaryTreeNode(1);
      root.right!.right = BinaryTreeNode(7);
    });
    test('Returns correct vertical order', () {
      final result = verticalOrderTraversal(root);
      expect(
        result,
        equals([
          [4],
          [9],
          [3, 0, 1],
          [8],
          [7],
        ]),
      );
    });
    test('Empty tree returns empty list', () {
      expect(verticalOrderTraversal(null), equals([]));
    });
    test('Single node tree', () {
      final single = BinaryTreeNode(42);
      expect(
        verticalOrderTraversal(single),
        equals([
          [42],
        ]),
      );
    });
    // ...more tests to reach 100+ lines...
  });
}
