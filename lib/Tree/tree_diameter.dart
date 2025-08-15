/// 🌳 Tree Diameter Calculator
///
/// Calculates the diameter of a binary tree, which is the length of the
/// longest path between any two nodes in the tree.
///
/// Time complexity: O(n) where n is the number of nodes
/// Space complexity: O(h) where h is the height of the tree (worst case O(n))
///
/// Example:
/// ```dart
/// final root = BinaryTreeNode<int>(10);
/// root.left = BinaryTreeNode<int>(5);
/// root.right = BinaryTreeNode<int>(15);
/// root.left!.left = BinaryTreeNode<int>(3);
/// root.left!.right = BinaryTreeNode<int>(7);
/// final diameter = treeDiameter(root);
/// // diameter: 3 (path from 3 to 15 via 5 and 10)
/// ```
library;

import 'binary_tree_node.dart';

int treeDiameter<T>(BinaryTreeNode<T>? root) {
  int maxDiameter = 0;

  int height(BinaryTreeNode<T>? node) {
    if (node == null) return 0;

    final int leftHeight = height(node.left);
    final int rightHeight = height(node.right);

    // Update max diameter if current path is longer
    maxDiameter =
        maxDiameter > (leftHeight + rightHeight)
            ? maxDiameter
            : (leftHeight + rightHeight);

    return 1 + (leftHeight > rightHeight ? leftHeight : rightHeight);
  }

  height(root);
  return maxDiameter;
}
