/// 🔗 Generic Linked List Node
///
/// A node in a singly linked list containing a value and a reference to the next node.
/// This is the fundamental building block for all linked list operations.
///
/// **Time Complexity**: O(1) for all operations
/// **Space Complexity**: O(1) per node
library;

class LinkedListNode<T> {
  /// The value stored in this node
  T value;

  /// Reference to the next node in the list
  LinkedListNode<T>? next;

  /// Creates a new linked list node with the given value
  ///
  /// [value] - The data to store in this node
  LinkedListNode(this.value);

  /// Returns a string representation of this node
  @override
  String toString() => 'LinkedListNode($value)';

  /// Creates a linked list from a list of values
  ///
  /// [values] - List of values to convert to a linked list
  /// Returns the head of the created linked list
  static LinkedListNode<T>? fromList<T>(List<T> values) {
    if (values.isEmpty) return null;

    LinkedListNode<T> head = LinkedListNode<T>(values[0]);
    LinkedListNode<T> current = head;

    for (int i = 1; i < values.length; i++) {
      current.next = LinkedListNode<T>(values[i]);
      current = current.next!;
    }

    return head;
  }

  /// Converts a linked list to a list of values
  ///
  /// [head] - The head of the linked list
  /// Returns a list containing all values in the linked list
  static List<T> toList<T>(LinkedListNode<T>? head) {
    List<T> result = [];
    LinkedListNode<T>? current = head;

    while (current != null) {
      result.add(current.value);
      current = current.next;
    }

    return result;
  }

  /// Gets the length of a linked list
  ///
  /// [head] - The head of the linked list
  /// Returns the number of nodes in the list
  static int length<T>(LinkedListNode<T>? head) {
    int count = 0;
    LinkedListNode<T>? current = head;

    while (current != null) {
      count++;
      current = current.next;
    }

    return count;
  }
}
