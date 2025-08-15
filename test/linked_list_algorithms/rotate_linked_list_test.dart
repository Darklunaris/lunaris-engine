import 'package:test/test.dart';
import 'package:lunaris_engine/LinkedList/linked_list_node.dart';
import 'package:lunaris_engine/LinkedList/rotate_linked_list.dart';

void main() {
  group('Rotate Linked List', () {
    test('Rotates list by 0 (no-op)', () {
      final head = LinkedListNode.fromList([1, 2, 3, 4, 5]);
      final rotated = rotateLinkedList(head, 0);
      expect(LinkedListNode.toList(rotated), equals([1, 2, 3, 4, 5]));
    });

    test('Rotates by length (no-op)', () {
      final head = LinkedListNode.fromList([1, 2, 3, 4, 5]);
      final rotated = rotateLinkedList(head, 5);
      expect(LinkedListNode.toList(rotated), equals([1, 2, 3, 4, 5]));
    });

    test('Standard rotate', () {
      final head = LinkedListNode.fromList([1, 2, 3, 4, 5]);
      final rotated = rotateLinkedList(head, 2);
      expect(LinkedListNode.toList(rotated), equals([4, 5, 1, 2, 3]));
    });

    test('Single node unaffected', () {
      final head = LinkedListNode.fromList([42]);
      final rotated = rotateLinkedList(head, 3);
      expect(LinkedListNode.toList(rotated), equals([42]));
    });

    test('Empty list returns null', () {
      final rotated = rotateLinkedList<int>(null, 2);
      expect(rotated, isNull);
    });

    test('Large k reduces correctly via mod', () {
      final head = LinkedListNode.fromList([1, 2, 3]);
      final rotated = rotateLinkedList(head, 1000003); // k mod 3 = 1
      expect(LinkedListNode.toList(rotated), equals([3, 1, 2]));
    });
  });
}
