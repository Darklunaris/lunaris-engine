/// 🌳 Threaded Binary Tree Traversal
///
/// Traverses a threaded binary tree efficiently using O(1) space.
/// Threaded binary trees use otherwise null right pointers to point to the inorder successor.
///
/// Time complexity: O(n)
/// Space complexity: O(1)
///
/// Example:
/// ```dart
/// // See documentation for how to build a threaded tree.
/// ```
library;

import 'binary_tree_node.dart';

class ThreadedBinaryTreeNode<T> extends BinaryTreeNode<T> {
  ThreadedBinaryTreeNode<T>? rightThread;
  ThreadedBinaryTreeNode(
    super.value, {
    ThreadedBinaryTreeNode<T>? super.left,
    ThreadedBinaryTreeNode<T>? super.right,
    this.rightThread,
  });
}

List<T> threadedInorderTraversal<T>(ThreadedBinaryTreeNode<T>? root) {
  final result = <T>[];
  ThreadedBinaryTreeNode<T>? current = root;
  while (current != null) {
    while (current!.left != null) {
      current = current.left as ThreadedBinaryTreeNode<T>?;
    }
    while (current != null) {
      result.add(current.value);
      if (current.rightThread != null) {
        current = current.rightThread;
      } else {
        current = current.right as ThreadedBinaryTreeNode<T>?;
        break;
      }
    }
  }
  return result;
}
