import 'package:test/test.dart';
import 'package:lunaris_engine/LinkedList/linked_list_node.dart';
import 'package:lunaris_engine/LinkedList/add_two_numbers_linked_list.dart';

void main() {
  group('Add Two Numbers (Linked List)', () {
    test('Adds two numbers of same length', () {
      final l1 = LinkedListNode.fromList([2, 4, 3]);
      final l2 = LinkedListNode.fromList([5, 6, 4]);
      final sum = addTwoNumbersLinkedList(l1, l2);
      expect(LinkedListNode.toList(sum), equals([7, 0, 8]));
    });
    test('Adds two numbers of different lengths', () {
      final l1 = LinkedListNode.fromList([9, 9, 9, 9]);
      final l2 = LinkedListNode.fromList([9, 9, 9]);
      final sum = addTwoNumbersLinkedList(l1, l2);
      expect(LinkedListNode.toList(sum), equals([8, 9, 9, 0, 1]));
    });
    test('Adds with carry at end', () {
      final l1 = LinkedListNode.fromList([5]);
      final l2 = LinkedListNode.fromList([5]);
      final sum = addTwoNumbersLinkedList(l1, l2);
      expect(LinkedListNode.toList(sum), equals([0, 1]));
    });
    test('Single node lists', () {
      final l1 = LinkedListNode.fromList([1]);
      final l2 = LinkedListNode.fromList([9]);
      final sum = addTwoNumbersLinkedList(l1, l2);
      expect(LinkedListNode.toList(sum), equals([0, 1]));
    });
    test('Empty lists', () {
      final sum = addTwoNumbersLinkedList(null, null);
      expect(sum, isNull);
    });
    test('One null list', () {
      final l1 = LinkedListNode.fromList([1, 2, 3]);
      final sum = addTwoNumbersLinkedList(l1, null);
      expect(LinkedListNode.toList(sum), equals([1, 2, 3]));
    });

    test('Both null lists', () {
      final sum = addTwoNumbersLinkedList(null, null);
      expect(sum, isNull);
    });

    test('Large carries propagate', () {
      final l1 = LinkedListNode.fromList([9, 9, 9]);
      final l2 = LinkedListNode.fromList([1]);
      final sum = addTwoNumbersLinkedList(l1, l2);
      expect(LinkedListNode.toList(sum), equals([0, 0, 0, 1]));
    });
  });
}
