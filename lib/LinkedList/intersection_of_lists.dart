/// 🔗 Intersection of Two Linked Lists Algorithm
///
/// Efficient algorithm to find the intersection point of two linked lists.
/// Uses multiple approaches including length difference and two-pointer technique.
///
/// **Time Complexity**: O(n + m) where n and m are the lengths of the lists
/// **Space Complexity**: O(1)
library;

import 'linked_list_node.dart';

/// Finds the intersection point of two linked lists
///
/// [headA] - The head of the first linked list
/// [headB] - The head of the second linked list
/// Returns the intersection node, or null if no intersection exists
///
/// **Time Complexity**: O(n + m) where n and m are the lengths of the lists
/// **Space Complexity**: O(1)
LinkedListNode<T>? getIntersectionNode<T>(
  LinkedListNode<T>? headA,
  LinkedListNode<T>? headB,
) {
  if (headA == null || headB == null) return null;

  // Calculate lengths of both lists
  int lenA = getLength(headA);
  int lenB = getLength(headB);

  // Move the longer list forward by the difference
  LinkedListNode<T>? currentA = headA;
  LinkedListNode<T>? currentB = headB;

  if (lenA > lenB) {
    for (int i = 0; i < lenA - lenB; i++) {
      currentA = currentA!.next;
    }
  } else if (lenB > lenA) {
    for (int i = 0; i < lenB - lenA; i++) {
      currentB = currentB!.next;
    }
  }

  // Move both pointers until they meet
  while (currentA != null && currentB != null) {
    if (currentA == currentB) {
      return currentA;
    }
    currentA = currentA.next;
    currentB = currentB.next;
  }

  return null;
}

/// Finds the intersection point using hash set approach
///
/// [headA] - The head of the first linked list
/// [headB] - The head of the second linked list
/// Returns the intersection node, or null if no intersection exists
///
/// **Time Complexity**: O(n + m) where n and m are the lengths of the lists
/// **Space Complexity**: O(n) due to hash set usage
LinkedListNode<T>? getIntersectionNodeWithHashSet<T>(
  LinkedListNode<T>? headA,
  LinkedListNode<T>? headB,
) {
  if (headA == null || headB == null) return null;

  Set<LinkedListNode<T>> visited = {};
  LinkedListNode<T>? current = headA;

  // Add all nodes from first list to set
  while (current != null) {
    visited.add(current);
    current = current.next;
  }

  // Check second list for intersection
  current = headB;
  while (current != null) {
    if (visited.contains(current)) {
      return current;
    }
    current = current.next;
  }

  return null;
}

/// Finds the intersection point using two-pointer technique
///
/// [headA] - The head of the first linked list
/// [headB] - The head of the second linked list
/// Returns the intersection node, or null if no intersection exists
///
/// **Time Complexity**: O(n + m) where n and m are the lengths of the lists
/// **Space Complexity**: O(1)
LinkedListNode<T>? getIntersectionNodeTwoPointer<T>(
  LinkedListNode<T>? headA,
  LinkedListNode<T>? headB,
) {
  if (headA == null || headB == null) return null;

  LinkedListNode<T>? pointerA = headA;
  LinkedListNode<T>? pointerB = headB;

  // When pointerA reaches end, move it to headB
  // When pointerB reaches end, move it to headA
  // This way they will meet at intersection point
  while (pointerA != pointerB) {
    pointerA = pointerA == null ? headB : pointerA.next;
    pointerB = pointerB == null ? headA : pointerB.next;
  }

  return pointerA;
}

/// Finds the intersection point using length and two-pointer technique
///
/// [headA] - The head of the first linked list
/// [headB] - The head of the second linked list
/// Returns the intersection node, or null if no intersection exists
///
/// **Time Complexity**: O(n + m) where n and m are the lengths of the lists
/// **Space Complexity**: O(1)
LinkedListNode<T>? getIntersectionNodeOptimized<T>(
  LinkedListNode<T>? headA,
  LinkedListNode<T>? headB,
) {
  if (headA == null || headB == null) return null;

  // Calculate lengths and check if lists end with same node
  int lenA = 0, lenB = 0;
  LinkedListNode<T>? endA = headA;
  LinkedListNode<T>? endB = headB;

  while (endA!.next != null) {
    lenA++;
    endA = endA.next;
  }
  while (endB!.next != null) {
    lenB++;
    endB = endB.next;
  }

  // If they don't end with same node, no intersection
  if (endA != endB) return null;

  // Move the longer list forward
  LinkedListNode<T>? currentA = headA;
  LinkedListNode<T>? currentB = headB;

  if (lenA > lenB) {
    for (int i = 0; i < lenA - lenB; i++) {
      currentA = currentA!.next;
    }
  } else if (lenB > lenA) {
    for (int i = 0; i < lenB - lenA; i++) {
      currentB = currentB!.next;
    }
  }

  // Find intersection
  while (currentA != currentB) {
    currentA = currentA!.next;
    currentB = currentB!.next;
  }

  return currentA;
}

/// Helper function to get the length of a linked list
///
/// [head] - The head of the linked list
/// Returns the length of the linked list
int getLength<T>(LinkedListNode<T>? head) {
  int length = 0;
  LinkedListNode<T>? current = head;

  while (current != null) {
    length++;
    current = current.next;
  }

  return length;
}

/// Finds the intersection point and returns additional information
///
/// [headA] - The head of the first linked list
/// [headB] - The head of the second linked list
/// Returns a map containing intersection node and lengths
///
/// **Time Complexity**: O(n + m) where n and m are the lengths of the lists
/// **Space Complexity**: O(1)
Map<String, dynamic> getIntersectionNodeWithInfo<T>(
  LinkedListNode<T>? headA,
  LinkedListNode<T>? headB,
) {
  if (headA == null || headB == null) {
    return {
      'intersectionNode': null,
      'lengthA': 0,
      'lengthB': 0,
      'hasIntersection': false,
    };
  }

  int lenA = getLength(headA);
  int lenB = getLength(headB);

  LinkedListNode<T>? currentA = headA;
  LinkedListNode<T>? currentB = headB;

  if (lenA > lenB) {
    for (int i = 0; i < lenA - lenB; i++) {
      currentA = currentA!.next;
    }
  } else if (lenB > lenA) {
    for (int i = 0; i < lenB - lenA; i++) {
      currentB = currentB!.next;
    }
  }

  LinkedListNode<T>? intersectionNode;
  while (currentA != null && currentB != null) {
    if (currentA == currentB) {
      intersectionNode = currentA;
      break;
    }
    currentA = currentA.next;
    currentB = currentB.next;
  }

  return {
    'intersectionNode': intersectionNode,
    'lengthA': lenA,
    'lengthB': lenB,
    'hasIntersection': intersectionNode != null,
  };
}
