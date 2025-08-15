/// 🏝️ Island Count using Depth-First Search (DFS)
///
/// Returns the number of islands (connected groups of '1's) in the given 2D [grid] using DFS.
/// An island is a group of horizontally or vertically connected '1's (land) surrounded by '0's (water).
/// The function modifies the input grid by marking visited land cells as '0'.
///
/// Usage:
/// ```dart
/// var grid = [
///   ['1', '1', '0', '0', '0'],
///   ['1', '1', '0', '0', '0'],
///   ['0', '0', '1', '0', '0'],
///   ['0', '0', '0', '1', '1'],
/// ];
/// var count = numIslandsDFS(grid); // Returns 3
/// ```
///
/// - Time Complexity: O(m * n)
/// - Space Complexity: O(m * n) (due to recursion stack)
/// - Modifies the input grid in-place
int numIslandsDFS(List<List<String>> grid) {
  final m = grid.length, n = grid.isNotEmpty ? grid[0].length : 0;
  int count = 0;
  void dfs(int r, int c) {
    if (r < 0 || r >= m || c < 0 || c >= n || grid[r][c] != '1') return;
    grid[r][c] = '0';
    dfs(r + 1, c);
    dfs(r - 1, c);
    dfs(r, c + 1);
    dfs(r, c - 1);
  }

  for (int i = 0; i < m; i++) {
    for (int j = 0; j < n; j++) {
      if (grid[i][j] == '1') {
        count++;
        dfs(i, j);
      }
    }
  }
  return count;
}
