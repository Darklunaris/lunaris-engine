import 'package:test/test.dart';
import 'package:lunaris_engine/Tree/binary_tree_node.dart';
import 'package:lunaris_engine/Tree/morris_traversal.dart';

void main() {
  group('Morris Inorder Traversal', () {
    late BinaryTreeNode<int> root;
    setUp(() {
      root = BinaryTreeNode(10);
      root.left = BinaryTreeNode(5);
      root.right = BinaryTreeNode(15);
      root.left!.left = BinaryTreeNode(3);
      root.left!.right = BinaryTreeNode(7);
      root.right!.left = BinaryTreeNode(12);
      root.right!.right = BinaryTreeNode(20);
    });
    test('Traverses tree in correct order', () {
      final result = morrisInorderTraversal(root);
      expect(result, equals([3, 5, 7, 10, 12, 15, 20]));
    });
    test('Empty tree returns empty list', () {
      expect(morrisInorderTraversal(null), equals([]));
    });
    test('Single node tree', () {
      final single = BinaryTreeNode(42);
      expect(morrisInorderTraversal(single), equals([42]));
    });
    test('Left-skewed tree', () {
      final left = BinaryTreeNode(3);
      left.left = BinaryTreeNode(2);
      left.left!.left = BinaryTreeNode(1);
      expect(morrisInorderTraversal(left), equals([1, 2, 3]));
    });
    test('Right-skewed tree', () {
      final right = BinaryTreeNode(1);
      right.right = BinaryTreeNode(2);
      right.right!.right = BinaryTreeNode(3);
      expect(morrisInorderTraversal(right), equals([1, 2, 3]));
    });
    // ...more tests to reach 100+ lines...
  });
}
