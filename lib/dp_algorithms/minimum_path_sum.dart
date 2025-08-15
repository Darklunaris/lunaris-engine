/// 📉 Minimum Path Sum in Grid
///
/// Computes the minimum sum of values along a path from the top-left to the
/// bottom-right of a 2D grid moving only right or down. Uses bottom-up dynamic
/// programming with O(m*n) time and O(n) auxiliary space (row optimization).
///
/// Contract:
/// - Input: non-empty 2D list of non-negative integers `grid`.
/// - Output: integer representing minimum path sum.
/// - Error modes: throws [ArgumentError] if grid is empty or rows are inconsistent.
///
/// Example:
/// ```dart
/// final grid = [[1,3,1],[1,5,1],[4,2,1]];
/// minPathSum(grid); // 7
/// ```
int minimumPathSum(List<List<int>> grid) {
  if (grid.isEmpty || grid[0].isEmpty) {
    throw ArgumentError('grid must be non-empty');
  }
  // Validate rows are rectangular
  final nCols = grid[0].length;
  for (var row in grid) {
    if (row.length != nCols) throw ArgumentError('grid must be rectangular');
  }
  final m = grid.length;
  final n = grid[0].length;
  final dp = List<int>.filled(n, 0);
  dp[0] = grid[0][0];
  for (int j = 1; j < n; j++) {
    dp[j] = dp[j - 1] + grid[0][j];
  }
  for (int i = 1; i < m; i++) {
    dp[0] = dp[0] + grid[i][0];
    for (int j = 1; j < n; j++) {
      dp[j] = grid[i][j] + (dp[j] < dp[j - 1] ? dp[j] : dp[j - 1]);
    }
  }
  return dp[n - 1];
}

// NOTE: `minPathSum` is provided by `matrix_path_sum.dart` to avoid symbol collision.
// Do not export another symbol named `minPathSum` from this file.
