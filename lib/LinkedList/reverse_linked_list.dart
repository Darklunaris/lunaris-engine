/// 🔄 Reverse Linked List Algorithms
///
/// Algorithms for reversing linked lists in-place efficiently.
/// Includes both iterative and recursive approaches for singly linked lists
/// and specialized handling for doubly linked lists.
///
/// **Time Complexity**: O(n) where n is the length of the list
/// **Space Complexity**: O(1) for iterative, O(n) for recursive
library;

import 'linked_list_node.dart';
import 'doubly_linked_list_node.dart';

/// Reverses a singly linked list iteratively
///
/// [head] - The head of the linked list to reverse
/// Returns the new head of the reversed linked list
///
/// **Time Complexity**: O(n) where n is the length of the list
/// **Space Complexity**: O(1)
LinkedListNode<T>? reverseLinkedList<T>(LinkedListNode<T>? head) {
  LinkedListNode<T>? prev;
  LinkedListNode<T>? current = head;
  LinkedListNode<T>? next;

  while (current != null) {
    // Store the next node
    next = current.next;

    // Reverse the link
    current.next = prev;

    // Move pointers forward
    prev = current;
    current = next;
  }

  return prev;
}

/// Reverses a singly linked list recursively
///
/// [head] - The head of the linked list to reverse
/// Returns the new head of the reversed linked list
///
/// **Time Complexity**: O(n) where n is the length of the list
/// **Space Complexity**: O(n) due to recursion stack
LinkedListNode<T>? reverseLinkedListRecursive<T>(LinkedListNode<T>? head) {
  // Base case: empty list or single node
  if (head == null || head.next == null) {
    return head;
  }

  // Recursively reverse the rest of the list
  LinkedListNode<T>? newHead = reverseLinkedListRecursive(head.next);

  // Reverse the link
  head.next!.next = head;
  head.next = null;

  return newHead;
}

/// Reverses a doubly linked list
///
/// [head] - The head of the doubly linked list to reverse
/// Returns the new head of the reversed doubly linked list
///
/// **Time Complexity**: O(n) where n is the length of the list
/// **Space Complexity**: O(1)
DoublyLinkedListNode<T>? reverseDoublyLinkedList<T>(
  DoublyLinkedListNode<T>? head,
) {
  DoublyLinkedListNode<T>? current = head;
  DoublyLinkedListNode<T>? temp;

  // Traverse the list and swap next and prev pointers
  while (current != null) {
    // Store the next node
    temp = current.next;

    // Swap next and prev pointers
    current.next = current.prev;
    current.prev = temp;

    // Move to the next node (which is now in prev due to swap)
    current = temp;
  }

  // Return the new head (last node of original list)
  return temp?.prev ?? head;
}

/// Reverses a linked list in groups of specified size
///
/// [head] - The head of the linked list
/// [k] - The size of each group to reverse
/// Returns the new head of the linked list
///
/// **Time Complexity**: O(n) where n is the length of the list
/// **Space Complexity**: O(1)
LinkedListNode<T>? reverseInGroups<T>(LinkedListNode<T>? head, int k) {
  if (head == null || k <= 1) return head;

  LinkedListNode<T>? current = head;
  LinkedListNode<T>? prev;
  LinkedListNode<T>? next;
  int count = 0;

  // Reverse first k nodes
  while (current != null && count < k) {
    next = current.next;
    current.next = prev;
    prev = current;
    current = next;
    count++;
  }

  // Recursively reverse the remaining nodes
  if (next != null) {
    head.next = reverseInGroups(next, k);
  }

  return prev;
}

/// Reverses the nodes between two positions (inclusive)
///
/// [head] - The head of the linked list
/// [left] - The left position (1-indexed)
/// [right] - The right position (1-indexed)
/// Returns the new head of the linked list
///
/// **Time Complexity**: O(n) where n is the length of the list
/// **Space Complexity**: O(1)
LinkedListNode<T>? reverseBetween<T>(
  LinkedListNode<T>? head,
  int left,
  int right,
) {
  if (head == null || left == right) return head;

  // Create a dummy node to handle edge cases
  LinkedListNode<T> dummy = LinkedListNode<T>(head.value);
  dummy.next = head;
  LinkedListNode<T>? prev = dummy;

  // Move to the node before the left position
  for (int i = 0; i < left - 1; i++) {
    prev = prev!.next;
  }

  // Start reversing from the left position
  LinkedListNode<T>? current = prev!.next;
  for (int i = 0; i < right - left; i++) {
    LinkedListNode<T>? next = current!.next;
    current.next = next!.next;
    next.next = prev.next;
    prev.next = next;
  }

  return dummy.next;
}
