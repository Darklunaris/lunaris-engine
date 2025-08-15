/// 🌳 Tree Inverter (Mirror Tree)
///
/// Inverts a binary tree by swapping left and right children recursively.
/// Returns the root of the inverted tree.
///
/// Time complexity: O(n) where n is the number of nodes
/// Space complexity: O(h) where h is the height of the tree (worst case O(n))
///
/// Example:
/// ```dart
/// final root = BinaryTreeNode<int>(10);
/// root.left = BinaryTreeNode<int>(5);
/// root.right = BinaryTreeNode<int>(15);
/// final inverted = invertTree(root);
/// // Now: root.left = 15, root.right = 5
/// ```
library;

import 'binary_tree_node.dart';

BinaryTreeNode<T>? invertTree<T>(BinaryTreeNode<T>? root) {
  if (root == null) return null;

  // Swap left and right children
  final BinaryTreeNode<T>? temp = root.left;
  root.left = root.right;
  root.right = temp;

  // Recursively invert subtrees
  invertTree(root.left);
  invertTree(root.right);

  return root;
}
