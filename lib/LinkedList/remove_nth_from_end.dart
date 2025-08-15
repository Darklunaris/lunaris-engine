/// 🗑️ Remove Nth Node From End Algorithm
///
/// Efficient algorithm to remove the nth node from the end of a linked list
/// using the two-pointer technique. This is a common interview problem.
///
/// **Time Complexity**: O(n) where n is the length of the list
/// **Space Complexity**: O(1)
library;

import 'linked_list_node.dart';

/// Removes the nth node from the end of the linked list
///
/// [head] - The head of the linked list
/// [n] - The position from the end (1-indexed)
/// Returns the new head of the linked list
///
/// **Time Complexity**: O(n) where n is the length of the list
/// **Space Complexity**: O(1)
LinkedListNode<T>? removeNthFromEnd<T>(LinkedListNode<T>? head, int n) {
  if (head == null || n <= 0) return head;

  // Create a dummy node to handle edge cases
  LinkedListNode<T> dummy = LinkedListNode<T>(head.value);
  dummy.next = head;

  LinkedListNode<T>? first = dummy;
  LinkedListNode<T>? second = dummy;

  // Move first pointer n+1 steps ahead
  for (int i = 0; i <= n; i++) {
    if (first == null) return head; // n is greater than list length
    first = first.next;
  }

  // Move both pointers until first reaches the end
  while (first != null) {
    first = first.next;
    second = second!.next;
  }

  // Remove the nth node from end
  second!.next = second.next!.next;

  return dummy.next;
}

/// Removes the nth node from the end using single pass with length calculation
///
/// [head] - The head of the linked list
/// [n] - The position from the end (1-indexed)
/// Returns the new head of the linked list
///
/// **Time Complexity**: O(n) where n is the length of the list
/// **Space Complexity**: O(1)
LinkedListNode<T>? removeNthFromEndSinglePass<T>(
  LinkedListNode<T>? head,
  int n,
) {
  if (head == null || n <= 0) return head;

  // Calculate the length of the list
  int length = 0;
  LinkedListNode<T>? current = head;
  while (current != null) {
    length++;
    current = current.next;
  }

  // If n is greater than or equal to length, remove the first node
  if (n >= length) {
    return head.next;
  }

  // Find the node before the one to be removed
  int position = length - n - 1;
  current = head;
  for (int i = 0; i < position; i++) {
    current = current!.next;
  }

  // Remove the node
  current!.next = current.next!.next;

  return head;
}

/// Removes the nth node from the end using recursive approach
///
/// [head] - The head of the linked list
/// [n] - The position from the end (1-indexed)
/// Returns the new head of the linked list
///
/// **Time Complexity**: O(n) where n is the length of the list
/// **Space Complexity**: O(n) due to recursion stack
LinkedListNode<T>? removeNthFromEndRecursive<T>(
  LinkedListNode<T>? head,
  int n,
) {
  if (head == null || n <= 0) return head;

  int count = 0;
  return _removeNthFromEndHelper(head, n, count);
}

/// Helper function for recursive removal of nth node from end
///
/// [head] - The head of the linked list
/// [n] - The position from the end (1-indexed)
/// [count] - Current count (passed by reference)
/// Returns the new head of the linked list
LinkedListNode<T>? _removeNthFromEndHelper<T>(
  LinkedListNode<T>? head,
  int n,
  int count,
) {
  if (head == null) return null;

  head.next = _removeNthFromEndHelper(head.next, n, count + 1);

  // If this is the nth node from end, remove it
  if (count == n - 1) {
    return head.next;
  }

  return head;
}

/// Removes the nth node from the end and returns both the new head and the removed node
///
/// [head] - The head of the linked list
/// [n] - The position from the end (1-indexed)
/// Returns a map containing 'head' and 'removedNode'
///
/// **Time Complexity**: O(n) where n is the length of the list
/// **Space Complexity**: O(1)
Map<String, LinkedListNode<T>?> removeNthFromEndWithReturn<T>(
  LinkedListNode<T>? head,
  int n,
) {
  if (head == null || n <= 0) {
    return {'head': head, 'removedNode': null};
  }

  LinkedListNode<T> dummy = LinkedListNode<T>(head.value);
  dummy.next = head;

  LinkedListNode<T>? first = dummy;
  LinkedListNode<T>? second = dummy;

  // Move first pointer n+1 steps ahead
  for (int i = 0; i <= n; i++) {
    if (first == null) {
      return {'head': head, 'removedNode': null};
    }
    first = first.next;
  }

  // Move both pointers until first reaches the end
  while (first != null) {
    first = first.next;
    second = second!.next;
  }

  // Store the node to be removed
  LinkedListNode<T>? removedNode = second!.next;

  // Remove the nth node from end
  second.next = second.next!.next;

  return {'head': dummy.next, 'removedNode': removedNode};
}
