/// 🌳 Zigzag Level Order Traversal
///
/// Traverses a binary tree level by level, alternating between left-to-right
/// and right-to-left order for each level.
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
/// root.right!.left = BinaryTreeNode<int>(12);
/// final result = zigzagTraversal(root);
/// // result: [[10], [15, 5], [3, 7, 12]]
/// ```
library;

import 'binary_tree_node.dart';

List<List<T>> zigzagTraversal<T>(BinaryTreeNode<T>? root) {
  final List<List<T>> result = [];

  if (root == null) return result;

  final List<BinaryTreeNode<T>> queue = [root];
  bool leftToRight = true;

  while (queue.isNotEmpty) {
    final int levelSize = queue.length;
    final List<T> currentLevel = [];

    for (int i = 0; i < levelSize; i++) {
      final BinaryTreeNode<T> node = queue.removeAt(0);

      if (leftToRight) {
        currentLevel.add(node.value);
      } else {
        currentLevel.insert(0, node.value);
      }

      if (node.left != null) {
        queue.add(node.left!);
      }
      if (node.right != null) {
        queue.add(node.right!);
      }
    }

    result.add(currentLevel);
    leftToRight = !leftToRight;
  }

  return result;
}
