/// Solves a 9x9 Sudoku puzzle in-place using backtracking.
///
/// This function fills the empty cells (denoted by '.') of the given [board] with digits 1-9 so that each row,
/// column, and 3x3 subgrid contains all digits exactly once. Returns true if a solution exists, otherwise false.
///
/// Time Complexity: O(9^(n*n)), where n is the size of the board (worst case, exponential due to backtracking).
///
/// Example:
/// ```dart
/// var board = [
///   ["5","3",".",".","7",".",".",".","."],
///   ["6",".",".","1","9","5",".",".","."],
///   [".","9","8",".",".",".",".","6","."],
///   ["8",".",".",".","6",".",".",".","3"],
///   ["4",".",".","8",".","3",".",".","1"],
///   ["7",".",".",".","2",".",".",".","6"],
///   [".","6",".",".",".",".","2","8","."],
///   [".",".",".","4","1","9",".",".","5"],
///   [".",".",".",".","8",".",".","7","9"]
/// ];
/// solveSudoku(board);
/// print(board); // Board is now solved in-place
/// ```
bool solveSudoku(List<List<String>> board) {
  bool isValid(int row, int col, String c) {
    for (int i = 0; i < 9; i++) {
      if (board[row][i] == c || board[i][col] == c) return false;
      int boxRow = 3 * (row ~/ 3) + i ~/ 3;
      int boxCol = 3 * (col ~/ 3) + i % 3;
      if (board[boxRow][boxCol] == c) return false;
    }
    return true;
  }

  bool backtrack() {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (board[row][col] == '.') {
          for (int d = 1; d <= 9; d++) {
            String c = d.toString();
            if (isValid(row, col, c)) {
              board[row][col] = c;
              if (backtrack()) return true;
              board[row][col] = '.';
            }
          }
          return false;
        }
      }
    }
    return true;
  }

  return backtrack();
}
