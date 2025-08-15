import 'package:test/test.dart';
import 'package:lunaris_engine/Tree/binary_tree_node.dart';
import 'package:lunaris_engine/Tree/tree_traversals.dart';

void main() {
  group('Tree Traversal Tests', () {
    late BinaryTreeNode<int> root;

    setUp(() {
      // Create a test tree:
      //       10
      //      /  \
      //     5    15
      //    / \   / \
      //   3   7 12  20
      root = BinaryTreeNode<int>(10);
      root.left = BinaryTreeNode<int>(5);
      root.right = BinaryTreeNode<int>(15);
      root.left!.left = BinaryTreeNode<int>(3);
      root.left!.right = BinaryTreeNode<int>(7);
      root.right!.left = BinaryTreeNode<int>(12);
      root.right!.right = BinaryTreeNode<int>(20);
    });

    group('Inorder Traversal', () {
      test('Traverses tree in correct order', () {
        final result = inorderTraversal(root);
        expect(result, equals([3, 5, 7, 10, 12, 15, 20]));
      });

      test('Empty tree returns empty list', () {
        final result = inorderTraversal(null);
        expect(result, equals([]));
      });

      test('Single node tree', () {
        final singleNode = BinaryTreeNode<int>(42);
        final result = inorderTraversal(singleNode);
        expect(result, equals([42]));
      });

      test('Left-skewed tree', () {
        final leftSkewed = BinaryTreeNode<int>(3);
        leftSkewed.left = BinaryTreeNode<int>(2);
        leftSkewed.left!.left = BinaryTreeNode<int>(1);

        final result = inorderTraversal(leftSkewed);
        expect(result, equals([1, 2, 3]));
      });
    });

    group('Preorder Traversal', () {
      test('Traverses tree in correct order', () {
        final result = preorderTraversal(root);
        expect(result, equals([10, 5, 3, 7, 15, 12, 20]));
      });

      test('Empty tree returns empty list', () {
        final result = preorderTraversal(null);
        expect(result, equals([]));
      });

      test('Single node tree', () {
        final singleNode = BinaryTreeNode<int>(42);
        final result = preorderTraversal(singleNode);
        expect(result, equals([42]));
      });

      test('Right-skewed tree', () {
        final rightSkewed = BinaryTreeNode<int>(1);
        rightSkewed.right = BinaryTreeNode<int>(2);
        rightSkewed.right!.right = BinaryTreeNode<int>(3);

        final result = preorderTraversal(rightSkewed);
        expect(result, equals([1, 2, 3]));
      });
    });

    group('Postorder Traversal', () {
      test('Traverses tree in correct order', () {
        final result = postorderTraversal(root);
        expect(result, equals([3, 7, 5, 12, 20, 15, 10]));
      });

      test('Empty tree returns empty list', () {
        final result = postorderTraversal(null);
        expect(result, equals([]));
      });

      test('Single node tree', () {
        final singleNode = BinaryTreeNode<int>(42);
        final result = postorderTraversal(singleNode);
        expect(result, equals([42]));
      });

      test('Complete binary tree', () {
        final complete = BinaryTreeNode<int>(1);
        complete.left = BinaryTreeNode<int>(2);
        complete.right = BinaryTreeNode<int>(3);
        complete.left!.left = BinaryTreeNode<int>(4);
        complete.left!.right = BinaryTreeNode<int>(5);
        complete.right!.left = BinaryTreeNode<int>(6);
        complete.right!.right = BinaryTreeNode<int>(7);

        final result = postorderTraversal(complete);
        expect(result, equals([4, 5, 2, 6, 7, 3, 1]));
      });
    });

    group('Generic Type Tests', () {
      test('Works with strings', () {
        final stringRoot = BinaryTreeNode<String>('root');
        stringRoot.left = BinaryTreeNode<String>('left');
        stringRoot.right = BinaryTreeNode<String>('right');

        final inorder = inorderTraversal(stringRoot);
        final preorder = preorderTraversal(stringRoot);
        final postorder = postorderTraversal(stringRoot);

        expect(inorder, equals(['left', 'root', 'right']));
        expect(preorder, equals(['root', 'left', 'right']));
        expect(postorder, equals(['left', 'right', 'root']));
      });

      test('Works with doubles', () {
        final doubleRoot = BinaryTreeNode<double>(10.5);
        doubleRoot.left = BinaryTreeNode<double>(5.2);
        doubleRoot.right = BinaryTreeNode<double>(15.8);

        final inorder = inorderTraversal(doubleRoot);
        expect(inorder, equals([5.2, 10.5, 15.8]));
      });
    });
  });
}
