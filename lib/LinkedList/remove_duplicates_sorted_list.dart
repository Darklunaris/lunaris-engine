/// 🧹 Remove Duplicates from Sorted Linked List — in-place deduplication
///
/// Removes duplicate consecutive values from a sorted singly linked list by
/// rewiring `next` pointers. The function is generic and does not allocate new
/// nodes; it relies on equality (`==`) for value comparisons.
///
/// Contract:
/// - Inputs: `head` (nullable linked list head) where values are sorted in non-decreasing order.
/// - Output: head of the deduplicated list (nullable). If `head` is `null`, returns `null`.
/// - Error modes: behavior is undefined if the list is unsorted.
///
/// Complexity: Time O(n), Space O(1).
///
/// Example:
/// ```dart
/// final head = LinkedListNode.fromList([1,1,2,3,3]);
/// final deduped = removeDuplicatesSortedList(head);
/// // deduped: [1,2,3]
/// ```
library;

import 'linked_list_node.dart';

LinkedListNode<T>? removeDuplicatesSortedList<T>(LinkedListNode<T>? head) {
  var current = head;
  while (current != null && current.next != null) {
    if (current.value == current.next!.value) {
      current.next = current.next!.next;
    } else {
      current = current.next;
    }
  }
  return head;
}
