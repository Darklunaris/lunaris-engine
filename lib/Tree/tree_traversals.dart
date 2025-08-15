/// 🌳 Binary Tree Traversal Algorithms
///
/// Three fundamental tree traversal algorithms that visit all nodes
/// in a binary tree in different orders.
///
/// - **Inorder**: Left -> Root -> Right (gives sorted order for BST)
/// - **Preorder**: Root -> Left -> Right (useful for copying trees)
/// - **Postorder**: Left -> Right -> Root (useful for deleting trees)
///
/// Time complexity: O(n) where n is the number of nodes
/// Space complexity: O(h) where h is the height of the tree (worst case O(n))
library;

import 'binary_tree_node.dart';

/// Inorder Traversal: Left -> Root -> Right
///
/// Returns nodes in ascending order for a Binary Search Tree.
///
/// Example:
/// ```dart
/// final root = BinaryTreeNode<int>(10);
/// root.left = BinaryTreeNode<int>(5);
/// root.right = BinaryTreeNode<int>(15);
/// final result = inorderTraversal(root);
/// // result: [5, 10, 15]
/// ```
List<T> inorderTraversal<T>(BinaryTreeNode<T>? root) {
  final List<T> result = [];

  void inorder(BinaryTreeNode<T>? node) {
    if (node == null) return;
    inorder(node.left);
    result.add(node.value);
    inorder(node.right);
  }

  inorder(root);
  return result;
}

/// Preorder Traversal: Root -> Left -> Right
///
/// Useful for copying trees or serialization.
///
/// Example:
/// ```dart
/// final root = BinaryTreeNode<int>(10);
/// root.left = BinaryTreeNode<int>(5);
/// root.right = BinaryTreeNode<int>(15);
/// final result = preorderTraversal(root);
/// // result: [10, 5, 15]
/// ```
List<T> preorderTraversal<T>(BinaryTreeNode<T>? root) {
  final List<T> result = [];

  void preorder(BinaryTreeNode<T>? node) {
    if (node == null) return;
    result.add(node.value);
    preorder(node.left);
    preorder(node.right);
  }

  preorder(root);
  return result;
}

/// Postorder Traversal: Left -> Right -> Root
///
/// Useful for deleting trees or postfix expression evaluation.
///
/// Example:
/// ```dart
/// final root = BinaryTreeNode<int>(10);
/// root.left = BinaryTreeNode<int>(5);
/// root.right = BinaryTreeNode<int>(15);
/// final result = postorderTraversal(root);
/// // result: [5, 15, 10]
/// ```
List<T> postorderTraversal<T>(BinaryTreeNode<T>? root) {
  final List<T> result = [];

  void postorder(BinaryTreeNode<T>? node) {
    if (node == null) return;
    postorder(node.left);
    postorder(node.right);
    result.add(node.value);
  }

  postorder(root);
  return result;
}
