import 'package:test/test.dart';
import 'package:lunaris_engine/Tree/binary_tree_node.dart';
import 'package:lunaris_engine/Tree/tree_serialization.dart';
import 'package:lunaris_engine/Tree/level_order_traversal.dart';

void main() {
  group('Tree Serialization Tests', () {
    test('Empty tree serializes to empty string', () {
      final result = serializeTree(null);
      expect(result, equals(''));
    });

    test('Single node tree', () {
      final root = BinaryTreeNode<int>(42);
      final serialized = serializeTree(root);
      expect(serialized, equals('42'));

      final deserialized = deserializeTree<int>(serialized);
      expect(deserialized!.value, equals(42));
      expect(deserialized.left, isNull);
      expect(deserialized.right, isNull);
    });

    test('Simple tree with two children', () {
      final root = BinaryTreeNode<int>(10);
      root.left = BinaryTreeNode<int>(5);
      root.right = BinaryTreeNode<int>(15);

      final serialized = serializeTree(root);
      expect(serialized, equals('10,5,15'));

      final deserialized = deserializeTree<int>(serialized);
      expect(deserialized!.value, equals(10));
      expect(deserialized.left!.value, equals(5));
      expect(deserialized.right!.value, equals(15));
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

      final serialized = serializeTree(root);
      expect(serialized, equals('10,5,15,3,7,12,20'));

      final deserialized = deserializeTree<int>(serialized);
      expect(deserialized!.value, equals(10));
      expect(deserialized.left!.value, equals(5));
      expect(deserialized.right!.value, equals(15));
      expect(deserialized.left!.left!.value, equals(3));
      expect(deserialized.left!.right!.value, equals(7));
      expect(deserialized.right!.left!.value, equals(12));
      expect(deserialized.right!.right!.value, equals(20));
    });

    test('Unbalanced tree with missing children', () {
      //   10
      //  /
      // 5
      //  \
      //   7
      final root = BinaryTreeNode<int>(10);
      root.left = BinaryTreeNode<int>(5);
      root.left!.right = BinaryTreeNode<int>(7);

      final serialized = serializeTree(root);
      expect(serialized, equals('10,5,null,null,7'));

      final deserialized = deserializeTree<int>(serialized);
      expect(deserialized!.value, equals(10));
      expect(deserialized.left!.value, equals(5));
      expect(deserialized.right, isNull);
      expect(deserialized.left!.left, isNull);
      expect(deserialized.left!.right!.value, equals(7));
    });

    test('Works with strings', () {
      final root = BinaryTreeNode<String>('root');
      root.left = BinaryTreeNode<String>('left');
      root.right = BinaryTreeNode<String>('right');

      final serialized = serializeTree(root);
      expect(serialized, equals('root,left,right'));

      final deserialized = deserializeTree<String>(serialized);
      expect(deserialized!.value, equals('root'));
      expect(deserialized.left!.value, equals('left'));
      expect(deserialized.right!.value, equals('right'));
    });

    test('Works with doubles', () {
      final root = BinaryTreeNode<double>(10.5);
      root.left = BinaryTreeNode<double>(5.2);
      root.right = BinaryTreeNode<double>(15.8);

      final serialized = serializeTree(root);
      expect(serialized, equals('10.5,5.2,15.8'));

      final deserialized = deserializeTree<double>(serialized);
      expect(deserialized!.value, equals(10.5));
      expect(deserialized.left!.value, equals(5.2));
      expect(deserialized.right!.value, equals(15.8));
    });

    test('Deserialize empty string returns null', () {
      final result = deserializeTree<int>('');
      expect(result, isNull);
    });

    test('Deserialize null string returns null', () {
      final result = deserializeTree<int>('null');
      expect(result, isNull);
    });

    test('Round trip serialization preserves structure', () {
      // Create a complex tree
      final root = BinaryTreeNode<int>(10);
      root.left = BinaryTreeNode<int>(5);
      root.right = BinaryTreeNode<int>(15);
      root.left!.left = BinaryTreeNode<int>(3);
      root.left!.right = BinaryTreeNode<int>(7);
      root.right!.left = BinaryTreeNode<int>(12);
      root.right!.right = BinaryTreeNode<int>(20);
      root.left!.left!.left = BinaryTreeNode<int>(1);
      root.left!.right!.right = BinaryTreeNode<int>(9);

      // Serialize and deserialize
      final serialized = serializeTree(root);
      final deserialized = deserializeTree<int>(serialized);

      // Compare level order traversals to verify structure
      final originalTraversal = levelOrderTraversal(root);
      final deserializedTraversal = levelOrderTraversal(deserialized);

      expect(deserializedTraversal, equals(originalTraversal));
    });

    test('Handles simple strings without special characters', () {
      final root = BinaryTreeNode<String>('root');
      root.left = BinaryTreeNode<String>('left');
      root.right = BinaryTreeNode<String>('right');

      final serialized = serializeTree(root);
      final deserialized = deserializeTree<String>(serialized);

      expect(deserialized!.value, equals('root'));
      expect(deserialized.left!.value, equals('left'));
      expect(deserialized.right!.value, equals('right'));
    });
  });
}
