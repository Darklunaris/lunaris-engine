/// Counts the number of islands (connected groups of '1's) in a 2D grid using BFS.
///
/// This function returns the number of islands in the grid, where an island is a group of adjacent '1's (horizontally or vertically).
///
/// Time Complexity: O(m * n), where m and n are the grid dimensions.
/// Space Complexity: O(m * n)
///
/// Example:
/// ```dart
/// var grid = [
///   ["1", "1", "0", "0"],
///   ["1", "0", "0", "1"],
///   ["0", "0", "1", "1"],
///   ["0", "0", "0", "0"]
/// ];
/// print(numIslandsBFS(grid)); // Outputs: 3
/// ```
int numIslandsBFS(List<List<String>> grid) {
  final m = grid.length, n = grid.isNotEmpty ? grid[0].length : 0;
  int count = 0;
  final directions = [
    [1, 0],
    [-1, 0],
    [0, 1],
    [0, -1],
  ];
  void bfs(int r, int c) {
    final queue = <List<int>>[];
    queue.add([r, c]);
    grid[r][c] = '0';
    while (queue.isNotEmpty) {
      final cell = queue.removeAt(0);
      for (final dir in directions) {
        final nr = cell[0] + dir[0], nc = cell[1] + dir[1];
        if (nr >= 0 && nr < m && nc >= 0 && nc < n && grid[nr][nc] == '1') {
          queue.add([nr, nc]);
          grid[nr][nc] = '0';
        }
      }
    }
  }

  for (int i = 0; i < m; i++) {
    for (int j = 0; j < n; j++) {
      if (grid[i][j] == '1') {
        count++;
        bfs(i, j);
      }
    }
  }
  return count;
}
