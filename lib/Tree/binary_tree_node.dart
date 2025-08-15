/// 🌳 Generic Binary Tree Node
///
/// A node in a binary tree containing a value of type [T] and references
/// to left and right child nodes.
///
/// Example:
/// ```dart
/// final node = BinaryTreeNode<int>(10);
/// node.left = BinaryTreeNode<int>(5);
/// node.right = BinaryTreeNode<int>(15);
/// ```
library;

class BinaryTreeNode<T> {
  T value;
  BinaryTreeNode<T>? left;
  BinaryTreeNode<T>? right;

  BinaryTreeNode(this.value, {this.left, this.right});

  @override
  String toString() => 'BinaryTreeNode($value)';
}
