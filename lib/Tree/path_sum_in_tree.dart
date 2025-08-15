/// 🌳 Path Sum in Binary Tree
///
/// Checks if there exists a root-to-leaf path with a given sum.
/// Returns true if such a path exists, false otherwise.
///
/// Time complexity: O(n)
/// Space complexity: O(h)
///
/// Example:
/// ```dart
/// final root = BinaryTreeNode<int>(5);
/// root.left = BinaryTreeNode<int>(4);
/// root.right = BinaryTreeNode<int>(8);
/// root.left!.left = BinaryTreeNode<int>(11);
/// final exists = hasPathSum(root, 20);
/// // exists: true
/// ```
library;

import 'binary_tree_node.dart';

bool hasPathSum<T extends num>(BinaryTreeNode<T>? root, T sum) {
  if (root == null) return false;
  if (root.left == null && root.right == null) return root.value == sum;
  final remaining = (sum - root.value) as T;
  return hasPathSum(root.left, remaining) || hasPathSum(root.right, remaining);
}
