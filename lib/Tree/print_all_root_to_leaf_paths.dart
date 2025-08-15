/// 🌳 Print All Root-to-Leaf Paths in a Binary Tree
///
/// Returns all paths from the root to each leaf node as lists of values.
///
/// Time complexity: O(n)
/// Space complexity: O(h) for recursion, plus O(n) for storing paths
///
/// Example:
/// ```dart
/// final root = BinaryTreeNode<int>(1);
/// root.left = BinaryTreeNode<int>(2);
/// root.right = BinaryTreeNode<int>(3);
/// root.left!.left = BinaryTreeNode<int>(4);
/// root.left!.right = BinaryTreeNode<int>(5);
/// final paths = printAllRootToLeafPaths(root);
/// // paths: [[1,2,4],[1,2,5],[1,3]]
/// ```
library;

import 'binary_tree_node.dart';

List<List<T>> printAllRootToLeafPaths<T>(BinaryTreeNode<T>? root) {
  final List<List<T>> paths = [];
  void dfs(BinaryTreeNode<T>? node, List<T> path) {
    if (node == null) return;
    path.add(node.value);
    if (node.left == null && node.right == null) {
      paths.add(List<T>.from(path));
    } else {
      dfs(node.left, path);
      dfs(node.right, path);
    }
    path.removeLast();
  }

  dfs(root, []);
  return paths;
}
