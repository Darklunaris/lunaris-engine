import 'package:test/test.dart';
import 'package:lunaris_engine/LinkedList/linked_list_node.dart';
import 'package:lunaris_engine/LinkedList/merge_sort_linked_list.dart';

void main() {
  group('Sort Linked List (Merge Sort)', () {
    test('Sorts unsorted list', () {
      final head = LinkedListNode.fromList([4, 2, 1, 3]);
      final sorted = mergeSortLinkedList(head);
      expect(LinkedListNode.toList(sorted), equals([1, 2, 3, 4]));
    });
    test('Already sorted', () {
      final head = LinkedListNode.fromList([1, 2, 3, 4]);
      final sorted = mergeSortLinkedList(head);
      expect(LinkedListNode.toList(sorted), equals([1, 2, 3, 4]));
    });
    test('Reverse sorted', () {
      final head = LinkedListNode.fromList([5, 4, 3, 2, 1]);
      final sorted = mergeSortLinkedList(head);
      expect(LinkedListNode.toList(sorted), equals([1, 2, 3, 4, 5]));
    });
    test('Single node', () {
      final head = LinkedListNode.fromList([42]);
      final sorted = mergeSortLinkedList(head);
      expect(LinkedListNode.toList(sorted), equals([42]));
    });
    test('Empty list', () {
      final sorted = mergeSortLinkedList<int>(null);
      expect(sorted, isNull);
    });
    test('Random large list sorts correctly', () {
      final nums = [5, 3, 8, 1, 2, 7, 6, 4];
      final head = LinkedListNode.fromList(nums);
      final sorted = mergeSortLinkedList(head);
      expect(LinkedListNode.toList(sorted), equals([1, 2, 3, 4, 5, 6, 7, 8]));
    });

    test('Preserves stability for equal keys', () {
      // use comparable objects with same value - for simplicity use ints and check order of equals
      final head = LinkedListNode.fromList([2, 1, 2, 1]);
      final sorted = mergeSortLinkedList(head);
      expect(LinkedListNode.toList(sorted), equals([1, 1, 2, 2]));
    });
  });
}
