/// 📈 Maximum Sum Increasing Subsequence (DP)
///
/// Given an array, find the maximum sum of an increasing subsequence.
///
/// Contract:
/// - Input: List<int>
/// - Output: int maximum sum (0 if array empty).
///
/// Time Complexity: O(n^2)
/// Space Complexity: O(n)
///
/// Example:
/// ```dart
/// expect(maxSumIncreasingSubsequence([1,101,2,3,100,4,5]), equals(106));
/// ```
int maxSumIncreasingSubsequence(List<int> arr) {
  final n = arr.length;
  if (n == 0) return 0;
  final dp = List<int>.from(arr);
  var best = dp[0];
  for (var i = 1; i < n; i++) {
    for (var j = 0; j < i; j++) {
      if (arr[j] < arr[i] && dp[j] + arr[i] > dp[i]) dp[i] = dp[j] + arr[i];
    }
    if (dp[i] > best) best = dp[i];
  }
  return best;
}
