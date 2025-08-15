import 'package:test/test.dart';
import 'package:lunaris_engine/Tree/binary_tree_node.dart';
import 'package:lunaris_engine/Tree/lowest_common_ancestor.dart';

void main() {
  group('Lowest Common Ancestor Tests', () {
    late BinaryTreeNode<int> root;

    setUp(() {
      // Create a test tree:
      //       10
      //      /  \
      //     5    15
      //    / \   / \
      //   3   7 12  20
      //  /     \
      // 1       9
      root = BinaryTreeNode<int>(10);
      root.left = BinaryTreeNode<int>(5);
      root.right = BinaryTreeNode<int>(15);
      root.left!.left = BinaryTreeNode<int>(3);
      root.left!.right = BinaryTreeNode<int>(7);
      root.right!.left = BinaryTreeNode<int>(12);
      root.right!.right = BinaryTreeNode<int>(20);
      root.left!.left!.left = BinaryTreeNode<int>(1);
      root.left!.right!.right = BinaryTreeNode<int>(9);
    });

    test('Empty tree returns null', () {
      final result = lowestCommonAncestor(null, 5, 10);
      expect(result, isNull);
    });

    test('One node is root', () {
      final result = lowestCommonAncestor(root, 10, 5);
      expect(result!.value, equals(10));
    });

    test('Both nodes are same', () {
      final result = lowestCommonAncestor(root, 5, 5);
      expect(result!.value, equals(5));
    });

    test('Nodes in same subtree', () {
      final result = lowestCommonAncestor(root, 3, 7);
      expect(result!.value, equals(5));
    });

    test('Nodes in different subtrees', () {
      final result = lowestCommonAncestor(root, 3, 15);
      expect(result!.value, equals(10));
    });

    test('Deep nodes in same subtree', () {
      final result = lowestCommonAncestor(root, 1, 3);
      expect(result!.value, equals(3));
    });

    test('Deep nodes in different subtrees', () {
      final result = lowestCommonAncestor(root, 1, 20);
      expect(result!.value, equals(10));
    });

    test('Nodes at same level', () {
      final result = lowestCommonAncestor(root, 12, 20);
      expect(result!.value, equals(15));
    });

    test('One node is ancestor of other', () {
      final result = lowestCommonAncestor(root, 5, 9);
      expect(result!.value, equals(5));
    });

    test('Works with strings', () {
      final stringRoot = BinaryTreeNode<String>('root');
      stringRoot.left = BinaryTreeNode<String>('left');
      stringRoot.right = BinaryTreeNode<String>('right');
      stringRoot.left!.left = BinaryTreeNode<String>('left-left');

      final result = lowestCommonAncestor(stringRoot, 'left-left', 'right');
      expect(result!.value, equals('root'));
    });

    test('Works with doubles', () {
      final doubleRoot = BinaryTreeNode<double>(10.5);
      doubleRoot.left = BinaryTreeNode<double>(5.2);
      doubleRoot.right = BinaryTreeNode<double>(15.8);

      final result = lowestCommonAncestor(doubleRoot, 5.2, 15.8);
      expect(result!.value, equals(10.5));
    });

    test('One node not found returns the other node', () {
      final result = lowestCommonAncestor(root, 5, 999);
      expect(result!.value, equals(5));
    });

    test('Both nodes not found returns null', () {
      final result = lowestCommonAncestor(root, 999, 888);
      expect(result, isNull);
    });
  });
}
