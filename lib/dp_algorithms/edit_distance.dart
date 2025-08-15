/// ✏️ Edit Distance (Levenshtein Distance) - Dynamic Programming
///
/// Returns the minimum number of operations (insert, delete, replace) to convert [a] to [b].
///
/// Time Complexity: O(m * n)
/// Space Complexity: O(m * n)
int editDistance(String a, String b) {
  final m = a.length, n = b.length;
  final dp = List.generate(m + 1, (_) => List<int>.filled(n + 1, 0));
  for (int i = 0; i <= m; i++) {
    dp[i][0] = i;
  }
  for (int j = 0; j <= n; j++) {
    dp[0][j] = j;
  }
  for (int i = 1; i <= m; i++) {
    for (int j = 1; j <= n; j++) {
      if (a[i - 1] == b[j - 1]) {
        dp[i][j] = dp[i - 1][j - 1];
      } else {
        dp[i][j] =
            1 +
            [
              dp[i - 1][j],
              dp[i][j - 1],
              dp[i - 1][j - 1],
            ].reduce((a, b) => a < b ? a : b);
      }
    }
  }
  return dp[m][n];
}
