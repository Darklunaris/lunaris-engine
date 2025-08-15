/// 🔍 Cycle Detection Algorithms (Floyd's Algorithm)
///
/// Implements Floyd's Cycle-Finding Algorithm (Tortoise and Hare) to detect
/// cycles in linked lists efficiently. Also includes methods to find cycle
/// length and starting point.
///
/// **Time Complexity**: O(n) where n is the length of the list
/// **Space Complexity**: O(1) for Floyd's algorithm
library;

import 'linked_list_node.dart';

/// Detects if a cycle exists in the linked list using Floyd's algorithm
///
/// [head] - The head of the linked list to check
/// Returns true if a cycle exists, false otherwise
///
/// **Time Complexity**: O(n) where n is the length of the list
/// **Space Complexity**: O(1)
bool detectCycle<T>(LinkedListNode<T>? head) {
  if (head == null || head.next == null) return false;

  LinkedListNode<T>? slow = head; // Tortoise
  LinkedListNode<T>? fast = head; // Hare

  // Move slow by 1 and fast by 2
  while (fast != null && fast.next != null) {
    slow = slow!.next;
    fast = fast.next!.next;

    // If they meet, there's a cycle
    if (slow == fast) {
      return true;
    }
  }

  return false;
}

/// Finds the starting node of the cycle if it exists
///
/// [head] - The head of the linked list
/// Returns the starting node of the cycle, or null if no cycle exists
///
/// **Time Complexity**: O(n) where n is the length of the list
/// **Space Complexity**: O(1)
LinkedListNode<T>? findCycleStart<T>(LinkedListNode<T>? head) {
  if (head == null || head.next == null) return null;

  LinkedListNode<T>? slow = head;
  LinkedListNode<T>? fast = head;

  // First phase: find the meeting point
  bool hasCycle = false;
  while (fast != null && fast.next != null) {
    slow = slow!.next;
    fast = fast.next!.next;

    if (slow == fast) {
      hasCycle = true;
      break;
    }
  }

  // If no cycle, return null
  if (!hasCycle) return null;

  // Second phase: find the start of the cycle
  slow = head;
  while (slow != fast) {
    slow = slow!.next;
    fast = fast!.next;
  }

  return slow;
}

/// Calculates the length of the cycle if it exists
///
/// [head] - The head of the linked list
/// Returns the length of the cycle, or 0 if no cycle exists
///
/// **Time Complexity**: O(n) where n is the length of the list
/// **Space Complexity**: O(1)
int getCycleLength<T>(LinkedListNode<T>? head) {
  if (head == null || head.next == null) return 0;

  LinkedListNode<T>? slow = head;
  LinkedListNode<T>? fast = head;

  // First phase: find the meeting point
  bool hasCycle = false;
  while (fast != null && fast.next != null) {
    slow = slow!.next;
    fast = fast.next!.next;

    if (slow == fast) {
      hasCycle = true;
      break;
    }
  }

  // If no cycle, return 0
  if (!hasCycle) return 0;

  // Second phase: count the length of the cycle
  int length = 1;
  fast = fast!.next;
  while (slow != fast) {
    fast = fast!.next;
    length++;
  }

  return length;
}

/// Detects cycle using hash set approach (alternative method)
///
/// [head] - The head of the linked list to check
/// Returns true if a cycle exists, false otherwise
///
/// **Time Complexity**: O(n) where n is the length of the list
/// **Space Complexity**: O(n) due to hash set
bool detectCycleWithHashSet<T>(LinkedListNode<T>? head) {
  Set<LinkedListNode<T>> visited = {};
  LinkedListNode<T>? current = head;

  while (current != null) {
    if (visited.contains(current)) {
      return true;
    }
    visited.add(current);
    current = current.next;
  }

  return false;
}

/// Removes the cycle from the linked list if it exists
///
/// [head] - The head of the linked list
/// Returns the head of the linked list with cycle removed
///
/// **Time Complexity**: O(n) where n is the length of the list
/// **Space Complexity**: O(1)
LinkedListNode<T>? removeCycle<T>(LinkedListNode<T>? head) {
  if (head == null || head.next == null) return head;

  LinkedListNode<T>? slow = head;
  LinkedListNode<T>? fast = head;

  // First phase: find the meeting point
  bool hasCycle = false;
  while (fast != null && fast.next != null) {
    slow = slow!.next;
    fast = fast.next!.next;

    if (slow == fast) {
      hasCycle = true;
      break;
    }
  }

  // If no cycle, return original head
  if (!hasCycle) return head;

  // Second phase: find the start of the cycle
  slow = head;
  while (slow!.next != fast!.next) {
    slow = slow.next;
    fast = fast.next;
  }

  // Remove the cycle
  fast.next = null;

  return head;
}
