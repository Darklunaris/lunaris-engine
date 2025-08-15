/// 🧮 Matrix Path Sum (Minimum Path Sum in Grid)
///
/// Returns the minimum path sum from top-left to bottom-right in a grid.
/// Only right and down moves are allowed.
///
/// Time Complexity: O(m * n)
/// Space Complexity: O(m * n)
int minPathSum(List<List<int>> grid) {
  if (grid.isEmpty || grid[0].isEmpty) {
    throw ArgumentError('grid must be non-empty');
  }
  final m = grid.length, n = grid[0].length;
  final dp = List.generate(m, (i) => List<int>.filled(n, 0));
  dp[0][0] = grid[0][0];
  for (int i = 1; i < m; i++) {
    dp[i][0] = dp[i - 1][0] + grid[i][0];
  }
  for (int j = 1; j < n; j++) {
    dp[0][j] = dp[0][j - 1] + grid[0][j];
  }
  for (int i = 1; i < m; i++) {
    for (int j = 1; j < n; j++) {
      dp[i][j] =
          grid[i][j] +
          (dp[i - 1][j] < dp[i][j - 1] ? dp[i - 1][j] : dp[i][j - 1]);
    }
  }
  return dp[m - 1][n - 1];
}
