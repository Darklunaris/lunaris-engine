import 'package:test/test.dart';
import 'package:lunaris_engine/LinkedList/linked_list_node.dart';

void main() {
  group('LinkedListNode Tests', () {
    group('Basic Node Operations', () {
      test('Creates node with value', () {
        final node = LinkedListNode<int>(42);
        expect(node.value, equals(42));
        expect(node.next, isNull);
      });

      test('Connects nodes', () {
        final node1 = LinkedListNode<int>(1);
        final node2 = LinkedListNode<int>(2);
        node1.next = node2;

        expect(node1.next, equals(node2));
        expect(node1.next!.value, equals(2));
      });

      test('String representation', () {
        final node = LinkedListNode<String>('test');
        expect(node.toString(), equals('LinkedListNode(test)'));
      });
    });

    group('fromList Static Method', () {
      test('Creates linked list from empty list', () {
        final head = LinkedListNode.fromList<int>([]);
        expect(head, isNull);
      });

      test('Creates linked list from single element', () {
        final head = LinkedListNode.fromList<int>([42]);
        expect(head, isNotNull);
        expect(head!.value, equals(42));
        expect(head.next, isNull);
      });

      test('Creates linked list from multiple elements', () {
        final head = LinkedListNode.fromList<int>([1, 2, 3, 4, 5]);
        expect(head, isNotNull);

        final values = LinkedListNode.toList(head);
        expect(values, equals([1, 2, 3, 4, 5]));
      });

      test('Works with different types', () {
        final stringHead = LinkedListNode.fromList<String>(['a', 'b', 'c']);
        final doubleHead = LinkedListNode.fromList<double>([1.1, 2.2, 3.3]);

        expect(LinkedListNode.toList(stringHead), equals(['a', 'b', 'c']));
        expect(LinkedListNode.toList(doubleHead), equals([1.1, 2.2, 3.3]));
      });
    });

    group('toList Static Method', () {
      test('Converts empty list', () {
        final values = LinkedListNode.toList<int>(null);
        expect(values, equals([]));
      });

      test('Converts single node', () {
        final node = LinkedListNode<int>(42);
        final values = LinkedListNode.toList(node);
        expect(values, equals([42]));
      });

      test('Converts multiple nodes', () {
        final head = LinkedListNode<int>(1);
        head.next = LinkedListNode<int>(2);
        head.next!.next = LinkedListNode<int>(3);

        final values = LinkedListNode.toList(head);
        expect(values, equals([1, 2, 3]));
      });
    });

    group('length Static Method', () {
      test('Returns 0 for null', () {
        expect(LinkedListNode.length<int>(null), equals(0));
      });

      test('Returns 1 for single node', () {
        final node = LinkedListNode<int>(42);
        expect(LinkedListNode.length(node), equals(1));
      });

      test('Returns correct length for multiple nodes', () {
        final head = LinkedListNode<int>(1);
        head.next = LinkedListNode<int>(2);
        head.next!.next = LinkedListNode<int>(3);
        head.next!.next!.next = LinkedListNode<int>(4);

        expect(LinkedListNode.length(head), equals(4));
      });
    });

    group('Complex Operations', () {
      test('Creates and manipulates complex list', () {
        final head = LinkedListNode.fromList<int>([10, 20, 30, 40, 50]);

        // Verify initial state
        expect(LinkedListNode.length(head), equals(5));
        expect(LinkedListNode.toList(head), equals([10, 20, 30, 40, 50]));

        // Modify the list
        head!.next!.next!.value = 35;
        expect(LinkedListNode.toList(head), equals([10, 20, 35, 40, 50]));

        // Add a new node
        final newNode = LinkedListNode<int>(60);
        head.next!.next!.next!.next!.next = newNode;
        expect(LinkedListNode.length(head), equals(6));
        expect(LinkedListNode.toList(head), equals([10, 20, 35, 40, 50, 60]));
      });

      test('Handles large lists efficiently', () {
        final largeList = List.generate(1000, (i) => i);
        final head = LinkedListNode.fromList(largeList);

        expect(LinkedListNode.length(head), equals(1000));
        expect(LinkedListNode.toList(head), equals(largeList));
      });
    });
  });
}
