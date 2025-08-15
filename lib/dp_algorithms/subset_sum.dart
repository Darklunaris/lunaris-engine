/// 🔢 Subset Sum (Dynamic Programming, Generic)
///
/// Returns true if there exists a subset of [nums] that sums to [target].
/// Works for any numeric type [T extends num].
///
/// Time Complexity: O(n * target)
/// Space Complexity: O(target)
///
/// Example:
/// ```dart
/// subsetSum([1, 2, 3, 7], 6); // true (1+2+3)
/// subsetSum([2, 4, 6], 5); // false
/// ```
bool subsetSum<T extends num>(List<T> nums, T target) {
  if (target is! int) {
    throw ArgumentError('Generic subsetSum only supports integer targets.');
  }
  final intTarget = target as int;
  final dp = List<bool>.filled(intTarget + 1, false);
  dp[0] = true;
  for (final num in nums) {
    if (num is! int) {
      throw ArgumentError('All elements must be int for generic subsetSum.');
    }
    for (int t = intTarget; t >= num; t--) {
      if (dp[t - num]) dp[t] = true;
    }
  }
  return dp[intTarget];
}
