import 'package:test/test.dart';
import 'package:lunaris_engine/LinkedList/linked_list_node.dart';
import 'package:lunaris_engine/LinkedList/insert_delete_at_position.dart';

void main() {
  group('Insert and Delete at Position Tests', () {
    group('insertAtPosition Tests', () {
      test('Inserts at beginning of empty list', () {
        final head = insertAtPosition<int>(null, 42, 0);
        expect(LinkedListNode.toList(head), equals([42]));
      });

      test('Inserts at beginning of non-empty list', () {
        final head = LinkedListNode.fromList<int>([1, 2, 3]);
        final newHead = insertAtPosition(head, 0, 0);
        expect(LinkedListNode.toList(newHead), equals([0, 1, 2, 3]));
      });

      test('Inserts at middle position', () {
        final head = LinkedListNode.fromList<int>([1, 2, 4, 5]);
        final newHead = insertAtPosition(head, 3, 2);
        expect(LinkedListNode.toList(newHead), equals([1, 2, 3, 4, 5]));
      });

      test('Inserts at end position', () {
        final head = LinkedListNode.fromList<int>([1, 2, 3]);
        final newHead = insertAtPosition(head, 4, 3);
        expect(LinkedListNode.toList(newHead), equals([1, 2, 3, 4]));
      });

      test('Handles invalid position (negative)', () {
        final head = LinkedListNode.fromList<int>([1, 2, 3]);
        final newHead = insertAtPosition(head, 0, -1);
        expect(LinkedListNode.toList(newHead), equals([1, 2, 3]));
      });

      test('Handles position beyond list length', () {
        final head = LinkedListNode.fromList<int>([1, 2, 3]);
        final newHead = insertAtPosition(head, 4, 5);
        expect(LinkedListNode.toList(newHead), equals([1, 2, 3]));
      });

      test('Works with different types', () {
        final head = LinkedListNode.fromList<String>(['a', 'c']);
        final newHead = insertAtPosition(head, 'b', 1);
        expect(LinkedListNode.toList(newHead), equals(['a', 'b', 'c']));
      });
    });

    group('deleteAtPosition Tests', () {
      test('Deletes from beginning', () {
        final head = LinkedListNode.fromList<int>([1, 2, 3, 4]);
        final newHead = deleteAtPosition(head, 0);
        expect(LinkedListNode.toList(newHead), equals([2, 3, 4]));
      });

      test('Deletes from middle', () {
        final head = LinkedListNode.fromList<int>([1, 2, 3, 4, 5]);
        final newHead = deleteAtPosition(head, 2);
        expect(LinkedListNode.toList(newHead), equals([1, 2, 4, 5]));
      });

      test('Deletes from end', () {
        final head = LinkedListNode.fromList<int>([1, 2, 3, 4]);
        final newHead = deleteAtPosition(head, 3);
        expect(LinkedListNode.toList(newHead), equals([1, 2, 3]));
      });

      test('Deletes single node', () {
        final head = LinkedListNode<int>(42);
        final newHead = deleteAtPosition(head, 0);
        expect(newHead, isNull);
      });

      test('Handles empty list', () {
        final newHead = deleteAtPosition<int>(null, 0);
        expect(newHead, isNull);
      });

      test('Handles invalid position (negative)', () {
        final head = LinkedListNode.fromList<int>([1, 2, 3]);
        final newHead = deleteAtPosition(head, -1);
        expect(LinkedListNode.toList(newHead), equals([1, 2, 3]));
      });

      test('Handles position beyond list length', () {
        final head = LinkedListNode.fromList<int>([1, 2, 3]);
        final newHead = deleteAtPosition(head, 5);
        expect(LinkedListNode.toList(newHead), equals([1, 2, 3]));
      });
    });

    group('insertAfterValue Tests', () {
      test('Inserts after existing value', () {
        final head = LinkedListNode.fromList<int>([1, 2, 4]);
        final newHead = insertAfterValue(head, 2, 3);
        expect(LinkedListNode.toList(newHead), equals([1, 2, 3, 4]));
      });

      test('Inserts after first value', () {
        final head = LinkedListNode.fromList<int>([1, 3]);
        final newHead = insertAfterValue(head, 1, 2);
        expect(LinkedListNode.toList(newHead), equals([1, 2, 3]));
      });

      test('Inserts after last value', () {
        final head = LinkedListNode.fromList<int>([1, 2, 3]);
        final newHead = insertAfterValue(head, 3, 4);
        expect(LinkedListNode.toList(newHead), equals([1, 2, 3, 4]));
      });

      test('Handles value not found', () {
        final head = LinkedListNode.fromList<int>([1, 2, 3]);
        final newHead = insertAfterValue(head, 5, 4);
        expect(LinkedListNode.toList(newHead), equals([1, 2, 3]));
      });

      test('Handles empty list', () {
        final newHead = insertAfterValue<int>(null, 1, 2);
        expect(newHead, isNull);
      });

      test('Works with strings', () {
        final head = LinkedListNode.fromList<String>(['a', 'c']);
        final newHead = insertAfterValue(head, 'a', 'b');
        expect(LinkedListNode.toList(newHead), equals(['a', 'b', 'c']));
      });
    });

    group('deleteByValue Tests', () {
      test('Deletes first occurrence of value', () {
        final head = LinkedListNode.fromList<int>([1, 2, 2, 3]);
        final newHead = deleteByValue(head, 2);
        expect(LinkedListNode.toList(newHead), equals([1, 2, 3]));
      });

      test('Deletes from beginning', () {
        final head = LinkedListNode.fromList<int>([1, 2, 3]);
        final newHead = deleteByValue(head, 1);
        expect(LinkedListNode.toList(newHead), equals([2, 3]));
      });

      test('Deletes from end', () {
        final head = LinkedListNode.fromList<int>([1, 2, 3]);
        final newHead = deleteByValue(head, 3);
        expect(LinkedListNode.toList(newHead), equals([1, 2]));
      });

      test('Deletes single node', () {
        final head = LinkedListNode<int>(42);
        final newHead = deleteByValue(head, 42);
        expect(newHead, isNull);
      });

      test('Handles value not found', () {
        final head = LinkedListNode.fromList<int>([1, 2, 3]);
        final newHead = deleteByValue(head, 5);
        expect(LinkedListNode.toList(newHead), equals([1, 2, 3]));
      });

      test('Handles empty list', () {
        final newHead = deleteByValue<int>(null, 1);
        expect(newHead, isNull);
      });

      test('Works with strings', () {
        final head = LinkedListNode.fromList<String>(['a', 'b', 'c']);
        final newHead = deleteByValue(head, 'b');
        expect(LinkedListNode.toList(newHead), equals(['a', 'c']));
      });
    });

    group('Complex Operations', () {
      test('Multiple insert and delete operations', () {
        // Start with empty list
        LinkedListNode<int>? head;

        // Insert elements
        head = insertAtPosition(head, 1, 0);
        head = insertAtPosition(head, 3, 1);
        head = insertAtPosition(head, 2, 1);
        expect(LinkedListNode.toList(head), equals([1, 2, 3]));

        // Delete middle element
        head = deleteAtPosition(head, 1);
        expect(LinkedListNode.toList(head), equals([1, 3]));

        // Insert after value
        head = insertAfterValue(head, 1, 2);
        expect(LinkedListNode.toList(head), equals([1, 2, 3]));

        // Delete by value
        head = deleteByValue(head, 2);
        expect(LinkedListNode.toList(head), equals([1, 3]));
      });

      test('Handles edge cases', () {
        final head = LinkedListNode.fromList<int>([1, 1, 1]);

        // Delete all occurrences of 1
        var newHead = deleteByValue(head, 1);
        expect(LinkedListNode.toList(newHead), equals([1, 1]));

        newHead = deleteByValue(newHead, 1);
        expect(LinkedListNode.toList(newHead), equals([1]));

        newHead = deleteByValue(newHead, 1);
        expect(newHead, isNull);
      });
    });
  });
}
