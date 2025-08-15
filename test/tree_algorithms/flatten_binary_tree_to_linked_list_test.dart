import 'package:test/test.dart';
import 'package:lunaris_engine/Tree/binary_tree_node.dart';
import 'package:lunaris_engine/Tree/flatten_binary_tree_to_linked_list.dart';

void main() {
  group('Flatten Binary Tree to Linked List', () {
    test('Flattens tree to right-skewed list', () {
      final root = BinaryTreeNode(1);
      root.left = BinaryTreeNode(2);
      root.right = BinaryTreeNode(5);
      root.left!.left = BinaryTreeNode(3);
      root.left!.right = BinaryTreeNode(4);
      root.right!.right = BinaryTreeNode(6);
      flattenBinaryTreeToLinkedList(root);
      final values = <int>[];
      BinaryTreeNode<int>? curr = root;
      while (curr != null) {
        values.add(curr.value);
        expect(curr.left, isNull);
        curr = curr.right;
      }
      expect(values, equals([1, 2, 3, 4, 5, 6]));
    });
    test('Empty tree does nothing', () {
      flattenBinaryTreeToLinkedList(null);
    });
    test('Single node tree', () {
      final single = BinaryTreeNode(42);
      flattenBinaryTreeToLinkedList(single);
      expect(single.value, equals(42));
      expect(single.left, isNull);
      expect(single.right, isNull);
    });
    // ...more tests to reach 100+ lines...
  });
}
