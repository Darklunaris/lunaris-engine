/// Merges two maps with custom conflict resolution for duplicate keys.
///
/// This function combines maps [a] and [b] into a new map. If a key exists in both maps,
/// the [conflict] function is called with the key and both values to determine the result.
///
/// Time Complexity: O(n + m), where n and m are the sizes of the two maps.
///
/// Example:
/// ```dart
/// var a = {'x': 1, 'y': 2};
/// var b = {'y': 3, 'z': 4};
/// var merged = mergeMaps(a, b, (k, v1, v2) => v1 + v2);
/// print(merged); // Outputs: {x: 1, y: 5, z: 4}
/// ```
Map<K, V> mergeMaps<K, V>(
  Map<K, V> a,
  Map<K, V> b,
  V Function(K, V, V) conflict,
) {
  final result = Map<K, V>.from(a);
  b.forEach((k, v) {
    if (result.containsKey(k)) {
      result[k] = conflict(k, result[k] as V, v);
    } else {
      result[k] = v;
    }
  });
  return result;
}
