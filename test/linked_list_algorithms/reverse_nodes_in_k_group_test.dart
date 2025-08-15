import 'package:test/test.dart';
import 'package:lunaris_engine/LinkedList/linked_list_node.dart';
import 'package:lunaris_engine/LinkedList/reverse_nodes_in_k_group.dart';

void main() {
  group('Reverse Nodes in K-Group', () {
    test('Reverses in groups of 2', () {
      final head = LinkedListNode.fromList([1, 2, 3, 4, 5]);
      final reversed = reverseNodesInKGroup(head, 2);
      expect(LinkedListNode.toList(reversed), equals([2, 1, 4, 3, 5]));
    });
    test('Reverses in groups of 3', () {
      final head = LinkedListNode.fromList([1, 2, 3, 4, 5, 6]);
      final reversed = reverseNodesInKGroup(head, 3);
      expect(LinkedListNode.toList(reversed), equals([3, 2, 1, 6, 5, 4]));
    });
    test('k = 1 returns original', () {
      final head = LinkedListNode.fromList([1, 2, 3]);
      final reversed = reverseNodesInKGroup(head, 1);
      expect(LinkedListNode.toList(reversed), equals([1, 2, 3]));
    });
    test('k > length returns original', () {
      final head = LinkedListNode.fromList([1, 2, 3]);
      final reversed = reverseNodesInKGroup(head, 5);
      expect(LinkedListNode.toList(reversed), equals([1, 2, 3]));
    });
    test('Empty list', () {
      final reversed = reverseNodesInKGroup<int>(null, 2);
      expect(reversed, isNull);
    });
    test('k = 1 returns same list', () {
      final head = LinkedListNode.fromList([1, 2, 3]);
      final res = reverseNodesInKGroup(head, 1);
      expect(LinkedListNode.toList(res), equals([1, 2, 3]));
    });

    test('k larger than length leaves list unchanged', () {
      final head = LinkedListNode.fromList([1, 2, 3]);
      final res = reverseNodesInKGroup(head, 5);
      expect(LinkedListNode.toList(res), equals([1, 2, 3]));
    });

    test('Odd-length list with k=2 leaves last element', () {
      final head = LinkedListNode.fromList([1, 2, 3, 4, 5]);
      final res = reverseNodesInKGroup(head, 2);
      expect(LinkedListNode.toList(res), equals([2, 1, 4, 3, 5]));
    });
  });
}
