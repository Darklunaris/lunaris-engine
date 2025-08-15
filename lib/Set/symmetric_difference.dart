/// Returns the symmetric difference of two sets: elements in either set, but not both.
///
/// This function computes the symmetric difference between sets [a] and [b],
/// returning a new set containing elements that are in either [a] or [b], but not in both.
///
/// Time Complexity: O(n + m), where n and m are the sizes of the sets.
/// Space Complexity: O(n + m)
///
/// Example:
/// ```dart
/// Set<int> result = symmetricDifference({1, 2, 3}, {3, 4, 5});
/// print(result); // Outputs: {1, 2, 4, 5}
/// ```
Set<T> symmetricDifference<T>(Set<T> a, Set<T> b) {
  return (a.difference(b)).union(b.difference(a));
}
