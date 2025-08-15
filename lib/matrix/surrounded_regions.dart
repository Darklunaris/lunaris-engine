/// Captures all regions surrounded by 'X' in a 2D board using DFS.
///
/// This function flips all 'O's that are not on the border or connected to the border to 'X'.
///
/// Time Complexity: O(m * n), where m and n are the grid dimensions.
/// Space Complexity: O(m * n) for the recursion stack.
///
/// Example:
/// ```dart
/// var board = [
///   ["X", "X", "X", "X"],
///   ["X", "O", "O", "X"],
///   ["X", "X", "O", "X"],
///   ["X", "O", "X", "X"]
/// ];
/// solveSurroundedRegions(board);
/// print(board); // Outputs: [[X, X, X, X], [X, X, X, X], [X, X, X, X], [X, O, X, X]]
/// ```
void solveSurroundedRegions(List<List<String>> board) {
  final m = board.length, n = board.isNotEmpty ? board[0].length : 0;
  void dfs(int r, int c) {
    if (r < 0 || r >= m || c < 0 || c >= n || board[r][c] != 'O') return;
    board[r][c] = 'E';
    dfs(r + 1, c);
    dfs(r - 1, c);
    dfs(r, c + 1);
    dfs(r, c - 1);
  }

  for (int i = 0; i < m; i++) {
    if (board[i][0] == 'O') dfs(i, 0);
    if (board[i][n - 1] == 'O') dfs(i, n - 1);
  }
  for (int j = 0; j < n; j++) {
    if (board[0][j] == 'O') dfs(0, j);
    if (board[m - 1][j] == 'O') dfs(m - 1, j);
  }
  for (int i = 0; i < m; i++) {
    for (int j = 0; j < n; j++) {
      if (board[i][j] == 'O') board[i][j] = 'X';
      if (board[i][j] == 'E') board[i][j] = 'O';
    }
  }
}
