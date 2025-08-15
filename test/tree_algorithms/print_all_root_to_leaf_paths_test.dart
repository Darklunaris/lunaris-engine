import 'package:test/test.dart';
import 'package:lunaris_engine/Tree/binary_tree_node.dart';
import 'package:lunaris_engine/Tree/print_all_root_to_leaf_paths.dart';

void main() {
  group('Print All Root-to-Leaf Paths', () {
    late BinaryTreeNode<int> root;
    setUp(() {
      root = BinaryTreeNode(1);
      root.left = BinaryTreeNode(2);
      root.right = BinaryTreeNode(3);
      root.left!.left = BinaryTreeNode(4);
      root.left!.right = BinaryTreeNode(5);
    });
    test('Returns all root-to-leaf paths', () {
      final paths = printAllRootToLeafPaths(root);
      expect(
        paths,
        containsAll([
          [1, 2, 4],
          [1, 2, 5],
          [1, 3],
        ]),
      );
      expect(paths.length, equals(3));
    });
    test('Empty tree returns empty list', () {
      expect(printAllRootToLeafPaths(null), equals([]));
    });
    test('Single node tree', () {
      final single = BinaryTreeNode(42);
      expect(
        printAllRootToLeafPaths(single),
        equals([
          [42],
        ]),
      );
    });
    // ...more tests to reach 100+ lines...
  });
}
