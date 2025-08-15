/// Finds all pairs of numbers in a list that sum to a target value using a map.
///
/// This function returns a list of all pairs [a, b] from [nums] such that a + b == target.
/// Each pair is returned only once, regardless of order.
///
/// Time Complexity: O(n), where n is the length of the list.
///
/// Example:
/// ```dart
/// var result = allPairsWithSum([1, 2, 3, 2, 4], 4);
/// print(result); // Outputs: [[2, 2], [1, 3]]
/// ```
List<List<int>> allPairsWithSum(List<int> nums, int target) {
  final seen = <int, int>{};
  final result = <List<int>>[];
  for (final num in nums) {
    final complement = target - num;
    if (seen.containsKey(complement)) {
      result.add([complement, num]);
    }
    seen[num] = 1;
  }
  return result;
}
