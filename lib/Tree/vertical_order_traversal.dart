/// 🌳 Vertical Order Traversal of Binary Tree
///
/// Returns a list of lists, each containing the nodes at the same vertical column.
/// Columns are ordered from leftmost to rightmost.
///
/// Time complexity: O(n)
/// Space complexity: O(n)
///
/// Example:
/// ```dart
/// final root = BinaryTreeNode<int>(3);
/// root.left = BinaryTreeNode<int>(9);
/// root.right = BinaryTreeNode<int>(8);
/// root.left!.left = BinaryTreeNode<int>(4);
/// root.left!.right = BinaryTreeNode<int>(0);
/// root.right!.left = BinaryTreeNode<int>(1);
/// root.right!.right = BinaryTreeNode<int>(7);
/// final result = verticalOrderTraversal(root);
/// // result: [[4], [9], [3,0,1], [8], [7]]
/// ```
library;

import 'dart:collection';
import 'binary_tree_node.dart';

List<List<T>> verticalOrderTraversal<T>(BinaryTreeNode<T>? root) {
  if (root == null) return [];
  final Map<int, List<T>> columnTable = {};
  final Queue<MapEntry<BinaryTreeNode<T>, int>> queue = Queue();
  queue.add(MapEntry(root, 0));
  int minCol = 0, maxCol = 0;
  while (queue.isNotEmpty) {
    final entry = queue.removeFirst();
    final node = entry.key;
    final col = entry.value;
    columnTable.putIfAbsent(col, () => []).add(node.value);
    if (node.left != null) {
      queue.add(MapEntry(node.left!, col - 1));
      minCol = minCol < col - 1 ? minCol : col - 1;
    }
    if (node.right != null) {
      queue.add(MapEntry(node.right!, col + 1));
      maxCol = maxCol > col + 1 ? maxCol : col + 1;
    }
  }
  return [for (int i = minCol; i <= maxCol; ++i) columnTable[i] ?? []];
}
