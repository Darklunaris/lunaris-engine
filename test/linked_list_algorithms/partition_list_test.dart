import 'package:test/test.dart';
import 'package:lunaris_engine/LinkedList/linked_list_node.dart';
import 'package:lunaris_engine/LinkedList/partition_list.dart';

void main() {
  group('Partition List', () {
    test('Partitions list around 3', () {
      final head = LinkedListNode.fromList([1, 4, 3, 2, 5, 2]);
      final partitioned = partitionList(head, 3);
      expect(LinkedListNode.toList(partitioned), equals([1, 2, 2, 4, 3, 5]));
    });
    test('All less than x', () {
      final head = LinkedListNode.fromList([1, 1, 1]);
      final partitioned = partitionList(head, 2);
      expect(LinkedListNode.toList(partitioned), equals([1, 1, 1]));
    });
    test('All greater than or equal to x', () {
      final head = LinkedListNode.fromList([5, 6, 7]);
      final partitioned = partitionList(head, 5);
      // stable partition: no elements <5, so original order is preserved
      expect(LinkedListNode.toList(partitioned), equals([5, 6, 7]));
    });
    test('Single node', () {
      final head = LinkedListNode.fromList([42]);
      final partitioned = partitionList(head, 10);
      expect(LinkedListNode.toList(partitioned), equals([42]));
    });
    test('Empty list', () {
      final partitioned = partitionList<int>(null, 3);
      expect(partitioned, isNull);
    });
    test('All nodes less than pivot', () {
      final head = LinkedListNode.fromList([1, 1, 2]);
      final partitioned = partitionList(head, 3);
      expect(LinkedListNode.toList(partitioned), equals([1, 1, 2]));
    });

    test('All nodes greater or equal pivot', () {
      final head = LinkedListNode.fromList([5, 6, 7]);
      final partitioned = partitionList(head, 3);
      expect(LinkedListNode.toList(partitioned), equals([5, 6, 7]));
    });

    test('Stability preserved for equal elements', () {
      final head = LinkedListNode.fromList([3, 1, 3, 2]);
      final partitioned = partitionList(head, 3);
      // nodes <3: [1,2] in original order; nodes >=3: [3,3]
      expect(LinkedListNode.toList(partitioned), equals([1, 2, 3, 3]));
    });
  });
}
