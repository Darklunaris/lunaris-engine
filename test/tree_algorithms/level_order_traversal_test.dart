import 'package:test/test.dart';
import 'package:lunaris_engine/Tree/binary_tree_node.dart';
import 'package:lunaris_engine/Tree/level_order_traversal.dart';

void main() {
  group('Level Order Traversal Tests', () {
    test('Empty tree returns empty list', () {
      final result = levelOrderTraversal(null);
      expect(result, equals([]));
    });

    test('Single node tree', () {
      final root = BinaryTreeNode<int>(42);
      final result = levelOrderTraversal(root);
      expect(
        result,
        equals([
          [42],
        ]),
      );
    });

    test('Simple tree with two levels', () {
      final root = BinaryTreeNode<int>(10);
      root.left = BinaryTreeNode<int>(5);
      root.right = BinaryTreeNode<int>(15);

      final result = levelOrderTraversal(root);
      expect(
        result,
        equals([
          [10],
          [5, 15],
        ]),
      );
    });

    test('Complete binary tree', () {
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

      final result = levelOrderTraversal(root);
      expect(
        result,
        equals([
          [10],
          [5, 15],
          [3, 7, 12, 20],
        ]),
      );
    });

    test('Unbalanced tree', () {
      //   10
      //  /
      // 5
      //  \
      //   7
      final root = BinaryTreeNode<int>(10);
      root.left = BinaryTreeNode<int>(5);
      root.left!.right = BinaryTreeNode<int>(7);

      final result = levelOrderTraversal(root);
      expect(
        result,
        equals([
          [10],
          [5],
          [7],
        ]),
      );
    });

    test('Right-skewed tree', () {
      // 10
      //  \
      //   15
      //    \
      //     20
      final root = BinaryTreeNode<int>(10);
      root.right = BinaryTreeNode<int>(15);
      root.right!.right = BinaryTreeNode<int>(20);

      final result = levelOrderTraversal(root);
      expect(
        result,
        equals([
          [10],
          [15],
          [20],
        ]),
      );
    });

    test('Works with strings', () {
      final root = BinaryTreeNode<String>('root');
      root.left = BinaryTreeNode<String>('left');
      root.right = BinaryTreeNode<String>('right');
      root.left!.left = BinaryTreeNode<String>('left-left');

      final result = levelOrderTraversal(root);
      expect(
        result,
        equals([
          ['root'],
          ['left', 'right'],
          ['left-left'],
        ]),
      );
    });

    test('Works with doubles', () {
      final root = BinaryTreeNode<double>(10.5);
      root.left = BinaryTreeNode<double>(5.2);
      root.right = BinaryTreeNode<double>(15.8);

      final result = levelOrderTraversal(root);
      expect(
        result,
        equals([
          [10.5],
          [5.2, 15.8],
        ]),
      );
    });
  });
}
