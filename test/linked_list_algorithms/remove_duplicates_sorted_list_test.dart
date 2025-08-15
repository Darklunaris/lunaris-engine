import 'package:test/test.dart';
import 'package:lunaris_engine/LinkedList/linked_list_node.dart';
import 'package:lunaris_engine/LinkedList/remove_duplicates_sorted_list.dart';

void main() {
  group('Remove Duplicates from Sorted List', () {
    test('Removes duplicates from sorted list', () {
      final head = LinkedListNode.fromList([1, 1, 2, 3, 3]);
      final deduped = removeDuplicatesSortedList(head);
      expect(LinkedListNode.toList(deduped), equals([1, 2, 3]));
    });
    test('No duplicates', () {
      final head = LinkedListNode.fromList([1, 2, 3]);
      final deduped = removeDuplicatesSortedList(head);
      expect(LinkedListNode.toList(deduped), equals([1, 2, 3]));
    });
    test('All duplicates', () {
      final head = LinkedListNode.fromList([2, 2, 2, 2]);
      final deduped = removeDuplicatesSortedList(head);
      expect(LinkedListNode.toList(deduped), equals([2]));
    });
    test('Single node', () {
      final head = LinkedListNode.fromList([42]);
      final deduped = removeDuplicatesSortedList(head);
      expect(LinkedListNode.toList(deduped), equals([42]));
    });
    test('Empty list', () {
      final deduped = removeDuplicatesSortedList<int>(null);
      expect(deduped, isNull);
    });
    test('All duplicates collapse to single', () {
      final head = LinkedListNode.fromList([1, 1, 1, 1]);
      final deduped = removeDuplicatesSortedList(head);
      expect(LinkedListNode.toList(deduped), equals([1]));
    });

    test('No duplicates stays same', () {
      final head = LinkedListNode.fromList([1, 2, 3]);
      final deduped = removeDuplicatesSortedList(head);
      expect(LinkedListNode.toList(deduped), equals([1, 2, 3]));
    });
  });
}
