/// Finds the length of the shortest path from (0,0) to (m-1,n-1) in a binary grid using BFS.
///
/// The grid contains 0 (blocked) and 1 (open) cells. Returns -1 if no path exists.
///
/// Time Complexity: O(m * n), where m and n are the grid dimensions.
/// Space Complexity: O(m * n)
///
/// Example:
/// ```dart
/// var grid = [
///   [1, 1, 0],
///   [1, 1, 0],
///   [0, 1, 1],
/// ];
/// print(shortestPathInGrid(grid)); // Outputs: 5
/// ```
int shortestPathInGrid(List<List<int>> grid) {
  final m = grid.length, n = grid.isNotEmpty ? grid[0].length : 0;
  if (m == 0 || n == 0 || grid[0][0] == 0 || grid[m - 1][n - 1] == 0) return -1;
  final directions = [
    [1, 0],
    [-1, 0],
    [0, 1],
    [0, -1],
  ];
  final queue = <List<int>>[
    [0, 0, 1],
  ]; // row, col, distance
  grid[0][0] = 0;
  while (queue.isNotEmpty) {
    final curr = queue.removeAt(0);
    final r = curr[0], c = curr[1], dist = curr[2];
    if (r == m - 1 && c == n - 1) return dist;
    for (final dir in directions) {
      final nr = r + dir[0], nc = c + dir[1];
      if (nr >= 0 && nr < m && nc >= 0 && nc < n && grid[nr][nc] == 1) {
        queue.add([nr, nc, dist + 1]);
        grid[nr][nc] = 0;
      }
    }
  }
  return -1;
}
