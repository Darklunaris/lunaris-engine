import 'package:test/test.dart';
import 'package:lunaris_engine/LinkedList/linked_list_node.dart';
import 'package:lunaris_engine/LinkedList/detect_and_remove_loop.dart';

void main() {
  group('Detect and Remove Loop', () {
    test('Detects and removes loop', () {
      final head = LinkedListNode.fromList([1, 2, 3, 4, 5]);
      head!.next!.next!.next!.next!.next = head.next!.next; // create loop
      final found = detectAndRemoveLoop(head);
      expect(found, isTrue);
      // List should be restored
      expect(LinkedListNode.toList(head), equals([1, 2, 3, 4, 5]));
    });
    test('No loop returns false', () {
      final head = LinkedListNode.fromList([1, 2, 3, 4, 5]);
      final found = detectAndRemoveLoop(head);
      expect(found, isFalse);
      expect(LinkedListNode.toList(head), equals([1, 2, 3, 4, 5]));
    });
    test('Single node no loop', () {
      final head = LinkedListNode.fromList([42]);
      final found = detectAndRemoveLoop(head);
      expect(found, isFalse);
      expect(LinkedListNode.toList(head), equals([42]));
    });
    test('Empty list', () {
      final found = detectAndRemoveLoop<int>(null);
      expect(found, isFalse);
    });
    test('No loop returns false', () {
      final head = LinkedListNode.fromList([1, 2, 3]);
      final removed = detectAndRemoveLoop(head);
      expect(removed, isFalse);
    });

    test('Detects and removes loop starting at head', () {
      final head = LinkedListNode.fromList([1, 2, 3, 4]);
      head!.next!.next!.next!.next = head; // loop to head
      final removed = detectAndRemoveLoop(head);
      expect(removed, isTrue);
      expect(LinkedListNode.toList(head).length, equals(4));
    });

    test('Detects and removes small loop (two-node loop)', () {
      final head = LinkedListNode.fromList([1, 2, 3, 4]);
      final tail = head!.next!.next!.next;
      tail!.next = tail; // two-node loop simulated by self-loop
      final removed = detectAndRemoveLoop(head);
      expect(removed, isTrue);
      expect(LinkedListNode.toList(head).length, greaterThanOrEqualTo(3));
    });
  });
}
