/// 🌳 Binary Search Tree Validator
///
/// Validates if a binary tree is a valid Binary Search Tree (BST).
/// A BST has the property that for every node, all values in the left
/// subtree are less than the node's value, and all values in the right
/// subtree are greater than the node's value.
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
/// final isValid = validateBST(root);
/// // isValid: true
/// ```
library;

import 'binary_tree_node.dart';

bool validateBST<T extends Comparable>(BinaryTreeNode<T>? root) {
  return _isValidBST(root, null, null);
}

bool _isValidBST<T extends Comparable>(
  BinaryTreeNode<T>? root,
  T? min,
  T? max,
) {
  if (root == null) return true;

  // Check if current node's value is within bounds
  if ((min != null && root.value.compareTo(min) <= 0) ||
      (max != null && root.value.compareTo(max) >= 0)) {
    return false;
  }

  // Recursively check left and right subtrees
  return _isValidBST(root.left, min, root.value) &&
      _isValidBST(root.right, root.value, max);
}
