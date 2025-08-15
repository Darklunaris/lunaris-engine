/// Checks if two sets [a] and [b] are disjoint (no elements in common).
///
/// Returns true if [a] and [b] have no elements in common, false otherwise.
///
/// Time Complexity: O(n), where n is the size of the smaller set.
/// Space Complexity: O(1)
///
/// Example:
/// ```dart
/// bool result = isDisjoint({1, 2}, {3, 4});
/// print(result); // Outputs: true
/// ```
bool isDisjoint<T>(Set<T> a, Set<T> b) => a.intersection(b).isEmpty;
