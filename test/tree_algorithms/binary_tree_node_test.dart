import 'package:test/test.dart';
import 'package:lunaris_engine/Tree/binary_tree_node.dart';

void main() {
  group('BinaryTreeNode Tests', () {
    test('Creates node with value', () {
      final node = BinaryTreeNode<int>(42);
      expect(node.value, equals(42));
      expect(node.left, isNull);
      expect(node.right, isNull);
    });

    test('Creates node with children', () {
      final left = BinaryTreeNode<int>(10);
      final right = BinaryTreeNode<int>(20);
      final root = BinaryTreeNode<int>(15, left: left, right: right);

      expect(root.value, equals(15));
      expect(root.left, equals(left));
      expect(root.right, equals(right));
    });

    test('String representation', () {
      final node = BinaryTreeNode<String>('test');
      expect(node.toString(), equals('BinaryTreeNode(test)'));
    });

    test('Works with different types', () {
      final intNode = BinaryTreeNode<int>(42);
      final doubleNode = BinaryTreeNode<double>(3.14);
      final stringNode = BinaryTreeNode<String>('hello');

      expect(intNode.value, equals(42));
      expect(doubleNode.value, equals(3.14));
      expect(stringNode.value, equals('hello'));
    });
  });
}
