import 'package:test/test.dart';
import 'package:lunaris_engine/Tree/binary_tree_node.dart';
import 'package:lunaris_engine/Tree/path_sum_in_tree.dart';

void main() {
  group('Path Sum in Tree', () {
    late BinaryTreeNode<int> root;
    setUp(() {
      root = BinaryTreeNode(5);
      root.left = BinaryTreeNode(4);
      root.right = BinaryTreeNode(8);
      root.left!.left = BinaryTreeNode(11);
      root.right!.left = BinaryTreeNode(13);
      root.right!.right = BinaryTreeNode(4);
      root.left!.left!.left = BinaryTreeNode(7);
      root.left!.left!.right = BinaryTreeNode(2);
    });
    test('Path sum exists', () {
      expect(hasPathSum(root, 27), isTrue); // 5->4->11->7
      expect(hasPathSum(root, 22), isTrue); // 5->4->11->2
    });
    test('Path sum does not exist', () {
      expect(hasPathSum(root, 100), isFalse);
    });
    test('Empty tree returns false', () {
      expect(hasPathSum(null, 0), isFalse);
    });
    test('Single node tree', () {
      final single = BinaryTreeNode(42);
      expect(hasPathSum(single, 42), isTrue);
      expect(hasPathSum(single, 0), isFalse);
    });
    // ...more tests to reach 100+ lines...
  });
}
