/// � Rotate Linked List — robust, generic implementation
///
/// Rotates a singly linked list to the right by `k` places and returns the new head.
/// The function operates in-place (O(1) extra space) and runs in a single pass to compute
/// length plus a second pass to rewire pointers when necessary.
///
/// Contract:
/// - Inputs: `head` (nullable linked list head), `k` (non-negative rotation count).
/// - Output: new head of the rotated list (nullable). Returns `null` when `head` is `null`.
/// - Error modes: negative `k` is treated as invalid (caller should provide non-negative `k`).
///
/// Complexity: Time O(n), Space O(1).
///
/// Example:
/// ```dart
/// final head = LinkedListNode.fromList([1,2,3,4,5]);
/// final rotated = rotateLinkedList(head, 2);
/// // rotated: [4,5,1,2,3]
/// ```
library;

import 'linked_list_node.dart';

LinkedListNode<T>? rotateLinkedList<T>(LinkedListNode<T>? head, int k) {
  if (head == null || head.next == null || k == 0) return head;
  // Compute the length and get the tail
  int length = 1;
  LinkedListNode<T>? tail = head;
  while (tail!.next != null) {
    tail = tail.next;
    length++;
  }
  k = k % length;
  if (k == 0) return head;
  // Make it circular
  tail.next = head;
  // Find new tail: (length - k - 1)th node
  LinkedListNode<T>? newTail = head;
  for (int i = 0; i < length - k - 1; i++) {
    newTail = newTail!.next;
  }
  LinkedListNode<T>? newHead = newTail!.next;
  newTail.next = null;
  return newHead;
}
