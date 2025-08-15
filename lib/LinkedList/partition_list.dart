/// � Partition Linked List — stable partition preserving relative order
///
/// Partitions a singly linked list around a pivot `x` so that nodes with values
/// less than `x` appear before nodes greater than or equal to `x`. The relative
/// order of nodes in each partition is preserved (stable partition).
///
/// Contract:
/// - Inputs: `head` (nullable linked list head), `x` (pivot value of type Comparable).
/// - Output: head of partitioned list (nullable). If `head` is `null`, returns `null`.
/// - Error modes: none; function treats `x` using `compareTo` and requires `T extends Comparable`.
///
/// Complexity: Time O(n), Space O(1) (uses constant extra pointers and builds partitions by relinking).
///
/// Example:
/// ```dart
/// final head = LinkedListNode.fromList([1,4,3,2,5,2]);
/// final partitioned = partitionList(head, 3);
/// // partitioned: [1,2,2,4,3,5]
/// ```
library;

import 'linked_list_node.dart';

LinkedListNode<T>? partitionList<T extends Comparable>(
  LinkedListNode<T>? head,
  T x,
) {
  if (head == null) return null;
  final beforeHead = LinkedListNode<T>(x);
  final afterHead = LinkedListNode<T>(x);
  var before = beforeHead;
  var after = afterHead;
  LinkedListNode<T>? current = head;
  while (current != null) {
    if (current.value.compareTo(x) < 0) {
      before.next = LinkedListNode<T>(current.value);
      before = before.next!;
    } else {
      after.next = LinkedListNode<T>(current.value);
      after = after.next!;
    }
    current = current.next;
  }
  // If no elements were less than x, return the after list
  if (beforeHead.next == null) return afterHead.next;
  before.next = afterHead.next;
  return beforeHead.next;
}
