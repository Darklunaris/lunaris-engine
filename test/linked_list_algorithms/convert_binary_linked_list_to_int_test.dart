import 'package:test/test.dart';
import 'package:lunaris_engine/LinkedList/linked_list_node.dart';
import 'package:lunaris_engine/LinkedList/convert_binary_linked_list_to_int.dart';

void main() {
  group('Convert Binary Linked List to Integer', () {
    test('Converts 101 to 5', () {
      final head = LinkedListNode.fromList([1, 0, 1]);
      final value = convertBinaryLinkedListToInt(head);
      expect(value, equals(5));
    });
    test('Converts 0 to 0', () {
      final head = LinkedListNode.fromList([0]);
      final value = convertBinaryLinkedListToInt(head);
      expect(value, equals(0));
    });
    test('Converts 1 to 1', () {
      final head = LinkedListNode.fromList([1]);
      final value = convertBinaryLinkedListToInt(head);
      expect(value, equals(1));
    });
    test('Converts 1111 to 15', () {
      final head = LinkedListNode.fromList([1, 1, 1, 1]);
      final value = convertBinaryLinkedListToInt(head);
      expect(value, equals(15));
    });
    test('Empty list returns 0', () {
      final value = convertBinaryLinkedListToInt(null);
      expect(value, equals(0));
    });
    test('Empty list returns 0', () {
      final v = convertBinaryLinkedListToInt(null);
      expect(v, equals(0));
    });

    test('Long binary sequence', () {
      final head = LinkedListNode.fromList([1, 0, 1, 1, 0, 1]);
      final v = convertBinaryLinkedListToInt(head);
      // 101101 in binary = 45
      expect(v, equals(45));
    });
  });
}
