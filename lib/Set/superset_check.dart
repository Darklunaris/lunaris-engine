/// Checks if set [a] is a superset of set [b].
///
/// Returns true if all elements of [b] are contained in [a].
///
/// Time Complexity: O(n), where n is the size of [b].
/// Space Complexity: O(1)
///
/// Example:
/// ```dart
/// bool result = isSuperset({1, 2, 3}, {2, 3});
/// print(result); // Outputs: true
/// ```
bool isSuperset<T>(Set<T> a, Set<T> b) => a.containsAll(b);
