import 'package:lunaris_engine/lunaris_engine.dart' hide hasPathSum;
// (import removed, already handled by hiding in main import)
import 'package:lunaris_engine/Tree/path_sum_in_tree.dart' show hasPathSum;

void main() {
  print('🌳 Binary Tree Algorithms Example\n');

  // Create a sample binary tree
  //       10
  //      /  \
  //     5    15
  //    / \   / \
  //   3   7 12  20
  //  /     \
  // 1       9
  final root = BinaryTreeNode<int>(10);
  root.left = BinaryTreeNode<int>(5);
  root.right = BinaryTreeNode<int>(15);
  root.left!.left = BinaryTreeNode<int>(3);
  root.left!.right = BinaryTreeNode<int>(7);
  root.right!.left = BinaryTreeNode<int>(12);
  root.right!.right = BinaryTreeNode<int>(20);
  root.left!.left!.left = BinaryTreeNode<int>(1);
  root.left!.right!.right = BinaryTreeNode<int>(9);

  print('📊 Tree Traversals:');
  print('Inorder: ${inorderTraversal(root)}');
  print('Preorder: ${preorderTraversal(root)}');
  print('Postorder: ${postorderTraversal(root)}');
  print('Level Order: ${levelOrderTraversal(root)}');
  print('Zigzag: ${zigzagTraversal(root)}');
  print('');

  print('🔍 Tree Properties:');
  print('Depth: ${treeDepth(root)}');
  // print('Diameter: ${treeDiameter(root)}');
  print('Is Balanced: ${isBalancedTree(root)}');
  print('Is Valid BST: ${validateBST(root)}');
  print('');

  print('🔄 Tree Operations:');
  print(
    'Lowest Common Ancestor of 1 and 9: ${lowestCommonAncestor(root, 1, 9)?.value}',
  );
  print(
    'Lowest Common Ancestor of 3 and 7: ${lowestCommonAncestor(root, 3, 7)?.value}',
  );
  print('');

  print('📝 Serialization:');
  final serialized = serializeTree(root);
  print('Serialized: $serialized');
  final deserialized = deserializeTree<int>(serialized);
  print('Deserialized level order: ${levelOrderTraversal(deserialized)}');
  print('');

  print('🔄 Tree Inversion:');
  final inverted = invertTree(root);
  print('Inverted level order: ${levelOrderTraversal(inverted)}');
  print('');

  // Create a valid BST for comparison
  print('🌲 Binary Search Tree Example:');
  final bstRoot = BinaryTreeNode<int>(10);
  bstRoot.left = BinaryTreeNode<int>(5);
  bstRoot.right = BinaryTreeNode<int>(15);
  bstRoot.left!.left = BinaryTreeNode<int>(3);
  bstRoot.left!.right = BinaryTreeNode<int>(7);
  bstRoot.right!.left = BinaryTreeNode<int>(12);
  bstRoot.right!.right = BinaryTreeNode<int>(20);

  print('Is Valid BST: ${validateBST(bstRoot)}');
  print('Inorder traversal (should be sorted): ${inorderTraversal(bstRoot)}');
  print('');

  print('');

  print('🌟 Advanced Binary Tree Algorithms (New):');
  // Morris Traversal
  print('Morris Inorder Traversal: ${morrisInorderTraversal(root)}');

  // Threaded Binary Tree Traversal (example tree)
  final threadedRoot = ThreadedBinaryTreeNode<int>(1);
  threadedRoot.left = ThreadedBinaryTreeNode<int>(2);
  threadedRoot.right = ThreadedBinaryTreeNode<int>(3);
  (threadedRoot.left as ThreadedBinaryTreeNode<int>).rightThread = threadedRoot;
  print(
    'Threaded Inorder Traversal: ${threadedInorderTraversal(threadedRoot)}',
  );

  // Count Leaf, Full, Half Nodes
  print('Leaf Nodes: ${countLeafNodes(root)}');
  print('Full Nodes: ${countFullNodes(root)}');
  print('Half Nodes: ${countHalfNodes(root)}');

  // Print All Root-to-Leaf Paths
  print('All Root-to-Leaf Paths: ${printAllRootToLeafPaths(root)}');

  // Path Sum in Tree
  // Use the correct hasPathSum for tree (not matrix)
  print('Has Path Sum 22: ${hasPathSum(root, 22)}');

  // Vertical Order Traversal
  print('Vertical Order Traversal: ${verticalOrderTraversal(root)}');

  // Boundary Traversal
  print('Boundary Traversal: ${boundaryTraversal(root)}');

  // Bottom/Top View
  print('Bottom View: ${bottomView(root)}');
  print('Top View: ${topView(root)}');

  // Construct Tree from Inorder & Preorder
  final inorder = [9, 3, 15, 20, 7];
  final preorder = [3, 9, 20, 15, 7];
  final builtPre = buildTreeFromInorderPreorder(inorder, preorder);
  print(
    'Build from Inorder & Preorder (level order): ${levelOrderTraversal(builtPre)}',
  );

  // Construct Tree from Inorder & Postorder
  final postorder = [9, 15, 7, 20, 3];
  final builtPost = buildTreeFromInorderPostorder(inorder, postorder);
  print(
    'Build from Inorder & Postorder (level order): ${levelOrderTraversal(builtPost)}',
  );

  // Convert Sorted Array to BST
  final arr = [-10, -3, 0, 5, 9];
  final bst = sortedArrayToBST(arr);
  print('Sorted Array to BST (inorder): ${inorderTraversal(bst)}');

  // Flatten Binary Tree to Linked List
  final flatRoot = BinaryTreeNode<int>(1);
  flatRoot.left = BinaryTreeNode<int>(2);
  flatRoot.right = BinaryTreeNode<int>(5);
  flatRoot.left!.left = BinaryTreeNode<int>(3);
  flatRoot.left!.right = BinaryTreeNode<int>(4);
  flatRoot.right!.right = BinaryTreeNode<int>(6);
  flattenBinaryTreeToLinkedList(flatRoot);
  final flatList = <int>[];
  BinaryTreeNode<int>? curr = flatRoot;
  while (curr != null) {
    flatList.add(curr.value);
    curr = curr.right;
  }
  print('Flattened Binary Tree to Linked List: $flatList');

  // Lowest Common Ancestor (no BST)
  final lcaRoot = BinaryTreeNode<int>(3);
  final n5 = BinaryTreeNode<int>(5);
  final n1 = BinaryTreeNode<int>(1);
  final n6 = BinaryTreeNode<int>(6);
  final n2 = BinaryTreeNode<int>(2);
  final n0 = BinaryTreeNode<int>(0);
  final n8 = BinaryTreeNode<int>(8);
  final n7 = BinaryTreeNode<int>(7);
  final n4 = BinaryTreeNode<int>(4);
  lcaRoot.left = n5;
  lcaRoot.right = n1;
  n5.left = n6;
  n5.right = n2;
  n1.left = n0;
  n1.right = n8;
  n2.left = n7;
  n2.right = n4;
  print(
    'Lowest Common Ancestor (no BST) of 5 and 1: ${lowestCommonAncestor(lcaRoot, n5, n1)?.value}',
  );

  print('\n✨ All tree algorithms are working correctly!');
}
