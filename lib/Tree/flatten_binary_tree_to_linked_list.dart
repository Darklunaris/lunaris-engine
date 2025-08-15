/// 🌳 Flatten Binary Tree to Linked List (in-place, preorder)
///
/// Flattens a binary tree to a linked list in preorder traversal order.
/// The right child points to the next node, and left is always null.
///
/// Time complexity: O(n)
/// Space complexity: O(1) (in-place)
///
/// Example:
/// ```dart
/// final root = BinaryTreeNode<int>(1);
/// root.left = BinaryTreeNode<int>(2);
/// root.right = BinaryTreeNode<int>(5);
/// root.left!.left = BinaryTreeNode<int>(3);
/// root.left!.right = BinaryTreeNode<int>(4);
/// root.right!.right = BinaryTreeNode<int>(6);
/// flattenBinaryTreeToLinkedList(root);
/// // root is now a right-skewed linked list: 1->2->3->4->5->6
/// ```
library;

import 'binary_tree_node.dart';

void flattenBinaryTreeToLinkedList<T>(BinaryTreeNode<T>? root) {
  BinaryTreeNode<T>? curr = root;
  while (curr != null) {
    if (curr.left != null) {
      var prev = curr.left;
      while (prev!.right != null) {
        prev = prev.right;
      }
      prev.right = curr.right;
      curr.right = curr.left;
      curr.left = null;
    }
    curr = curr.right;
  }
}
