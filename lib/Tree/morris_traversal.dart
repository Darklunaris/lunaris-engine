/// 🌳 Morris Traversal (Inorder Traversal without Stack or Recursion)
///
/// Efficiently traverses a binary tree in inorder sequence using O(1) space.
/// This algorithm temporarily modifies the tree structure (threading) and restores it after traversal.
///
/// Time complexity: O(n)
/// Space complexity: O(1)
///
/// Example:
/// ```dart
/// final root = BinaryTreeNode<int>(10);
/// root.left = BinaryTreeNode<int>(5);
/// root.right = BinaryTreeNode<int>(15);
/// final result = morrisInorderTraversal(root);
/// // result: [5, 10, 15]
/// ```
library;

import 'binary_tree_node.dart';

List<T> morrisInorderTraversal<T>(BinaryTreeNode<T>? root) {
  final result = <T>[];
  BinaryTreeNode<T>? current = root;
  while (current != null) {
    if (current.left == null) {
      result.add(current.value);
      current = current.right;
    } else {
      var predecessor = current.left;
      while (predecessor!.right != null && predecessor.right != current) {
        predecessor = predecessor.right;
      }
      if (predecessor.right == null) {
        predecessor.right = current;
        current = current.left;
      } else {
        predecessor.right = null;
        result.add(current.value);
        current = current.right;
      }
    }
  }
  return result;
}
