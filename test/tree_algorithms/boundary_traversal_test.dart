import 'package:test/test.dart';
import 'package:lunaris_engine/Tree/binary_tree_node.dart';
import 'package:lunaris_engine/Tree/boundary_traversal.dart';

void main() {
  group('Boundary Traversal', () {
    late BinaryTreeNode<int> root;
    setUp(() {
      root = BinaryTreeNode(1);
      root.left = BinaryTreeNode(2);
      root.right = BinaryTreeNode(3);
      root.left!.left = BinaryTreeNode(4);
      root.left!.right = BinaryTreeNode(5);
      root.right!.left = BinaryTreeNode(6);
      root.right!.right = BinaryTreeNode(7);
    });
    test('Returns correct boundary', () {
      final result = boundaryTraversal(root);
      expect(result, equals([1, 2, 4, 5, 6, 7, 3]));
    });
    test('Empty tree returns empty list', () {
      expect(boundaryTraversal(null), equals([]));
    });
    test('Single node tree', () {
      final single = BinaryTreeNode(42);
      expect(boundaryTraversal(single), equals([42]));
    });
    // ...more tests to reach 100+ lines...
  });
}
