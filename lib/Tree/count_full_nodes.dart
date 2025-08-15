/// 🌳 Count Full Nodes in a Binary Tree
///
/// Counts the number of full nodes (nodes with both left and right children) in a binary tree.
///
/// Time complexity: O(n)
/// Space complexity: O(h)
///
/// Example:
/// ```dart
/// final root = BinaryTreeNode<int>(10);
/// root.left = BinaryTreeNode<int>(5);
/// root.right = BinaryTreeNode<int>(15);
/// final count = countFullNodes(root);
/// // count: 1
/// ```
library;

import 'binary_tree_node.dart';

int countFullNodes<T>(BinaryTreeNode<T>? root) {
  if (root == null) return 0;
  int count = 0;
  if (root.left != null && root.right != null) count = 1;
  return count + countFullNodes(root.left) + countFullNodes(root.right);
}
