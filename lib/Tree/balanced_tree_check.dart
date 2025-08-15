/// 🌳 Balanced Tree Checker
///
/// Checks if a binary tree is height-balanced. A tree is height-balanced
/// if the heights of the left and right subtrees of every node differ by
/// at most one.
///
/// Time complexity: O(n) where n is the number of nodes
/// Space complexity: O(h) where h is the height of the tree (worst case O(n))
///
/// Example:
/// ```dart
/// final root = BinaryTreeNode<int>(10);
/// root.left = BinaryTreeNode<int>(5);
/// root.right = BinaryTreeNode<int>(15);
/// root.left!.left = BinaryTreeNode<int>(3);
/// final isBalanced = isBalancedTree(root);
/// // isBalanced: true
/// ```
library;

import 'binary_tree_node.dart';

bool isBalancedTree<T>(BinaryTreeNode<T>? root) {
  return _checkBalance(root) != -1;
}

int _checkBalance<T>(BinaryTreeNode<T>? root) {
  if (root == null) return 0;

  final int leftHeight = _checkBalance(root.left);
  if (leftHeight == -1) return -1; // Left subtree is unbalanced

  final int rightHeight = _checkBalance(root.right);
  if (rightHeight == -1) return -1; // Right subtree is unbalanced

  // Check if current node is balanced
  if ((leftHeight - rightHeight).abs() > 1) return -1;

  return 1 + (leftHeight > rightHeight ? leftHeight : rightHeight);
}
