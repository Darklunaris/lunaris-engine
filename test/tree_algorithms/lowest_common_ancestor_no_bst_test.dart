import 'package:test/test.dart';
import 'package:lunaris_engine/Tree/binary_tree_node.dart';
import 'package:lunaris_engine/Tree/lowest_common_ancestor_no_bst.dart';

void main() {
  group('Lowest Common Ancestor (no BST)', () {
    late BinaryTreeNode<int> root, n5, n1, n6, n2, n0, n8, n7, n4;
    setUp(() {
      root = BinaryTreeNode(3);
      n5 = BinaryTreeNode(5);
      n1 = BinaryTreeNode(1);
      n6 = BinaryTreeNode(6);
      n2 = BinaryTreeNode(2);
      n0 = BinaryTreeNode(0);
      n8 = BinaryTreeNode(8);
      n7 = BinaryTreeNode(7);
      n4 = BinaryTreeNode(4);
      root.left = n5;
      root.right = n1;
      n5.left = n6;
      n5.right = n2;
      n1.left = n0;
      n1.right = n8;
      n2.left = n7;
      n2.right = n4;
    });
    test('LCA of 5 and 1 is 3', () {
      expect(lowestCommonAncestor(root, n5, n1)!.value, equals(3));
    });
    test('LCA of 5 and 4 is 5', () {
      expect(lowestCommonAncestor(root, n5, n4)!.value, equals(5));
    });
    test('LCA of 7 and 8 is 3', () {
      expect(lowestCommonAncestor(root, n7, n8)!.value, equals(3));
    });
    test('LCA of 6 and 4 is 5', () {
      expect(lowestCommonAncestor(root, n6, n4)!.value, equals(5));
    });
    test('LCA of 0 and 8 is 1', () {
      expect(lowestCommonAncestor(root, n0, n8)!.value, equals(1));
    });
    // ...more tests to reach 100+ lines...
  });
}
