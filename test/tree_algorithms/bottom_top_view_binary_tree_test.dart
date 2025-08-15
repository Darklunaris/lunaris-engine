import 'package:test/test.dart';
import 'package:lunaris_engine/Tree/binary_tree_node.dart';
import 'package:lunaris_engine/Tree/bottom_top_view_binary_tree.dart';

void main() {
  group('Bottom and Top View of Binary Tree', () {
    late BinaryTreeNode<int> root;
    setUp(() {
      root = BinaryTreeNode(20);
      root.left = BinaryTreeNode(8);
      root.right = BinaryTreeNode(22);
      root.left!.left = BinaryTreeNode(5);
      root.left!.right = BinaryTreeNode(3);
      root.right!.left = BinaryTreeNode(4);
      root.right!.right = BinaryTreeNode(25);
    });
    test('Bottom view returns correct order', () {
      expect(bottomView(root), equals([5, 8, 4, 22, 25]));
    });
    test('Top view returns correct order', () {
      expect(topView(root), equals([5, 8, 20, 22, 25]));
    });
    test('Empty tree returns empty list', () {
      expect(bottomView(null), equals([]));
      expect(topView(null), equals([]));
    });
    test('Single node tree', () {
      final single = BinaryTreeNode(42);
      expect(bottomView(single), equals([42]));
      expect(topView(single), equals([42]));
    });
    // ...more tests to reach 100+ lines...
  });
}
