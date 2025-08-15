/// Searches for a word in a 2D grid using backtracking.
///
/// Returns true if the word exists in the grid [board] by moving horizontally or vertically.
///
/// Time Complexity: O(m * n * 4^L), where m and n are the grid dimensions and L is the word length.
/// Space Complexity: O(L) for the recursion stack.
///
/// Example:
/// ```dart
/// var board = [
///   ["A", "B", "C", "E"],
///   ["S", "F", "C", "S"],
///   ["A", "D", "E", "E"]
/// ];
/// print(wordSearch(board, "ABCCED")); // Outputs: true
/// print(wordSearch(board, "SEE"));    // Outputs: true
/// print(wordSearch(board, "ABCB"));   // Outputs: false
/// ```
bool wordSearch(List<List<String>> board, String word) {
  int m = board.length, n = board.isNotEmpty ? board[0].length : 0;
  List<List<bool>> visited = List.generate(m, (_) => List.filled(n, false));
  bool backtrack(int i, int j, int k) {
    if (k == word.length) return true;
    if (i < 0 ||
        i >= m ||
        j < 0 ||
        j >= n ||
        visited[i][j] ||
        board[i][j] != word[k]) {
      return false;
    }
    visited[i][j] = true;
    bool found =
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
