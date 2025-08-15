/// 🌳 Convert Sorted Array to Balanced BST
///
/// Builds a height-balanced binary search tree from a sorted array.
///
/// Time complexity: O(n)
/// Space complexity: O(log n)
///
/// Example:
/// ```dart
/// final arr = [-10, -3, 0, 5, 9];
/// final root = sortedArrayToBST(arr);
/// ```
library;

import 'binary_tree_node.dart';

BinaryTreeNode<T>? sortedArrayToBST<T extends Comparable>(List<T> arr) {
  BinaryTreeNode<T>? helper(int left, int right) {
    if (left > right) return null;
    final mid = left + ((right - left) >> 1);
    final node = BinaryTreeNode<T>(arr[mid]);
    node.left = helper(left, mid - 1);
    node.right = helper(mid + 1, right);
    return node;
  }

  return helper(0, arr.length - 1);
}
