/// 🍒 Cherry Pickup (DP - complex)
///
/// This implements the classical DP approach for the simplified Cherry Pickup
/// problem on a grid where two walkers move from (0,0) to (n-1,n-1) and can
/// pick cherries; cells with -1 are blocked. We return the maximum cherries.
// ignore: dangling_library_doc_comments
/// Contract:
// ignore: unintended_html_in_doc_comment
/// - Input: List<List<int>> grid (square grid n x n, values -1,0,1).
/// - Output: int maximum cherries collectable, 0 if none.
///
/// Time Complexity: O(n^3)
/// Space Complexity: O(n^2)
///
/// Note: To keep implementation concise we assume small n; for production
/// use further optimizations and thorough bounds checks.
library;

int cherryPickup(List<List<int>> grid) {
  final n = grid.length;
  if (n == 0) return 0;
  final dp = List.generate(n, (_) => List<int>.filled(n, -1));
  dp[0][0] = grid[0][0] == -1 ? -1 : grid[0][0];
  for (var t = 1; t <= 2 * (n - 1); t++) {
    final cur = List.generate(n, (_) => List<int>.filled(n, -1));
    for (var x1 = 0; x1 < n; x1++) {
      for (var x2 = 0; x2 < n; x2++) {
        final y1 = t - x1;
        final y2 = t - x2;
        if (y1 < 0 || y1 >= n || y2 < 0 || y2 >= n) continue;
        if (grid[x1][y1] == -1 || grid[x2][y2] == -1) continue;
        var best = -1;
        for (var dx1 = 0; dx1 <= 1; dx1++) {
          for (var dx2 = 0; dx2 <= 1; dx2++) {
            final px1 = x1 - dx1;
            final px2 = x2 - dx2;
            final py1 = y1 - (1 - dx1);
            final py2 = y2 - (1 - dx2);
            if (px1 < 0 || px2 < 0 || py1 < 0 || py2 < 0) continue;
            if (dp[px1][px2] >= 0 && dp[px1][px2] > best) best = dp[px1][px2];
          }
        }
        if (best < 0) continue;
        var add = grid[x1][y1];
        if (x1 != x2 || y1 != y2) add += grid[x2][y2];
        cur[x1][x2] = best + add;
      }
    }
    for (var i = 0; i < n; i++) {
      for (var j = 0; j < n; j++) {
        dp[i][j] = cur[i][j];
      }
    }
  }
  return dp[n - 1][n - 1] < 0 ? 0 : dp[n - 1][n - 1];
}
