/// 🌳 Count Half Nodes in a Binary Tree
///
/// Counts the number of half nodes (nodes with exactly one child) in a binary tree.
///
/// Time complexity: O(n)
/// Space complexity: O(h)
///
/// Example:
/// ```dart
/// final root = BinaryTreeNode<int>(10);
/// root.left = BinaryTreeNode<int>(5);
/// root.right = BinaryTreeNode<int>(15);
/// final count = countHalfNodes(root);
/// // count: 0
/// ```
library;

import 'binary_tree_node.dart';

int countHalfNodes<T>(BinaryTreeNode<T>? root) {
  if (root == null) return 0;
  int count = 0;
  if ((root.left == null) != (root.right == null)) count = 1;
  return count + countHalfNodes(root.left) + countHalfNodes(root.right);
}
