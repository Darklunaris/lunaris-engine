/// 🎭 Palindrome Linked List Algorithm
///
/// Efficient algorithm to check if a linked list is a palindrome.
/// Uses the two-pointer technique to find the middle and reverse the second half.
///
/// **Time Complexity**: O(n) where n is the length of the list
/// **Space Complexity**: O(1)
library;

import 'linked_list_node.dart';

/// Checks if a linked list is a palindrome
///
/// [head] - The head of the linked list to check
/// Returns true if the linked list is a palindrome, false otherwise
///
/// **Time Complexity**: O(n) where n is the length of the list
/// **Space Complexity**: O(1)
bool isPalindrome<T>(LinkedListNode<T>? head) {
  if (head == null || head.next == null) return true;

  // Find the middle of the list
  LinkedListNode<T>? slow = head;
  LinkedListNode<T>? fast = head;

  while (fast!.next != null && fast.next!.next != null) {
    slow = slow!.next;
    fast = fast.next!.next;
  }

  // Reverse the second half
  LinkedListNode<T>? secondHalf = reverseLinkedList(slow!.next);
  LinkedListNode<T>? firstHalf = head;

  // Compare the two halves
  LinkedListNode<T>? temp = secondHalf;
  bool result = true;

  while (secondHalf != null) {
    if (firstHalf!.value != secondHalf.value) {
      result = false;
      break;
    }
    firstHalf = firstHalf.next;
    secondHalf = secondHalf.next;
  }

  // Restore the original list
  slow.next = reverseLinkedList(temp);

  return result;
}

/// Checks if a linked list is a palindrome using stack approach
///
/// [head] - The head of the linked list to check
/// Returns true if the linked list is a palindrome, false otherwise
///
/// **Time Complexity**: O(n) where n is the length of the list
/// **Space Complexity**: O(n) due to stack usage
bool isPalindromeWithStack<T>(LinkedListNode<T>? head) {
  if (head == null || head.next == null) return true;

  // Find the length of the list
  int length = 0;
  LinkedListNode<T>? current = head;
  while (current != null) {
    length++;
    current = current.next;
  }

  // Push first half to stack
  List<T> stack = [];
  current = head;
  for (int i = 0; i < length ~/ 2; i++) {
    stack.add(current!.value);
    current = current.next;
  }

  // Skip middle node if odd length
  if (length % 2 == 1) {
    current = current!.next;
  }

  // Compare with second half
  while (current != null) {
    if (stack.isEmpty || stack.removeLast() != current.value) {
      return false;
    }
    current = current.next;
  }

  return stack.isEmpty;
}

/// Checks if a linked list is a palindrome using recursive approach
///
/// [head] - The head of the linked list to check
/// Returns true if the linked list is a palindrome, false otherwise
///
/// **Time Complexity**: O(n) where n is the length of the list
/// **Space Complexity**: O(n) due to recursion stack
bool isPalindromeRecursive<T>(LinkedListNode<T>? head) {
  if (head == null || head.next == null) return true;

  LinkedListNode<T>? frontPointer = head;
  return _isPalindromeHelper(head, frontPointer);
}

/// Helper function for recursive palindrome check
///
/// [currentNode] - Current node being checked
/// [frontPointer] - Pointer to the front of the list
/// Returns true if the linked list is a palindrome, false otherwise
bool _isPalindromeHelper<T>(
  LinkedListNode<T>? currentNode,
  LinkedListNode<T>? frontPointer,
) {
  if (currentNode == null) return true;

  // Recursively check the rest of the list
  if (!_isPalindromeHelper(currentNode.next, frontPointer)) {
    return false;
  }

  // Compare current node with front pointer
  if (currentNode.value != frontPointer!.value) {
    return false;
  }

  // Move front pointer forward
  frontPointer = frontPointer.next;
  return true;
}

/// Checks if a linked list is a palindrome using array approach
///
/// [head] - The head of the linked list to check
/// Returns true if the linked list is a palindrome, false otherwise
///
/// **Time Complexity**: O(n) where n is the length of the list
/// **Space Complexity**: O(n) due to array usage
bool isPalindromeWithArray<T>(LinkedListNode<T>? head) {
  if (head == null || head.next == null) return true;

  // Convert linked list to array
  List<T> values = [];
  LinkedListNode<T>? current = head;
  while (current != null) {
    values.add(current.value);
    current = current.next;
  }

  // Check if array is palindrome
  int left = 0;
  int right = values.length - 1;
  while (left < right) {
    if (values[left] != values[right]) {
      return false;
    }
    left++;
    right--;
  }

  return true;
}

/// Helper function to reverse a linked list
///
/// [head] - The head of the linked list to reverse
/// Returns the new head of the reversed linked list
LinkedListNode<T>? reverseLinkedList<T>(LinkedListNode<T>? head) {
  LinkedListNode<T>? prev;
  LinkedListNode<T>? current = head;
  LinkedListNode<T>? next;

  while (current != null) {
    next = current.next;
    current.next = prev;
    prev = current;
    current = next;
  }

  return prev;
}
