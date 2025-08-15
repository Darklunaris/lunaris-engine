/// 🔢 Convert Binary Number in Linked List to Integer — MSB-first parsing
///
/// Parses a binary number represented as a singly linked list where the most
/// significant bit appears first and returns its integer value. The implementation
/// uses left-shift accumulation to avoid string conversion and minimize allocations.
///
/// Contract:
/// - Inputs: `head` (nullable linked list of `int` values 0 or 1).
/// - Output: integer value represented by the binary digits. Returns 0 for `null`.
/// - Error modes: values other than 0/1 are not validated and may produce incorrect results.
///
/// Complexity: Time O(n), Space O(1).
///
/// Example:
/// ```dart
/// final head = LinkedListNode.fromList([1,0,1]);
/// final value = convertBinaryLinkedListToInt(head);
/// // value: 5
/// ```
library;

import 'linked_list_node.dart';

int convertBinaryLinkedListToInt(LinkedListNode<int>? head) {
  int result = 0;
  var current = head;
  while (current != null) {
    result = (result << 1) | current.value;
    current = current.next;
  }
  return result;
}
