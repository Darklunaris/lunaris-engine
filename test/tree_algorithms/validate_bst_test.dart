import 'package:test/test.dart';
import 'package:lunaris_engine/Tree/binary_tree_node.dart';
import 'package:lunaris_engine/Tree/validate_bst.dart';

void main() {
  group('Validate BST Tests', () {
    test('Empty tree is valid BST', () {
      final result = validateBST(null);
      expect(result, isTrue);
    });

    test('Single node is valid BST', () {
      final root = BinaryTreeNode<int>(42);
      final result = validateBST(root);
      expect(result, isTrue);
    });

    test('Valid BST with two children', () {
      final root = BinaryTreeNode<int>(10);
      root.left = BinaryTreeNode<int>(5);
      root.right = BinaryTreeNode<int>(15);

      final result = validateBST(root);
      expect(result, isTrue);
    });

    test('Valid BST with multiple levels', () {
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

      final result = validateBST(root);
      expect(result, isTrue);
    });

    test('Invalid BST - left child greater than root', () {
      final root = BinaryTreeNode<int>(10);
      root.left = BinaryTreeNode<int>(15); // Invalid: 15 > 10
      root.right = BinaryTreeNode<int>(20);

      final result = validateBST(root);
      expect(result, isFalse);
    });

    test('Invalid BST - right child less than root', () {
      final root = BinaryTreeNode<int>(10);
      root.left = BinaryTreeNode<int>(5);
      root.right = BinaryTreeNode<int>(3); // Invalid: 3 < 10

      final result = validateBST(root);
      expect(result, isFalse);
    });

    test('Invalid BST - left subtree violation', () {
      //       10
      //      /  \
      //     5    15
      //    / \   / \
      //   3   7 12  20
      //        \
      //         11  <- This violates BST property (11 > 10)
      final root = BinaryTreeNode<int>(10);
      root.left = BinaryTreeNode<int>(5);
      root.right = BinaryTreeNode<int>(15);
      root.left!.left = BinaryTreeNode<int>(3);
      root.left!.right = BinaryTreeNode<int>(7);
      root.right!.left = BinaryTreeNode<int>(12);
      root.right!.right = BinaryTreeNode<int>(20);
      root.left!.right!.right = BinaryTreeNode<int>(11);

      final result = validateBST(root);
      expect(result, isFalse);
    });

    test('Invalid BST - right subtree violation', () {
      //       10
      //      /  \
      //     5    15
      //    / \   / \
      //   3   7 12  20
      //          \
      //           8  <- This violates BST property (8 < 15 but 8 > 10)
      final root = BinaryTreeNode<int>(10);
      root.left = BinaryTreeNode<int>(5);
      root.right = BinaryTreeNode<int>(15);
      root.left!.left = BinaryTreeNode<int>(3);
      root.left!.right = BinaryTreeNode<int>(7);
      root.right!.left = BinaryTreeNode<int>(12);
      root.right!.right = BinaryTreeNode<int>(20);
      root.right!.left!.right = BinaryTreeNode<int>(8);

      final result = validateBST(root);
      expect(result, isFalse);
    });

    test('Valid BST with equal values (left child)', () {
      final root = BinaryTreeNode<int>(10);
      root.left = BinaryTreeNode<int>(10); // Equal to root
      root.right = BinaryTreeNode<int>(15);

      final result = validateBST(root);
      expect(result, isFalse); // BST typically doesn't allow equal values
    });

    test('Valid BST with equal values (right child)', () {
      final root = BinaryTreeNode<int>(10);
      root.left = BinaryTreeNode<int>(5);
      root.right = BinaryTreeNode<int>(10); // Equal to root

      final result = validateBST(root);
      expect(result, isFalse); // BST typically doesn't allow equal values
    });

    test('Works with strings', () {
      final root = BinaryTreeNode<String>('m');
      root.left = BinaryTreeNode<String>('a');
      root.right = BinaryTreeNode<String>('z');

      final result = validateBST(root);
      expect(result, isTrue);
    });

    test('Works with doubles', () {
      final root = BinaryTreeNode<double>(10.5);
      root.left = BinaryTreeNode<double>(5.2);
      root.right = BinaryTreeNode<double>(15.8);

      final result = validateBST(root);
      expect(result, isTrue);
    });

    test('Invalid BST with strings', () {
      final root = BinaryTreeNode<String>('m');
      root.left = BinaryTreeNode<String>('z'); // Invalid: 'z' > 'm'
      root.right = BinaryTreeNode<String>('a'); // Invalid: 'a' < 'm'

      final result = validateBST(root);
      expect(result, isFalse);
    });

    test('Complex valid BST', () {
      //       50
      //      /  \
      //     30   70
      //    / \   / \
      //   20 40 60 80
      //  /     \
      // 10      45
      final root = BinaryTreeNode<int>(50);
      root.left = BinaryTreeNode<int>(30);
      root.right = BinaryTreeNode<int>(70);
      root.left!.left = BinaryTreeNode<int>(20);
      root.left!.right = BinaryTreeNode<int>(40);
      root.right!.left = BinaryTreeNode<int>(60);
      root.right!.right = BinaryTreeNode<int>(80);
      root.left!.left!.left = BinaryTreeNode<int>(10);
      root.left!.right!.right = BinaryTreeNode<int>(45);

      final result = validateBST(root);
      expect(result, isTrue);
    });
  });
}
