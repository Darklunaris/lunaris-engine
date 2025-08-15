/// 🌳 Lowest Common Ancestor (LCA)
///
/// Finds the lowest common ancestor of two nodes in a binary tree.
/// The LCA is the deepest node that has both nodes as descendants.
/// Returns `null` if either node is not present in the tree.
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
/// root.left!.right = BinaryTreeNode<int>(7);
/// final lca = lowestCommonAncestor(root, 3, 7);
/// // lca.value: 5
/// ```
library;

import 'binary_tree_node.dart';

/// Returns the lowest common ancestor node of values [p] and [q] in the binary tree rooted at [root].
/// Returns null if either [p] or [q] is not present in the tree.
BinaryTreeNode<T>? lowestCommonAncestor<T>(BinaryTreeNode<T>? root, T p, T q) {
  if (root == null) return null;

  final pExists = _containsValue(root, p);
  final qExists = _containsValue(root, q);
  if (!pExists && !qExists) return null;
  if (!pExists) return _findNode(root, q);
  if (!qExists) return _findNode(root, p);

  return _lcaHelper(root, p, q);
}

// Helper to find node by value
BinaryTreeNode<T>? _findNode<T>(BinaryTreeNode<T>? root, T value) {
  if (root == null) return null;
  if (root.value == value) return root;
  return _findNode(root.left, value) ?? _findNode(root.right, value);
}

// Internal helper for LCA computation (assumes both p and q exist in the tree)
BinaryTreeNode<T>? _lcaHelper<T>(BinaryTreeNode<T>? root, T p, T q) {
  if (root == null) return null;

  if (root.value == p || root.value == q) return root;

  final left = _lcaHelper(root.left, p, q);
  final right = _lcaHelper(root.right, p, q);

  if (left != null && right != null) return root;

  return left ?? right;
}

// Helper function to check if a value exists in the tree
bool _containsValue<T>(BinaryTreeNode<T>? root, T value) {
  if (root == null) return false;
  if (root.value == value) return true;
  return _containsValue(root.left, value) || _containsValue(root.right, value);
}
