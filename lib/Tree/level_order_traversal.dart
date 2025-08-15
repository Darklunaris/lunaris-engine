/// 🌳 Level Order Traversal (BFS)
///
/// Traverses a binary tree level by level, from left to right.
/// Returns a list of lists, where each inner list represents one level.
///
/// Time complexity: O(n) where n is the number of nodes
/// Space complexity: O(w) where w is the maximum width of the tree
///
/// Example:
/// ```dart
/// final root = BinaryTreeNode<int>(10);
/// root.left = BinaryTreeNode<int>(5);
/// root.right = BinaryTreeNode<int>(15);
/// root.left!.left = BinaryTreeNode<int>(3);
/// root.left!.right = BinaryTreeNode<int>(7);
/// final result = levelOrderTraversal(root);
/// // result: [[10], [5, 15], [3, 7]]
/// ```
library;

import 'binary_tree_node.dart';

List<List<T>> levelOrderTraversal<T>(BinaryTreeNode<T>? root) {
  final List<List<T>> result = [];

  if (root == null) return result;

  final List<BinaryTreeNode<T>> queue = [root];

  while (queue.isNotEmpty) {
    final int levelSize = queue.length;
    final List<T> currentLevel = [];

    for (int i = 0; i < levelSize; i++) {
      final BinaryTreeNode<T> node = queue.removeAt(0);
      currentLevel.add(node.value);

      if (node.left != null) {
        queue.add(node.left!);
      }
      if (node.right != null) {
        queue.add(node.right!);
      }
    }

    result.add(currentLevel);
  }

  return result;
}
