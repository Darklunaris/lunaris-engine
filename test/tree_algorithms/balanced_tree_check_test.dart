import 'package:test/test.dart';
import 'package:lunaris_engine/Tree/binary_tree_node.dart';
import 'package:lunaris_engine/Tree/balanced_tree_check.dart';

void main() {
  group('Balanced Tree Check Tests', () {
    test('Empty tree is balanced', () {
      final result = isBalancedTree(null);
      expect(result, isTrue);
    });

    test('Single node tree is balanced', () {
      final root = BinaryTreeNode<int>(42);
      final result = isBalancedTree(root);
      expect(result, isTrue);
    });

    test('Tree with two children is balanced', () {
      final root = BinaryTreeNode<int>(10);
      root.left = BinaryTreeNode<int>(5);
      root.right = BinaryTreeNode<int>(15);

      final result = isBalancedTree(root);
      expect(result, isTrue);
    });

    test('Tree with one child is balanced', () {
      final root = BinaryTreeNode<int>(10);
      root.left = BinaryTreeNode<int>(5);

      final result = isBalancedTree(root);
      expect(result, isTrue);
    });

    test('Complete binary tree is balanced', () {
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

      final result = isBalancedTree(root);
      expect(result, isTrue);
    });

    test('Unbalanced tree - left heavy', () {
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

      final result = isBalancedTree(root);
      expect(result, isFalse);
    });

    test('Unbalanced tree - right heavy', () {
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

      final result = isBalancedTree(root);
      expect(result, isFalse);
    });

    test('Unbalanced tree - height difference > 1', () {
      //       10
      //      /  \
      //     5    15
      //    / \   / \
      //   3   7 12  20
      //  /     \
      // 1       9
      //  \
      //   2
      final root = BinaryTreeNode<int>(10);
      root.left = BinaryTreeNode<int>(5);
      root.right = BinaryTreeNode<int>(15);
      root.left!.left = BinaryTreeNode<int>(3);
      root.left!.right = BinaryTreeNode<int>(7);
      root.right!.left = BinaryTreeNode<int>(12);
      root.right!.right = BinaryTreeNode<int>(20);
      root.left!.left!.left = BinaryTreeNode<int>(1);
      root.left!.right!.right = BinaryTreeNode<int>(9);
      root.left!.left!.left!.right = BinaryTreeNode<int>(2);

      final result = isBalancedTree(root);
      expect(result, isFalse);
    });

    test('Balanced tree with height difference = 1', () {
      //       10
      //      /  \
      //     5    15
      //    / \   /
      //   3   7 12
      final root = BinaryTreeNode<int>(10);
      root.left = BinaryTreeNode<int>(5);
      root.right = BinaryTreeNode<int>(15);
      root.left!.left = BinaryTreeNode<int>(3);
      root.left!.right = BinaryTreeNode<int>(7);
      root.right!.left = BinaryTreeNode<int>(12);

      final result = isBalancedTree(root);
      expect(result, isTrue);
    });

    test('Complex balanced tree', () {
      //           10
      //          /  \
      //         5    15
      //        / \   / \
      //       3   7 12  20
      //      /     \
      //     1       9
      final root = BinaryTreeNode<int>(10);
      root.left = BinaryTreeNode<int>(5);
      root.right = BinaryTreeNode<int>(15);
      root.left!.left = BinaryTreeNode<int>(3);
      root.left!.right = BinaryTreeNode<int>(7);
      root.right!.left = BinaryTreeNode<int>(12);
      root.right!.right = BinaryTreeNode<int>(20);
      root.left!.left!.left = BinaryTreeNode<int>(1);
      root.left!.right!.right = BinaryTreeNode<int>(9);

      final result = isBalancedTree(root);
      expect(result, isTrue);
    });

    test('Works with strings', () {
      final root = BinaryTreeNode<String>('root');
      root.left = BinaryTreeNode<String>('left');
      root.right = BinaryTreeNode<String>('right');
      root.left!.left = BinaryTreeNode<String>('left-left');

      final result = isBalancedTree(root);
      expect(result, isTrue);
    });

    test('Works with doubles', () {
      final root = BinaryTreeNode<double>(10.5);
      root.left = BinaryTreeNode<double>(5.2);
      root.right = BinaryTreeNode<double>(15.8);

      final result = isBalancedTree(root);
      expect(result, isTrue);
    });

    test('Unbalanced tree with strings', () {
      final root = BinaryTreeNode<String>('root');
      root.left = BinaryTreeNode<String>('left');
      root.left!.left = BinaryTreeNode<String>('left-left');
      root.left!.left!.left = BinaryTreeNode<String>('left-left-left');

      final result = isBalancedTree(root);
      expect(result, isFalse);
    });
  });
}
