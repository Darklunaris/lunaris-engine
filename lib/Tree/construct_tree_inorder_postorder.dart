/// 🌳 Construct Binary Tree from Inorder and Postorder Traversal
///
/// Builds a binary tree from given inorder and postorder traversal lists.
///
/// Time complexity: O(n)
/// Space complexity: O(n)
///
/// Example:
/// ```dart
/// final inorder = [9,3,15,20,7];
/// final postorder = [9,15,7,20,3];
/// final root = buildTreeFromInorderPostorder(inorder, postorder);
/// ```
library;

import 'binary_tree_node.dart';

BinaryTreeNode<T>? buildTreeFromInorderPostorder<T>(
  List<T> inorder,
  List<T> postorder,
) {
  if (inorder.isEmpty || postorder.isEmpty) return null;
  final Map<T, int> inorderIndex = {
    for (var i = 0; i < inorder.length; ++i) inorder[i]: i,
  };
  int postIndex = postorder.length - 1;
  BinaryTreeNode<T>? helper(int left, int right) {
    if (left > right) return null;
    final rootVal = postorder[postIndex--];
    final root = BinaryTreeNode<T>(rootVal);
    final idx = inorderIndex[rootVal]!;
    root.right = helper(idx + 1, right);
    root.left = helper(left, idx - 1);
    return root;
  }

  return helper(0, inorder.length - 1);
}
