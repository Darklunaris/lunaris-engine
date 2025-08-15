/// Maps each element in a list to a list of indices where it appears.
///
/// This function returns a map from each unique element in [list] to a list of all indices where it occurs.
///
/// Time Complexity: O(n), where n is the length of the list.
///
/// Example:
/// ```dart
/// var result = indexMapping(['a', 'b', 'a', 'c']);
/// print(result); // Outputs: {'a': [0, 2], 'b': [1], 'c': [3]}
/// ```
Map<T, List<int>> indexMapping<T>(List<T> list) {
  final map = <T, List<int>>{};
  for (var i = 0; i < list.length; i++) {
    map.putIfAbsent(list[i], () => []).add(i);
  }
  return map;
}
