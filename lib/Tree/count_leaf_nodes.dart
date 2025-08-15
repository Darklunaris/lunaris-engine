/// 🌳 Count Leaf Nodes in a Binary Tree
///
/// Counts the number of leaf nodes (nodes with no children) in a binary tree.
///
/// Time complexity: O(n)
/// Space complexity: O(h)
///
/// Example:
/// ```dart
/// final root = BinaryTreeNode<int>(10);
/// root.left = BinaryTreeNode<int>(5);
/// root.right = BinaryTreeNode<int>(15);
/// final count = countLeafNodes(root);
/// // count: 2
/// ```
library;

import 'binary_tree_node.dart';

int countLeafNodes<T>(BinaryTreeNode<T>? root) {
  if (root == null) return 0;
  if (root.left == null && root.right == null) return 1;
  return countLeafNodes(root.left) + countLeafNodes(root.right);
}
