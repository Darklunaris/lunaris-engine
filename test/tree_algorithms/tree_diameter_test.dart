import 'package:test/test.dart';
import 'package:lunaris_engine/Tree/binary_tree_node.dart';
import 'package:lunaris_engine/Tree/tree_diameter.dart';

void main() {
  group('Tree Diameter Tests', () {
    test('Empty tree returns 0', () {
      final result = treeDiameter(null);
      expect(result, equals(0));
    });

    test('Single node tree returns 0', () {
      final root = BinaryTreeNode<int>(42);
      final result = treeDiameter(root);
      expect(result, equals(0));
    });

    test('Tree with two nodes returns 1', () {
      final root = BinaryTreeNode<int>(10);
      root.left = BinaryTreeNode<int>(5);

      final result = treeDiameter(root);
      expect(result, equals(1));
    });

    test('Simple tree with diameter 2', () {
      //   10
      //  /  \
      // 5    15
      final root = BinaryTreeNode<int>(10);
      root.left = BinaryTreeNode<int>(5);
      root.right = BinaryTreeNode<int>(15);

      final result = treeDiameter(root);
      expect(result, equals(2));
    });

    test('Tree with diameter through root', () {
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

      final result = treeDiameter(root);
      expect(result, equals(4)); // Path: 3 -> 5 -> 10 -> 15 -> 20
    });

    test('Tree with diameter not through root', () {
      //       10
      //      /
      //     5
      //    / \
      //   3   7
      //  /     \
      // 1       9
      final root = BinaryTreeNode<int>(10);
      root.left = BinaryTreeNode<int>(5);
      root.left!.left = BinaryTreeNode<int>(3);
      root.left!.right = BinaryTreeNode<int>(7);
      root.left!.left!.left = BinaryTreeNode<int>(1);
      root.left!.right!.right = BinaryTreeNode<int>(9);

      final result = treeDiameter(root);
      expect(result, equals(4)); // Path: 1 -> 3 -> 5 -> 7 -> 9
    });

    test('Left-skewed tree', () {
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

      final result = treeDiameter(root);
      expect(result, equals(3)); // Path: 4 -> 3 -> 5 -> 10
    });

    test('Right-skewed tree', () {
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

      final result = treeDiameter(root);
      expect(result, equals(3)); // Path: 10 -> 15 -> 20 -> 25
    });

    test('Complex tree with diameter 5', () {
      //           10
      //          /  \
      //         5    15
      //        / \   / \
      //       3   7 12  20
      //      /     \
      //     1       9
      //    /         \
      //   0           11
      final root = BinaryTreeNode<int>(10);
      root.left = BinaryTreeNode<int>(5);
      root.right = BinaryTreeNode<int>(15);
      root.left!.left = BinaryTreeNode<int>(3);
      root.left!.right = BinaryTreeNode<int>(7);
      root.right!.left = BinaryTreeNode<int>(12);
      root.right!.right = BinaryTreeNode<int>(20);
      root.left!.left!.left = BinaryTreeNode<int>(1);
      root.left!.right!.right = BinaryTreeNode<int>(9);
      root.left!.left!.left!.left = BinaryTreeNode<int>(0);
      root.left!.right!.right!.right = BinaryTreeNode<int>(11);

      final result = treeDiameter(root);
      expect(result, equals(6)); // Path: 0 -> 1 -> 3 -> 5 -> 7 -> 9 -> 11
    });

    test('Works with strings', () {
      final root = BinaryTreeNode<String>('root');
      root.left = BinaryTreeNode<String>('left');
      root.right = BinaryTreeNode<String>('right');
      root.left!.left = BinaryTreeNode<String>('left-left');

      final result = treeDiameter(root);
      expect(result, equals(3)); // Path: left-left -> left -> root -> right
    });

    test('Works with doubles', () {
      final root = BinaryTreeNode<double>(10.5);
      root.left = BinaryTreeNode<double>(5.2);
      root.right = BinaryTreeNode<double>(15.8);

      final result = treeDiameter(root);
      expect(result, equals(2)); // Path: 5.2 -> 10.5 -> 15.8
    });
  });
}
