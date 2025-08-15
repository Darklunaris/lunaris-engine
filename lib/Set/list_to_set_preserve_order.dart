/// Converts a list to a set (as a list) while preserving the order of first occurrence.
///
/// This function returns a list of unique elements from [list], preserving their first appearance order.
///
/// Time Complexity: O(n), where n is the length of the list.
/// Space Complexity: O(n)
///
/// Example:
/// ```dart
/// List<int> result = listToSetPreserveOrder([3, 1, 2, 3, 2]);
/// print(result); // Outputs: [3, 1, 2]
/// ```
List<T> listToSetPreserveOrder<T>(List<T> list) {
  final seen = <T>{};
  final result = <T>[];
  for (final element in list) {
    if (seen.add(element)) {
      result.add(element);
    }
  }
  return result;
}
