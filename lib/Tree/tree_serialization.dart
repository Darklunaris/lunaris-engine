/// 🌳 Tree Serialization and Deserialization
///
/// Converts binary trees to and from string representations.
/// Uses a level-order traversal with null markers for missing children.
///
/// Time complexity: O(n) where n is the number of nodes
/// Space complexity: O(n) for storing the serialized string
///
/// Example:
/// ```dart
/// final root = BinaryTreeNode<int>(10);
/// root.left = BinaryTreeNode<int>(5);
/// root.right = BinaryTreeNode<int>(15);
/// final serialized = serializeTree(root);
/// // serialized: "10,5,15,null,null,null,null"
/// final deserialized = deserializeTree(serialized);
/// // deserialized has the same structure as root
/// ```
library;

import 'binary_tree_node.dart';

/// Serializes a binary tree to a string representation
///
/// Uses level-order traversal with "null" for missing nodes.
/// The format is: "value1,value2,null,value3,..."
String serializeTree<T>(BinaryTreeNode<T>? root) {
  if (root == null) return "";

  final List<String> result = [];
  final List<BinaryTreeNode<T>?> queue = [root];

  while (queue.isNotEmpty) {
    final BinaryTreeNode<T>? node = queue.removeAt(0);

    if (node == null) {
      result.add("null");
    } else {
      result.add(node.value.toString());
      queue.add(node.left);
      queue.add(node.right);
    }
  }

  // Remove trailing nulls
  while (result.isNotEmpty && result.last == "null") {
    result.removeLast();
  }

  return result.join(",");
}

/// Deserializes a string back to a binary tree
///
/// Reconstructs the tree from the serialized string format.
BinaryTreeNode<T>? deserializeTree<T>(String data) {
  if (data.isEmpty) return null;

  final List<String> values = data.split(",");
  if (values.isEmpty || values[0] == "null") return null;

  // Helper function to parse value based on type
  T parseValue(String value) {
    if (T == int) {
      return int.parse(value) as T;
    } else if (T == double) {
      return double.parse(value) as T;
    } else {
      // For strings, we need to handle the case where the value might contain commas
      // This is a simplified approach - in practice, you might want to use a more robust serialization format
      return value as T;
    }
  }

  final BinaryTreeNode<T> root = BinaryTreeNode<T>(parseValue(values[0]));
  final List<BinaryTreeNode<T>?> queue = [root];
  int index = 1;

  while (queue.isNotEmpty && index < values.length) {
    final BinaryTreeNode<T>? node = queue.removeAt(0);

    if (node != null) {
      // Left child
      if (index < values.length && values[index] != "null") {
        node.left = BinaryTreeNode<T>(parseValue(values[index]));
        queue.add(node.left);
      }
      index++;

      // Right child
      if (index < values.length && values[index] != "null") {
        node.right = BinaryTreeNode<T>(parseValue(values[index]));
        queue.add(node.right);
      }
      index++;
    }
  }

  return root;
}
