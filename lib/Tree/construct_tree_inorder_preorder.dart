/// 🌳 Construct Binary Tree from Inorder and Preorder Traversal
///
/// Builds a binary tree from given inorder and preorder traversal lists.
///
/// Time complexity: O(n)
/// Space complexity: O(n)
///
/// Example:
/// ```dart
/// final inorder = [9,3,15,20,7];
/// final preorder = [3,9,20,15,7];
/// final root = buildTreeFromInorderPreorder(inorder, preorder);
/// ```
library;

import 'binary_tree_node.dart';

BinaryTreeNode<T>? buildTreeFromInorderPreorder<T>(
  List<T> inorder,
  List<T> preorder,
) {
  if (inorder.isEmpty || preorder.isEmpty) return null;
  final Map<T, int> inorderIndex = {
    for (var i = 0; i < inorder.length; ++i) inorder[i]: i,
  };
  int preIndex = 0;
  BinaryTreeNode<T>? helper(int left, int right) {
    if (left > right) return null;
    final rootVal = preorder[preIndex++];
    final root = BinaryTreeNode<T>(rootVal);
    final idx = inorderIndex[rootVal]!;
    root.left = helper(left, idx - 1);
    root.right = helper(idx + 1, right);
    return root;
  }

  return helper(0, inorder.length - 1);
}
