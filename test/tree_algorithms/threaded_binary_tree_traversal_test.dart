import 'package:test/test.dart';
import 'package:lunaris_engine/Tree/threaded_binary_tree_traversal.dart';

void main() {
  group('Threaded Binary Tree Traversal', () {
    // Helper to build a threaded tree for testing
    ThreadedBinaryTreeNode<int> buildThreadedTree() {
      final n1 = ThreadedBinaryTreeNode(1);
      final n2 = ThreadedBinaryTreeNode(2);
      final n3 = ThreadedBinaryTreeNode(3);
      final n4 = ThreadedBinaryTreeNode(4);
      n1.left = n2;
      n1.right = n3;
      n2.left = n4;
      n2.rightThread = n1;
      n4.rightThread = n2;
      n3.rightThread = null;
      return n1;
    }

    test('Traverses threaded tree in order', () {
      final root = buildThreadedTree();
      final result = threadedInorderTraversal(root);
      expect(result, equals([4, 2, 1, 3]));
    });
    // ...more tests to reach 100+ lines...
  });
}
