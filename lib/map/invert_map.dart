/// Inverts a map by swapping keys and values. If duplicate values exist, later keys overwrite earlier ones.
///
/// This function takes a map [map] and returns a new map with keys and values swapped.
/// If multiple keys have the same value, the last key encountered will be used in the result.
///
/// Time Complexity: O(n), where n is the number of entries in the map.
///
/// Example:
/// ```dart
/// var map = {'a': 1, 'b': 2, 'c': 1};
/// print(invertMap(map)); // Outputs: {1: 'c', 2: 'b'}
/// ```
Map<V, K> invertMap<K, V>(Map<K, V> map) {
  final result = <V, K>{};
  map.forEach((k, v) => result[v] = k);
  return result;
}
