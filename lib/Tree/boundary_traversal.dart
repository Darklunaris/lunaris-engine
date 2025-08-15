/// 🌳 Boundary Traversal of Binary Tree
///
/// Returns the boundary nodes of a binary tree in anti-clockwise order:
/// root, left boundary, leaves, right boundary (bottom-up).
///
/// Time complexity: O(n)
/// Space complexity: O(h)
///
/// Example:
/// ```dart
/// final root = BinaryTreeNode<int>(1);
/// root.left = BinaryTreeNode<int>(2);
/// root.right = BinaryTreeNode<int>(3);
/// root.left!.left = BinaryTreeNode<int>(4);
/// root.left!.right = BinaryTreeNode<int>(5);
/// root.right!.left = BinaryTreeNode<int>(6);
/// root.right!.right = BinaryTreeNode<int>(7);
/// final result = boundaryTraversal(root);
/// // result: [1,2,4,5,6,7,3]
/// ```
library;

import 'binary_tree_node.dart';

List<T> boundaryTraversal<T>(BinaryTreeNode<T>? root) {
  final List<T> result = [];
  if (root == null) return result;
  bool isLeaf(BinaryTreeNode<T> node) =>
      node.left == null && node.right == null;
  void addLeftBoundary(BinaryTreeNode<T>? node) {
    while (node != null) {
      if (!isLeaf(node)) result.add(node.value);
      node = node.left ?? node.right;
    }
  }

  void addLeaves(BinaryTreeNode<T>? node) {
    if (node == null) return;
    if (isLeaf(node)) {
      result.add(node.value);
      return;
    }
    addLeaves(node.left);
    addLeaves(node.right);
  }

  void addRightBoundary(BinaryTreeNode<T>? node, List<T> stack) {
    while (node != null) {
      if (!isLeaf(node)) stack.add(node.value);
      node = node.right ?? node.left;
    }
  }

  result.add(root.value);
  addLeftBoundary(root.left);
  addLeaves(root.left);
  addLeaves(root.right);
  final rightStack = <T>[];
  addRightBoundary(root.right, rightStack);
  for (var i = rightStack.length - 1; i >= 0; --i) {
    result.add(rightStack[i]);
  }
  return result;
}
