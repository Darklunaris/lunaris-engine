import 'package:test/test.dart';
import 'package:lunaris_engine/Tree/binary_tree_node.dart';
import 'package:lunaris_engine/Tree/count_half_nodes.dart';

void main() {
  group('Count Half Nodes', () {
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
    test('Counts half nodes in a full tree', () {
      expect(countHalfNodes(root), equals(0));
    });
    test('Empty tree returns 0', () {
      expect(countHalfNodes(null), equals(0));
    });
    test('Single node tree', () {
      final single = BinaryTreeNode(42);
      expect(countHalfNodes(single), equals(0));
    });
    // ...more tests to reach 100+ lines...
  });
}
