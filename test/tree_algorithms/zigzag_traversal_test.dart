import 'package:test/test.dart';
import 'package:lunaris_engine/Tree/binary_tree_node.dart';
import 'package:lunaris_engine/Tree/zigzag_traversal.dart';

void main() {
  group('Zigzag Traversal Tests', () {
    test('Empty tree returns empty list', () {
      final result = zigzagTraversal(null);
      expect(result, equals([]));
    });

    test('Single node tree', () {
      final root = BinaryTreeNode<int>(42);
      final result = zigzagTraversal(root);
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

      final result = zigzagTraversal(root);
      expect(
        result,
        equals([
          [10],
          [15, 5],
        ]),
      ); // Level 1: left-to-right, Level 2: right-to-left
    });

    test('Complete binary tree with three levels', () {
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

      final result = zigzagTraversal(root);
      expect(
        result,
        equals([
          [10],
          [15, 5],
          [3, 7, 12, 20],
        ]),
      );
      // Level 0: left-to-right [10]
      // Level 1: right-to-left [15, 5]
      // Level 2: left-to-right [3, 7, 12, 20]
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

      final result = zigzagTraversal(root);
      expect(
        result,
        equals([
          [10],
          [5],
          [7],
        ]),
      );
      // Level 0: left-to-right [10]
      // Level 1: right-to-left [5]
      // Level 2: left-to-right [7]
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

      final result = zigzagTraversal(root);
      expect(
        result,
        equals([
          [10],
          [15],
          [20],
        ]),
      );
      // Level 0: left-to-right [10]
      // Level 1: right-to-left [15]
      // Level 2: left-to-right [20]
    });

    test('Complex tree with four levels', () {
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

      final result = zigzagTraversal(root);
      expect(
        result,
        equals([
          [10],
          [15, 5],
          [3, 7, 12, 20],
          [9, 1],
        ]),
      );
      // Level 0: left-to-right [10]
      // Level 1: right-to-left [15, 5]
      // Level 2: left-to-right [3, 7, 12, 20]
      // Level 3: right-to-left [9, 1]
    });

    test('Works with strings', () {
      final root = BinaryTreeNode<String>('root');
      root.left = BinaryTreeNode<String>('left');
      root.right = BinaryTreeNode<String>('right');
      root.left!.left = BinaryTreeNode<String>('left-left');

      final result = zigzagTraversal(root);
      expect(
        result,
        equals([
          ['root'],
          ['right', 'left'],
          ['left-left'],
        ]),
      );
    });

    test('Works with doubles', () {
      final root = BinaryTreeNode<double>(10.5);
      root.left = BinaryTreeNode<double>(5.2);
      root.right = BinaryTreeNode<double>(15.8);

      final result = zigzagTraversal(root);
      expect(
        result,
        equals([
          [10.5],
          [15.8, 5.2],
        ]),
      );
    });

    test('Tree with only left children', () {
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

      final result = zigzagTraversal(root);
      expect(
        result,
        equals([
          [10],
          [5],
          [3],
          [4],
        ]),
      );
    });

    test('Tree with only right children', () {
      // 10
      //  \
      //   15
      //    \
      //     20
      //    /
      //   18
      final root = BinaryTreeNode<int>(10);
      root.right = BinaryTreeNode<int>(15);
      root.right!.right = BinaryTreeNode<int>(20);
      root.right!.right!.left = BinaryTreeNode<int>(18);

      final result = zigzagTraversal(root);
      expect(
        result,
        equals([
          [10],
          [15],
          [20],
          [18],
        ]),
      );
    });
  });
}
