/// 🌳 Lowest Common Ancestor in Binary Tree (not BST)
///
/// Finds the lowest common ancestor (LCA) of two nodes in a binary tree.
///
/// Time complexity: O(n)
/// Space complexity: O(h)
///
/// Example:
/// ```dart
/// final root = BinaryTreeNode<int>(3);
/// root.left = BinaryTreeNode<int>(5);
/// root.right = BinaryTreeNode<int>(1);
/// root.left!.left = BinaryTreeNode<int>(6);
/// root.left!.right = BinaryTreeNode<int>(2);
/// final lca = lowestCommonAncestor(root, root.left, root.right);
/// // lca.value == 3
/// ```
library;

import 'binary_tree_node.dart';

BinaryTreeNode<T>? lowestCommonAncestor<T>(
  BinaryTreeNode<T>? root,
  BinaryTreeNode<T>? p,
  BinaryTreeNode<T>? q,
) {
  if (root == null || root == p || root == q) return root;
  final left = lowestCommonAncestor(root.left, p, q);
  final right = lowestCommonAncestor(root.right, p, q);
  if (left != null && right != null) return root;
  return left ?? right;
}
