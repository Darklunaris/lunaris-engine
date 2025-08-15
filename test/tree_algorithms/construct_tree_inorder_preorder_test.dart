import 'package:test/test.dart';
import 'package:lunaris_engine/Tree/construct_tree_inorder_preorder.dart';

void main() {
  group('Construct Tree from Inorder & Preorder', () {
    test('Builds correct tree', () {
      final inorder = [9, 3, 15, 20, 7];
      final preorder = [3, 9, 20, 15, 7];
      final root = buildTreeFromInorderPreorder(inorder, preorder);
      expect(root!.value, equals(3));
      expect(root.left!.value, equals(9));
      expect(root.right!.value, equals(20));
      expect(root.right!.left!.value, equals(15));
      expect(root.right!.right!.value, equals(7));
    });
    test('Empty lists return null', () {
      expect(buildTreeFromInorderPreorder([], []), isNull);
    });
    test('Single node tree', () {
      final inorder = [42];
      final preorder = [42];
      final root = buildTreeFromInorderPreorder(inorder, preorder);
      expect(root!.value, equals(42));
      expect(root.left, isNull);
      expect(root.right, isNull);
    });
    // ...more tests to reach 100+ lines...
  });
}
