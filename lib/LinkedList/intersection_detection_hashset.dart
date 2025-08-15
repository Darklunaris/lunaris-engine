/// 🔗 Intersection Detection using HashSet — O(m + n) detection preserving nodes
///
/// Detects and returns the first common node shared between two singly linked lists
/// by scanning one list into a `HashSet` and then checking nodes of the other list.
/// This returns the actual intersecting node reference (not just equal value),
/// making it suitable for pointer-based list sharing scenarios.
///
/// Contract:
/// - Inputs: `headA`, `headB` (nullable heads of two lists).
/// - Output: the intersecting `LinkedListNode<T>` reference if present; otherwise `null`.
/// - Error modes: none; uses Dart object identity for node comparison.
///
/// Complexity: Time O(m + n), Space O(m) where m is length of `headA`.
///
/// Example:
/// ```dart
/// final a = LinkedListNode.fromList([1,2,3]);
/// final b = LinkedListNode.fromList([4,5]);
/// b.next!.next = a.next; // intersection at node with value 2
/// final intersection = intersectionDetectionHashSet(a, b);
/// // intersection.value == 2
/// ```
library;

import 'linked_list_node.dart';
import 'dart:collection';

LinkedListNode<T>? intersectionDetectionHashSet<T>(
  LinkedListNode<T>? headA,
  LinkedListNode<T>? headB,
) {
  final visited = HashSet<LinkedListNode<T>>();
  var currA = headA;
  while (currA != null) {
    visited.add(currA);
    currA = currA.next;
  }
  var currB = headB;
  while (currB != null) {
    if (visited.contains(currB)) return currB;
    currB = currB.next;
  }
  return null;
}
