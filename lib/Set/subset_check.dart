/// Checks if set [a] is a subset of set [b].
///
/// Returns true if all elements of [a] are contained in [b].
///
/// Time Complexity: O(n), where n is the size of [a].
/// Space Complexity: O(1)
///
/// Example:
/// ```dart
/// bool result = isSubset({1, 2}, {1, 2, 3});
/// print(result); // Outputs: true
/// ```
bool isSubset<T>(Set<T> a, Set<T> b) => b.containsAll(a);
