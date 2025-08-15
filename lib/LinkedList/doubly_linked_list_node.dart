/// 🔗🔗 Generic Doubly Linked List Node
///
/// A node in a doubly linked list containing a value and references to both
/// the next and previous nodes. This enables bidirectional traversal.
///
/// **Time Complexity**: O(1) for all operations
/// **Space Complexity**: O(1) per node
library;

class DoublyLinkedListNode<T> {
  /// The value stored in this node
  T value;

  /// Reference to the next node in the list
  DoublyLinkedListNode<T>? next;

  /// Reference to the previous node in the list
  DoublyLinkedListNode<T>? prev;

  /// Creates a new doubly linked list node with the given value
  ///
  /// [value] - The data to store in this node
  DoublyLinkedListNode(this.value);

  /// Returns a string representation of this node
  @override
  String toString() => 'DoublyLinkedListNode($value)';

  /// Creates a doubly linked list from a list of values
  ///
  /// [values] - List of values to convert to a doubly linked list
  /// Returns the head of the created doubly linked list
  static DoublyLinkedListNode<T>? fromList<T>(List<T> values) {
    if (values.isEmpty) return null;

    DoublyLinkedListNode<T> head = DoublyLinkedListNode<T>(values[0]);
    DoublyLinkedListNode<T> current = head;

    for (int i = 1; i < values.length; i++) {
      DoublyLinkedListNode<T> newNode = DoublyLinkedListNode<T>(values[i]);
      current.next = newNode;
      newNode.prev = current;
      current = newNode;
    }

    return head;
  }

  /// Converts a doubly linked list to a list of values
  ///
  /// [head] - The head of the doubly linked list
  /// Returns a list containing all values in the doubly linked list
  static List<T> toList<T>(DoublyLinkedListNode<T>? head) {
    List<T> result = [];
    DoublyLinkedListNode<T>? current = head;

    while (current != null) {
      result.add(current.value);
      current = current.next;
    }

    return result;
  }

  /// Gets the length of a doubly linked list
  ///
  /// [head] - The head of the doubly linked list
  /// Returns the number of nodes in the list
  static int length<T>(DoublyLinkedListNode<T>? head) {
    int count = 0;
    DoublyLinkedListNode<T>? current = head;

    while (current != null) {
      count++;
      current = current.next;
    }

    return count;
  }
}
