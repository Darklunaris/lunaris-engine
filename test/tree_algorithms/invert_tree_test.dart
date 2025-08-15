import 'package:test/test.dart';
import 'package:lunaris_engine/Tree/binary_tree_node.dart';
import 'package:lunaris_engine/Tree/invert_tree.dart';

void main() {
  group('Invert Tree Tests', () {
    test('Empty tree returns null', () {
      final result = invertTree(null);
      expect(result, isNull);
    });

    test('Single node tree remains unchanged', () {
      final root = BinaryTreeNode<int>(42);
      final result = invertTree(root);
      expect(result, equals(root));
      expect(result!.value, equals(42));
    });

    test('Simple tree with two children', () {
      final root = BinaryTreeNode<int>(10);
      root.left = BinaryTreeNode<int>(5);
      root.right = BinaryTreeNode<int>(15);

      final result = invertTree(root);

      // Check that children are swapped
      expect(result!.left!.value, equals(15));
      expect(result.right!.value, equals(5));
    });

    test('Complete binary tree', () {
      // Original:
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

      final result = invertTree(root);

      // Inverted:
      //       10
      //      /  \
      //     15   5
      //    / \   / \
      //   20  12 7  3
      expect(result!.left!.value, equals(15));
      expect(result.right!.value, equals(5));
      expect(result.left!.left!.value, equals(20));
      expect(result.left!.right!.value, equals(12));
      expect(result.right!.left!.value, equals(7));
      expect(result.right!.right!.value, equals(3));
    });

    test('Unbalanced tree', () {
      // Original:
      //   10
      //  /
      // 5
      //  \
      //   7
      final root = BinaryTreeNode<int>(10);
      root.left = BinaryTreeNode<int>(5);
      root.left!.right = BinaryTreeNode<int>(7);

      final result = invertTree(root);

      // Inverted:
      // 10
      //  \
      //   5
      //  /
      // 7
      expect(result!.left, isNull);
      expect(result.right!.value, equals(5));
      expect(result.right!.left!.value, equals(7));
      expect(result.right!.right, isNull);
    });

    test('Works with strings', () {
      final root = BinaryTreeNode<String>('root');
      root.left = BinaryTreeNode<String>('left');
      root.right = BinaryTreeNode<String>('right');

      final result = invertTree(root);

      expect(result!.left!.value, equals('right'));
      expect(result.right!.value, equals('left'));
    });

    test('Works with doubles', () {
      final root = BinaryTreeNode<double>(10.5);
      root.left = BinaryTreeNode<double>(5.2);
      root.right = BinaryTreeNode<double>(15.8);

      final result = invertTree(root);

      expect(result!.left!.value, equals(15.8));
      expect(result.right!.value, equals(5.2));
    });

    test('Double inversion returns original structure', () {
      final root = BinaryTreeNode<int>(10);
      root.left = BinaryTreeNode<int>(5);
      root.right = BinaryTreeNode<int>(15);
      root.left!.left = BinaryTreeNode<int>(3);
      root.left!.right = BinaryTreeNode<int>(7);

      final firstInversion = invertTree(root);
      final secondInversion = invertTree(firstInversion);

      // After double inversion, should be back to original
      expect(secondInversion!.left!.value, equals(5));
      expect(secondInversion.right!.value, equals(15));
      expect(secondInversion.left!.left!.value, equals(3));
      expect(secondInversion.left!.right!.value, equals(7));
    });
  });
}
