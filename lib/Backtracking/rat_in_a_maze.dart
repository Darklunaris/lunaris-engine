/// Finds all possible paths for a rat to reach the bottom-right corner from the top-left in a maze using backtracking.
///
/// This function returns all possible paths for a rat to move from the top-left to the bottom-right corner in a grid [maze].
/// The rat can move Down (D), Left (L), Right (R), or Up (U) to open cells (1). Blocked cells are marked as 0.
///
/// Time Complexity: O(4^(n*n)), where n is the size of the maze (worst case, exponential due to backtracking).
///
/// Example:
/// ```dart
/// var maze = [
///   [1, 0, 0, 0],
///   [1, 1, 0, 1],
///   [0, 1, 0, 0],
///   [1, 1, 1, 1]
/// ];
/// var result = ratInMaze(maze);
/// print(result); // Outputs: ["DDRDRR", "DRDDRR"]
/// ```
List<String> ratInMaze(List<List<int>> maze) {
  int n = maze.length;
  List<String> result = [];
  List<List<bool>> visited = List.generate(n, (_) => List.filled(n, false));
  void backtrack(int x, int y, String path) {
    if (x < 0 ||
        y < 0 ||
        x >= n ||
        y >= n ||
        maze[x][y] == 0 ||
        visited[x][y]) {
      return;
    }
    if (x == n - 1 && y == n - 1) {
      result.add(path);
      return;
    }
    visited[x][y] = true;
    backtrack(x + 1, y, '${path}D');
    backtrack(x, y - 1, '${path}L');
    backtrack(x, y + 1, '${path}R');
    backtrack(x - 1, y, '${path}U');
    visited[x][y] = false;
  }

  backtrack(0, 0, '');
  return result;
}
