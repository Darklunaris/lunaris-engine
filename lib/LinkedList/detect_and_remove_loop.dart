/// � Detect and Remove Loop in Linked List — Floyd's cycle detection + repair
///
/// Detects a cycle in a singly linked list using Floyd's Tortoise & Hare algorithm
/// and removes the loop by locating the loop start and severing the connection.
/// Returns `true` when a cycle was found and removed; otherwise `false`.
///
/// Contract:
/// - Inputs: `head` (nullable linked list head).
/// - Output: boolean indicating whether a loop was found and removed.
/// - Error modes: none; `null` input returns `false`.
///
/// Complexity: Time O(n), Space O(1).
///
/// Example:
/// ```dart
/// final head = LinkedListNode.fromList([1,2,3,4,5]);
/// head!.next!.next!.next!.next!.next = head.next!.next; // create loop
/// final found = detectAndRemoveLoop(head);
/// // found == true, loop removed
/// ```
library;

import 'linked_list_node.dart';

bool detectAndRemoveLoop<T>(LinkedListNode<T>? head) {
  if (head == null) return false;
  LinkedListNode<T>? slow = head, fast = head;
  // Detect loop
  while (fast != null && fast.next != null) {
    slow = slow!.next;
    fast = fast.next!.next;
    if (slow == fast) break;
  }
  if (fast == null || fast.next == null) return false;
  // Find loop start
  slow = head;
  while (slow != fast) {
    slow = slow!.next;
    fast = fast!.next;
  }
  // Remove loop
  while (fast!.next != slow) {
    fast = fast.next;
  }
  fast.next = null;
  return true;
}
