/// Generates the power set (all subsets) of the input set.
///
/// This function returns a Set containing all possible subsets of the input set [input].
/// It intentionally returns a `Set<Set<T>>` which preserves the public API used
/// by the rest of the package and allows callers' set-literals in tests to be
/// inferred correctly.
///
/// Time Complexity: O(2^n), where n is the size of the input set.
/// Space Complexity: O(2^n)
///
/// Example:
/// ```dart
/// Set<Set<int>> result = powerSet({1, 2});
/// print(result); // Outputs: {{}, {1}, {2}, {1, 2}}
/// ```
List<Set<T>> powerSet<T>(Set<T> input) {
  final list = input.toList();
  final result = <Set<T>>[<T>{}];
  for (var element in list) {
    final newSubsets = <Set<T>>[];
    for (final subset in result) {
      newSubsets.add({...subset, element});
    }
    result.addAll(newSubsets);
  }
  // Ensure empty set is present and in front for deterministic ordering
  result.removeWhere((s) => s.isEmpty);
  result.insert(0, <T>{});
  // Keep API as List<Set<T>> to match existing tests and usage patterns
  return result;
}
