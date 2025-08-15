/// � Swap Nodes in Pairs — safe adjacent node swapping
///
/// Performs an in-place swap of every two adjacent nodes in a singly linked list
/// and returns the new head. The algorithm preserves node objects and only
/// adjusts pointers (no value-swapping), making it suitable for nodes with
/// complex payloads.
///
/// Contract:
/// - Inputs: `head` (nullable linked list head).
/// - Output: new head (nullable). If the list has odd length, the final node is left as-is.
/// - Error modes: none; `null` input returns `null`.
///
/// Complexity: Time O(n), Space O(1).
///
/// Example:
/// ```dart
/// final head = LinkedListNode.fromList([1,2,3,4]);
/// final swapped = swapNodesInPairs(head);
/// // swapped: [2,1,4,3]
/// ```
library;

import 'linked_list_node.dart';

LinkedListNode<T>? swapNodesInPairs<T>(LinkedListNode<T>? head) {
  if (head == null) return null;
  final dummy = LinkedListNode<T>(head.value);
  dummy.next = head;
  LinkedListNode<T>? prev = dummy;
  while (prev!.next != null && prev.next!.next != null) {
    final first = prev.next;
    final second = prev.next!.next;
    first!.next = second!.next;
    second.next = first;
    prev.next = second;
    prev = first;
  }
  return dummy.next;
}
