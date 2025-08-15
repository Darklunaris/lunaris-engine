/// ⚖️ Partition Equal Subset Sum (Dynamic Programming)
///
/// Returns true if the array can be partitioned into two subsets with equal sum.
///
/// Time Complexity: O(n * sum/2)
/// Space Complexity: O(sum/2)
bool canPartition(List<int> nums) {
  final total = nums.fold(0, (a, b) => a + b);
  if (total % 2 != 0) return false;
  final target = total ~/ 2;
  final dp = List<bool>.filled(target + 1, false);
  dp[0] = true;
  for (final num in nums) {
    for (int t = target; t >= num; t--) {
      if (dp[t - num]) dp[t] = true;
    }
  }
  return dp[target];
}
