/// 🚧 Unique Paths with Obstacles
///
/// Computes the number of unique paths from top-left to bottom-right in a
/// grid while avoiding obstacles (represented by 1). Moves allowed: right, down.
/// Uses dynamic programming with O(m*n) time and O(n) space.
///
/// Contract:
/// - Input: 2D list `obstacleGrid` with 0 (free) and 1 (obstacle).
/// - Output: non-negative integer count of unique paths.
/// - Error modes: throws [ArgumentError] for empty grid or invalid values.
///
/// Example:
/// ```dart
/// uniquePathsWithObstacles([[0,0,0],[0,1,0],[0,0,0]]); // 2
/// ```
int uniquePathsWithObstacles(List<List<int>> obstacleGrid) {
  if (obstacleGrid.isEmpty || obstacleGrid[0].isEmpty) {
    throw ArgumentError('obstacleGrid must be non-empty');
  }
  final m = obstacleGrid.length;
  final n = obstacleGrid[0].length;
  final dp = List<int>.filled(n, 0);
  dp[0] = obstacleGrid[0][0] == 0 ? 1 : 0;
  for (int j = 1; j < n; j++) {
    dp[j] = (obstacleGrid[0][j] == 0) ? dp[j - 1] : 0;
  }
  for (int i = 1; i < m; i++) {
    dp[0] = obstacleGrid[i][0] == 0 ? dp[0] : 0;
    for (int j = 1; j < n; j++) {
      dp[j] = obstacleGrid[i][j] == 0 ? dp[j] + dp[j - 1] : 0;
    }
  }
  return dp[n - 1];
}
