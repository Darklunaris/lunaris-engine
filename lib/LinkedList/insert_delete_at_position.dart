/// 📍 Insert and Delete at Position Algorithms
///
/// Algorithms for inserting and deleting nodes at specific positions in a linked list.
/// These operations are fundamental for linked list manipulation.
///
/// **Time Complexity**: O(n) where n is the position or length of list
/// **Space Complexity**: O(1) for all operations
library;

import 'linked_list_node.dart';

/// Inserts a new node with the given value at the specified position
///
/// [head] - The head of the linked list
/// [value] - The value to insert
/// [position] - The position where to insert (0-indexed)
/// Returns the new head of the linked list
///
/// **Time Complexity**: O(n) where n is the position
/// **Space Complexity**: O(1)
LinkedListNode<T>? insertAtPosition<T>(
  LinkedListNode<T>? head,
  T value,
  int position,
) {
  // Handle insertion at the beginning
  if (position == 0) {
    LinkedListNode<T> newNode = LinkedListNode<T>(value);
    newNode.next = head;
    return newNode;
  }

  // Handle invalid position
  if (position < 0) return head;

  LinkedListNode<T>? current = head;
  int currentPosition = 0;

  // Traverse to the position before where we want to insert
  while (current != null && currentPosition < position - 1) {
    current = current.next;
    currentPosition++;
  }

  // If we reached the end before the position, return original head
  if (current == null) return head;

  // Insert the new node
  LinkedListNode<T> newNode = LinkedListNode<T>(value);
  newNode.next = current.next;
  current.next = newNode;

  return head;
}

/// Deletes the node at the specified position
///
/// [head] - The head of the linked list
/// [position] - The position of the node to delete (0-indexed)
/// Returns the new head of the linked list
///
/// **Time Complexity**: O(n) where n is the position
/// **Space Complexity**: O(1)
LinkedListNode<T>? deleteAtPosition<T>(LinkedListNode<T>? head, int position) {
  // Handle empty list
  if (head == null) return null;

  // Handle deletion of the first node
  if (position == 0) {
    return head.next;
  }

  // Handle invalid position
  if (position < 0) return head;

  LinkedListNode<T>? current = head;
  int currentPosition = 0;

  // Traverse to the position before the node to delete
  while (current != null && currentPosition < position - 1) {
    current = current.next;
    currentPosition++;
  }

  // If we reached the end or the next node doesn't exist, return original head
  if (current == null || current.next == null) return head;

  // Delete the node by updating the next pointer
  current.next = current.next!.next;

  return head;
}

/// Inserts a new node with the given value after a node with the specified value
///
/// [head] - The head of the linked list
/// [afterValue] - The value after which to insert
/// [newValue] - The value to insert
/// Returns the head of the linked list (unchanged if afterValue not found)
///
/// **Time Complexity**: O(n) where n is the length of the list
/// **Space Complexity**: O(1)
LinkedListNode<T>? insertAfterValue<T>(
  LinkedListNode<T>? head,
  T afterValue,
  T newValue,
) {
  LinkedListNode<T>? current = head;

  while (current != null) {
    if (current.value == afterValue) {
      LinkedListNode<T> newNode = LinkedListNode<T>(newValue);
      newNode.next = current.next;
      current.next = newNode;
      break;
    }
    current = current.next;
  }

  return head;
}

/// Deletes the first node with the specified value
///
/// [head] - The head of the linked list
/// [value] - The value to delete
/// Returns the new head of the linked list
///
/// **Time Complexity**: O(n) where n is the length of the list
/// **Space Complexity**: O(1)
LinkedListNode<T>? deleteByValue<T>(LinkedListNode<T>? head, T value) {
  // Handle empty list
  if (head == null) return null;

  // Handle deletion of the first node
  if (head.value == value) {
    return head.next;
  }

  LinkedListNode<T>? current = head;

  while (current!.next != null) {
    if (current.next!.value == value) {
      current.next = current.next!.next;
      break;
    }
    current = current.next;
  }

  return head;
}
