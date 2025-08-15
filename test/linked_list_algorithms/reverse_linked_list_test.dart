import 'package:test/test.dart';
import 'package:lunaris_engine/LinkedList/linked_list_node.dart';
import 'package:lunaris_engine/LinkedList/reverse_linked_list.dart';

void main() {
  group('Reverse Linked List Tests', () {
    group('reverseLinkedList Tests', () {
      test('Reverses empty list', () {
        final head = reverseLinkedList<int>(null);
        expect(head, isNull);
      });

      test('Reverses single node', () {
        final head = LinkedListNode<int>(42);
        final reversed = reverseLinkedList(head);
        expect(LinkedListNode.toList(reversed), equals([42]));
      });

      test('Reverses two nodes', () {
        final head = LinkedListNode.fromList<int>([1, 2]);
        final reversed = reverseLinkedList(head);
        expect(LinkedListNode.toList(reversed), equals([2, 1]));
      });

      test('Reverses multiple nodes', () {
        final head = LinkedListNode.fromList<int>([1, 2, 3, 4, 5]);
        final reversed = reverseLinkedList(head);
        expect(LinkedListNode.toList(reversed), equals([5, 4, 3, 2, 1]));
      });

      test('Works with strings', () {
        final head = LinkedListNode.fromList<String>(['a', 'b', 'c']);
        final reversed = reverseLinkedList(head);
        expect(LinkedListNode.toList(reversed), equals(['c', 'b', 'a']));
      });

      test('Reverses and then reverses back', () {
        final original = LinkedListNode.fromList<int>([1, 2, 3, 4, 5]);
        final reversed = reverseLinkedList(original);
        final backToOriginal = reverseLinkedList(reversed);
        expect(LinkedListNode.toList(backToOriginal), equals([1, 2, 3, 4, 5]));
      });
    });

    group('reverseLinkedListRecursive Tests', () {
      test('Reverses empty list recursively', () {
        final head = reverseLinkedListRecursive<int>(null);
        expect(head, isNull);
      });

      test('Reverses single node recursively', () {
        final head = LinkedListNode<int>(42);
        final reversed = reverseLinkedListRecursive(head);
        expect(LinkedListNode.toList(reversed), equals([42]));
      });

      test('Reverses multiple nodes recursively', () {
        final head = LinkedListNode.fromList<int>([1, 2, 3, 4, 5]);
        final reversed = reverseLinkedListRecursive(head);
        expect(LinkedListNode.toList(reversed), equals([5, 4, 3, 2, 1]));
      });

      test('Recursive and iterative give same result', () {
        final head1 = LinkedListNode.fromList<int>([1, 2, 3, 4, 5]);
        final head2 = LinkedListNode.fromList<int>([1, 2, 3, 4, 5]);
        final iterative = reverseLinkedList(head1);
        final recursive = reverseLinkedListRecursive(head2);
        expect(
          LinkedListNode.toList(iterative),
          equals(LinkedListNode.toList(recursive)),
        );
      });
    });

    group('reverseInGroups Tests', () {
      test('Reverses in groups of 2', () {
        final head = LinkedListNode.fromList<int>([1, 2, 3, 4, 5, 6]);
        final reversed = reverseInGroups(head, 2);
        expect(LinkedListNode.toList(reversed), equals([2, 1, 4, 3, 6, 5]));
      });

      test('Reverses in groups of 3', () {
        final head = LinkedListNode.fromList<int>([1, 2, 3, 4, 5, 6]);
        final reversed = reverseInGroups(head, 3);
        expect(LinkedListNode.toList(reversed), equals([3, 2, 1, 6, 5, 4]));
      });

      test('Handles group size larger than list', () {
        final head = LinkedListNode.fromList<int>([1, 2, 3]);
        final reversed = reverseInGroups(head, 5);
        expect(LinkedListNode.toList(reversed), equals([3, 2, 1]));
      });

      test('Handles group size of 1', () {
        final head = LinkedListNode.fromList<int>([1, 2, 3, 4]);
        final reversed = reverseInGroups(head, 1);
        expect(LinkedListNode.toList(reversed), equals([1, 2, 3, 4]));
      });

      test('Handles empty list', () {
        final head = reverseInGroups<int>(null, 2);
        expect(head, isNull);
      });
    });

    group('reverseBetween Tests', () {
      test('Reverses middle portion', () {
        final head = LinkedListNode.fromList<int>([1, 2, 3, 4, 5]);
        final reversed = reverseBetween(head, 2, 4);
        expect(LinkedListNode.toList(reversed), equals([1, 4, 3, 2, 5]));
      });

      test('Reverses from beginning', () {
        final head = LinkedListNode.fromList<int>([1, 2, 3, 4, 5]);
        final reversed = reverseBetween(head, 1, 3);
        expect(LinkedListNode.toList(reversed), equals([3, 2, 1, 4, 5]));
      });

      test('Reverses to end', () {
        final head = LinkedListNode.fromList<int>([1, 2, 3, 4, 5]);
        final reversed = reverseBetween(head, 3, 5);
        expect(LinkedListNode.toList(reversed), equals([1, 2, 5, 4, 3]));
      });

      test('Reverses entire list', () {
        final head = LinkedListNode.fromList<int>([1, 2, 3, 4, 5]);
        final reversed = reverseBetween(head, 1, 5);
        expect(LinkedListNode.toList(reversed), equals([5, 4, 3, 2, 1]));
      });

      test('Handles same left and right', () {
        final head = LinkedListNode.fromList<int>([1, 2, 3, 4, 5]);
        final reversed = reverseBetween(head, 3, 3);
        expect(LinkedListNode.toList(reversed), equals([1, 2, 3, 4, 5]));
      });

      test('Handles empty list', () {
        final head = reverseBetween<int>(null, 1, 3);
        expect(head, isNull);
      });
    });

    group('Complex Operations', () {
      test('Multiple reverse operations', () {
        var head = LinkedListNode.fromList<int>([1, 2, 3, 4, 5, 6, 7, 8]);

        // Reverse in groups of 3
        head = reverseInGroups(head, 3);
        expect(LinkedListNode.toList(head), equals([3, 2, 1, 6, 5, 4, 8, 7]));

        // Reverse between positions 2 and 6
        head = reverseBetween(head, 2, 6);
        expect(LinkedListNode.toList(head), equals([3, 4, 5, 6, 1, 2, 8, 7]));

        // Reverse entire list
        head = reverseLinkedList(head);
        expect(LinkedListNode.toList(head), equals([7, 8, 2, 1, 6, 5, 4, 3]));
      });

      test('Edge cases', () {
        // Single node
        var head = LinkedListNode<int>(42);
        head = reverseLinkedList(head)!;
        expect(LinkedListNode.toList(head), equals([42]));

        // Two nodes
        head = LinkedListNode.fromList<int>([1, 2])!;
        head = reverseLinkedList(head)!;
        expect(LinkedListNode.toList(head), equals([2, 1]));
      });
    });
  });
}
