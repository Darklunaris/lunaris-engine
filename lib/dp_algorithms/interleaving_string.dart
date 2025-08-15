/// 🔁 Interleaving String
///
/// Checks whether `s3` is formed by interleaving `s1` and `s2` while preserving
/// the relative order of characters. Uses DP with O(n*m) time and O(m) space.
///
/// Contract:
/// - Inputs: strings s1, s2, s3.
/// - Output: boolean indicating interleaving status.
/// - Error modes: none.
///
/// Example:
/// ```dart
/// isInterleave('aab', 'axy', 'aaxaby'); // true
/// ```
bool isInterleave(String s1, String s2, String s3) {
  final n = s1.length, m = s2.length;
  if (n + m != s3.length) return false;
  final dp = List<bool>.filled(m + 1, false);
  dp[0] = true;
  for (int j = 1; j <= m; j++) {
    dp[j] = dp[j - 1] && s2[j - 1] == s3[j - 1];
  }
  for (int i = 1; i <= n; i++) {
    dp[0] = dp[0] && s1[i - 1] == s3[i - 1];
    for (int j = 1; j <= m; j++) {
      dp[j] =
          (dp[j] && s1[i - 1] == s3[i + j - 1]) ||
          (dp[j - 1] && s2[j - 1] == s3[i + j - 1]);
    }
  }
  return dp[m];
}
