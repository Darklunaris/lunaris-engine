/// 🔗 Merge Sorted Linked Lists Algorithms
///
/// Efficient algorithms for merging two sorted linked lists into a single
/// sorted linked list. Includes both iterative and recursive approaches.
///
/// **Time Complexity**: O(n + m) where n and m are the lengths of the lists
/// **Space Complexity**: O(1) for iterative, O(n + m) for recursive
library;

import 'linked_list_node.dart';

/// Merges two sorted linked lists iteratively
///
/// [list1] - The head of the first sorted linked list
/// [list2] - The head of the second sorted linked list
/// Returns the head of the merged sorted linked list
///
/// **Time Complexity**: O(n + m) where n and m are the lengths of the lists
/// **Space Complexity**: O(1)
LinkedListNode<T>? mergeSortedLists<T extends Comparable>(
  LinkedListNode<T>? list1,
  LinkedListNode<T>? list2,
) {
  // Handle edge cases
  if (list1 == null) return list2;
  if (list2 == null) return list1;

  // Create a dummy node to simplify the merge process
  LinkedListNode<T> dummy = LinkedListNode<T>(list1.value);
  LinkedListNode<T> current = dummy;

  // Merge the lists
  while (list1 != null && list2 != null) {
    if (list1.value.compareTo(list2.value) <= 0) {
      current.next = list1;
      list1 = list1.next;
    } else {
      current.next = list2;
      list2 = list2.next;
    }
    current = current.next!;
  }

  // Attach remaining nodes
  if (list1 != null) {
    current.next = list1;
  }
  if (list2 != null) {
    current.next = list2;
  }

  return dummy.next;
}

/// Merges two sorted linked lists recursively
///
/// [list1] - The head of the first sorted linked list
/// [list2] - The head of the second sorted linked list
/// Returns the head of the merged sorted linked list
///
/// **Time Complexity**: O(n + m) where n and m are the lengths of the lists
/// **Space Complexity**: O(n + m) due to recursion stack
LinkedListNode<T>? mergeSortedListsRecursive<T extends Comparable>(
  LinkedListNode<T>? list1,
  LinkedListNode<T>? list2,
) {
  // Base cases
  if (list1 == null) return list2;
  if (list2 == null) return list1;

  LinkedListNode<T>? result;

  // Choose the smaller value and recurse
  if (list1.value.compareTo(list2.value) <= 0) {
    result = list1;
    result.next = mergeSortedListsRecursive(list1.next, list2);
  } else {
    result = list2;
    result.next = mergeSortedListsRecursive(list1, list2.next);
  }

  return result;
}

/// Merges K sorted linked lists efficiently
///
/// [lists] - List of heads of sorted linked lists
/// Returns the head of the merged sorted linked list
///
/// **Time Complexity**: O(N log K) where N is total nodes and K is number of lists
/// **Space Complexity**: O(K) for the priority queue
LinkedListNode<T>? mergeKSortedLists<T extends Comparable>(
  List<LinkedListNode<T>?> lists,
) {
  if (lists.isEmpty) return null;
  if (lists.length == 1) return lists[0];

  // Use divide and conquer approach
  return _mergeKListsHelper(lists, 0, lists.length - 1);
}

/// Helper function for merging K sorted lists using divide and conquer
///
/// [lists] - List of heads of sorted linked lists
/// [start] - Start index
/// [end] - End index
/// Returns the head of the merged sorted linked list
LinkedListNode<T>? _mergeKListsHelper<T extends Comparable>(
  List<LinkedListNode<T>?> lists,
  int start,
  int end,
) {
  if (start == end) return lists[start];
  if (start > end) return null;

  int mid = (start + end) ~/ 2;
  LinkedListNode<T>? left = _mergeKListsHelper(lists, start, mid);
  LinkedListNode<T>? right = _mergeKListsHelper(lists, mid + 1, end);

  return mergeSortedLists(left, right);
}

/// Merges two sorted linked lists in-place (modifies the original lists)
///
/// [list1] - The head of the first sorted linked list
/// [list2] - The head of the second sorted linked list
/// Returns the head of the merged sorted linked list
///
/// **Time Complexity**: O(n + m) where n and m are the lengths of the lists
/// **Space Complexity**: O(1)
LinkedListNode<T>? mergeSortedListsInPlace<T extends Comparable>(
  LinkedListNode<T>? list1,
  LinkedListNode<T>? list2,
) {
  if (list1 == null) return list2;
  if (list2 == null) return list1;

  // Ensure list1 always points to the smaller head
  if (list1.value.compareTo(list2.value) > 0) {
    LinkedListNode<T>? temp = list1;
    list1 = list2;
    list2 = temp;
  }

  LinkedListNode<T> result = list1;

  while (list1!.next != null && list2 != null) {
    if (list1.next!.value.compareTo(list2.value) <= 0) {
      list1 = list1.next;
    } else {
      LinkedListNode<T>? temp = list1.next;
      list1.next = list2;
      list2 = list2.next;
      list1.next!.next = temp;
      list1 = list1.next!;
    }
  }

  // Attach remaining nodes from list2
  if (list2 != null) {
    list1.next = list2;
  }

  return result;
}

/// Merges two sorted linked lists with custom comparator
///
/// [list1] - The head of the first sorted linked list
/// [list2] - The head of the second sorted linked list
/// [comparator] - Custom comparison function
/// Returns the head of the merged sorted linked list
///
/// **Time Complexity**: O(n + m) where n and m are the lengths of the lists
/// **Space Complexity**: O(1)
LinkedListNode<T>? mergeSortedListsWithComparator<T>(
  LinkedListNode<T>? list1,
  LinkedListNode<T>? list2,
  int Function(T, T) comparator,
) {
  if (list1 == null) return list2;
  if (list2 == null) return list1;

  LinkedListNode<T> dummy = LinkedListNode<T>(list1.value);
  LinkedListNode<T> current = dummy;

  while (list1 != null && list2 != null) {
    if (comparator(list1.value, list2.value) <= 0) {
      current.next = list1;
      list1 = list1.next;
    } else {
      current.next = list2;
      list2 = list2.next;
    }
    current = current.next!;
  }

  if (list1 != null) current.next = list1;
  if (list2 != null) current.next = list2;

  return dummy.next;
}
