/// 🌳 Tree Depth/Height Calculator
///
/// Calculates the maximum depth (height) of a binary tree.
/// The depth is the number of edges from the root to the deepest leaf.
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
/// final depth = treeDepth(root);
/// // depth: 2 (root->left->left = 2 edges)
/// ```
library;

import 'binary_tree_node.dart';

int treeDepth<T>(BinaryTreeNode<T>? root) {
  if (root == null) return -1;

  final int leftDepth = treeDepth(root.left);
  final int rightDepth = treeDepth(root.right);

  return 1 + (leftDepth > rightDepth ? leftDepth : rightDepth);
}
