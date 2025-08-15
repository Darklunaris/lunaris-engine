/// 🎈 Burst Balloons (DP)
///
/// Given an array of balloon values, each time you burst a balloon i you
/// earn nums[left] * nums[i] * nums[right] (where left/right are adjacent
/// remaining balloons). Find the maximum coins you can collect.
///
/// Contract:
// ignore: unintended_html_in_doc_comment
/// - Input: List<int> (may be empty). Negative numbers are allowed but
///   typical problem assumes non-negative.
/// - Output: int maximum coins.
///
/// Time Complexity: O(n^3)
/// Space Complexity: O(n^2)
///
/// Example:
/// ```dart
/// final nums = [3,1,5,8];
/// expect(maxCoins(nums), equals(167));
/// ```
library;

int maxCoins(List<int> nums) {
  if (nums.isEmpty) return 0;
  // pad with 1s at both ends
  final vals = <int>[1, ...nums, 1];
  final m = vals.length;
  final dp = List.generate(m, (_) => List<int>.filled(m, 0));

  for (var len = 2; len < m; len++) {
    for (var left = 0; left + len < m; left++) {
      final right = left + len;
      var best = 0;
      for (var k = left + 1; k < right; k++) {
        final coins =
            vals[left] * vals[k] * vals[right] + dp[left][k] + dp[k][right];
        if (coins > best) best = coins;
      }
      dp[left][right] = best;
    }
  }
  return dp[0][m - 1];
}
