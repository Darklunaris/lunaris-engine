/// Counts the number of unique pairs with a specific difference in a list.
///
/// This function returns the number of unique pairs [a, b] in [nums] such that b - a == diff.
///
/// Time Complexity: O(n), where n is the number of elements in the list.
///
/// Example:
/// ```dart
/// var result = countPairsWithDiff([1, 5, 3, 4, 2], 2);
/// print(result); // Outputs: 3 ([1,3], [3,5], [2,4])
/// ```
int countPairsWithDiff(List<int> nums, int diff) {
  final set = nums.toSet();
  var count = 0;
  for (final num in set) {
    if (set.contains(num + diff)) count++;
  }
  return count;
}
