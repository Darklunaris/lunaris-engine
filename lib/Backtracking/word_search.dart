/// 🔍 Word Search (Backtracking on Grid, Generic)
///
/// Returns true if the sequence [pattern] exists in the grid [board].
/// Works for any type [T] that supports equality.
///
/// - Time Complexity: O(m * n * 4^L) where L is the length of pattern.
/// - Space Complexity: O(m * n) (due to recursion stack and visited matrix)
///
/// Example:
/// ```dart
/// var board = [
///   ['A', 'B', 'C', 'E'],
///   ['S', 'F', 'C', 'S'],
///   ['A', 'D', 'E', 'E'],
/// ];
/// wordSearch(board, ['A','B','C','C','E','D']); // true
/// ```
bool wordSearch<T>(List<List<T>> board, List<T> pattern) {
  final m = board.length, n = board.isNotEmpty ? board[0].length : 0;
  if (pattern.isEmpty) return true;
  final visited = List.generate(m, (_) => List.filled(n, false));
  bool backtrack(int i, int j, int k) {
    if (k == pattern.length) return true;
    if (i < 0 ||
        i >= m ||
        j < 0 ||
        j >= n ||
        visited[i][j] ||
        board[i][j] != pattern[k]) {
      return false;
    }
    visited[i][j] = true;
    final found =
        backtrack(i + 1, j, k + 1) ||
        backtrack(i - 1, j, k + 1) ||
        backtrack(i, j + 1, k + 1) ||
        backtrack(i, j - 1, k + 1);
    visited[i][j] = false;
    return found;
  }

  for (int i = 0; i < m; i++) {
    for (int j = 0; j < n; j++) {
      if (backtrack(i, j, 0)) return true;
    }
  }
  return false;
}
