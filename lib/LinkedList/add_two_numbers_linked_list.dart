/// ➕ Add Two Numbers (Linked List Representation) — safe big-integer style add
///
/// Adds two non-negative integers represented by singly linked lists where digits
/// are stored in reverse order (least significant digit first). The function
/// returns a newly allocated linked list representing the sum in the same format.
///
/// Contract:
/// - Inputs: `l1`, `l2` (nullable heads of lists representing non-negative integers).
/// - Output: head of new linked list representing the sum (nullable when both inputs are `null`).
/// - Error modes: negative digits or non-integer values are not validated; caller must ensure valid input.
///
/// Complexity: Time O(max(m, n)), Space O(max(m, n)).
///
/// Example:
/// ```dart
/// final l1 = LinkedListNode.fromList([2,4,3]); // 342
/// final l2 = LinkedListNode.fromList([5,6,4]); // 465
/// final sum = addTwoNumbersLinkedList(l1, l2);
/// // sum: [7,0,8] (807)
/// ```
library;

import 'linked_list_node.dart';

LinkedListNode<int>? addTwoNumbersLinkedList(
  LinkedListNode<int>? l1,
  LinkedListNode<int>? l2,
) {
  final dummy = LinkedListNode<int>(0);
  var curr = dummy;
  int carry = 0;
  while (l1 != null || l2 != null || carry != 0) {
    final sum = (l1?.value ?? 0) + (l2?.value ?? 0) + carry;
    carry = sum ~/ 10;
    curr.next = LinkedListNode<int>(sum % 10);
    curr = curr.next!;
    l1 = l1?.next;
    l2 = l2?.next;
  }
  return dummy.next;
}
