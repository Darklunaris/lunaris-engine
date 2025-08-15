/// 🌳 Bottom View and Top View of Binary Tree
///
/// Returns the bottom view and top view of a binary tree as lists of node values.
///
/// Time complexity: O(n)
/// Space complexity: O(n)
///
/// Example:
/// ```dart
/// final root = BinaryTreeNode<int>(20);
/// root.left = BinaryTreeNode<int>(8);
/// root.right = BinaryTreeNode<int>(22);
/// root.left!.left = BinaryTreeNode<int>(5);
/// root.left!.right = BinaryTreeNode<int>(3);
/// root.right!.left = BinaryTreeNode<int>(4);
/// root.right!.right = BinaryTreeNode<int>(25);
/// final bottom = bottomView(root);
/// final top = topView(root);
/// // bottom: [5, 8, 4, 22, 25]
/// // top: [5, 8, 20, 22, 25]
/// ```
library;

import 'dart:collection';
import 'binary_tree_node.dart';

List<T> bottomView<T>(BinaryTreeNode<T>? root) {
  if (root == null) return [];
  final Map<int, T> columnTable = {};
  final Queue<MapEntry<BinaryTreeNode<T>, int>> queue = Queue();
  queue.add(MapEntry(root, 0));
  int minCol = 0, maxCol = 0;
  while (queue.isNotEmpty) {
    final entry = queue.removeFirst();
    final node = entry.key;
    final col = entry.value;
    columnTable[col] = node.value;
    if (node.left != null) {
      queue.add(MapEntry(node.left!, col - 1));
      minCol = minCol < col - 1 ? minCol : col - 1;
    }
    if (node.right != null) {
      queue.add(MapEntry(node.right!, col + 1));
      maxCol = maxCol > col + 1 ? maxCol : col + 1;
    }
  }
  return [for (int i = minCol; i <= maxCol; ++i) columnTable[i]!];
}

List<T> topView<T>(BinaryTreeNode<T>? root) {
  if (root == null) return [];
  final Map<int, T> columnTable = {};
  final Queue<MapEntry<BinaryTreeNode<T>, int>> queue = Queue();
  queue.add(MapEntry(root, 0));
  int minCol = 0, maxCol = 0;
  while (queue.isNotEmpty) {
    final entry = queue.removeFirst();
    final node = entry.key;
    final col = entry.value;
    if (!columnTable.containsKey(col)) {
      columnTable[col] = node.value;
    }
    if (node.left != null) {
      queue.add(MapEntry(node.left!, col - 1));
      minCol = minCol < col - 1 ? minCol : col - 1;
    }
    if (node.right != null) {
      queue.add(MapEntry(node.right!, col + 1));
      maxCol = maxCol > col + 1 ? maxCol : col + 1;
    }
  }
  return [for (int i = minCol; i <= maxCol; ++i) columnTable[i]!];
}
