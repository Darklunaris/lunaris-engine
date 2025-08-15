import 'package:test/test.dart';
import 'package:lunaris_engine/Tree/binary_tree_node.dart';
import 'package:lunaris_engine/Tree/tree_depth.dart';

void main() {
  group('Tree Depth Tests', () {
    test('Empty tree returns -1', () {
      final result = treeDepth(null);
      expect(result, equals(-1));
    });

    test('Single node tree returns 0', () {
      final root = BinaryTreeNode<int>(42);
      final result = treeDepth(root);
      expect(result, equals(0));
    });

    test('Simple tree with depth 1', () {
      final root = BinaryTreeNode<int>(10);
      root.left = BinaryTreeNode<int>(5);
      root.right = BinaryTreeNode<int>(15);

      final result = treeDepth(root);
      expect(result, equals(1));
    });

    test('Unbalanced tree with depth 2', () {
      //   10
      //  /
      // 5
      //  \
      //   7
      final root = BinaryTreeNode<int>(10);
      root.left = BinaryTreeNode<int>(5);
      root.left!.right = BinaryTreeNode<int>(7);

      final result = treeDepth(root);
      expect(result, equals(2));
    });

    test('Complete binary tree with depth 2', () {
      //       10
      //      /  \
      //     5    15
      //    / \   / \
      //   3   7 12  20
      final root = BinaryTreeNode<int>(10);
      root.left = BinaryTreeNode<int>(5);
      root.right = BinaryTreeNode<int>(15);
      root.left!.left = BinaryTreeNode<int>(3);
      root.left!.right = BinaryTreeNode<int>(7);
      root.right!.left = BinaryTreeNode<int>(12);
      root.right!.right = BinaryTreeNode<int>(20);

      final result = treeDepth(root);
      expect(result, equals(2));
    });

    test('Left-skewed tree with depth 3', () {
      //     10
      //    /
      //   5
      //  /
      // 3
      //  \
      //   4
      final root = BinaryTreeNode<int>(10);
      root.left = BinaryTreeNode<int>(5);
      root.left!.left = BinaryTreeNode<int>(3);
      root.left!.left!.right = BinaryTreeNode<int>(4);

      final result = treeDepth(root);
      expect(result, equals(3));
    });

    test('Right-skewed tree with depth 3', () {
      // 10
      //  \
      //   15
      //    \
      //     20
      //      \
      //       25
      final root = BinaryTreeNode<int>(10);
      root.right = BinaryTreeNode<int>(15);
      root.right!.right = BinaryTreeNode<int>(20);
      root.right!.right!.right = BinaryTreeNode<int>(25);

      final result = treeDepth(root);
      expect(result, equals(3));
    });

    test('Works with strings', () {
      final root = BinaryTreeNode<String>('root');
      root.left = BinaryTreeNode<String>('left');
      root.left!.left = BinaryTreeNode<String>('left-left');

      final result = treeDepth(root);
      expect(result, equals(2));
    });

    test('Works with doubles', () {
      final root = BinaryTreeNode<double>(10.5);
      root.right = BinaryTreeNode<double>(15.8);

      final result = treeDepth(root);
      expect(result, equals(1));
    });
  });
}
