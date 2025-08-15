/// 🖨️ Flood Fill (DFS, Generic)
///
/// Fills the connected area of [matrix] starting from ([sr], [sc]) with [newValue].
/// Returns the modified matrix. Works for any type [T] that supports equality.
///
/// - Time Complexity: O(m * n)
/// - Space Complexity: O(m * n) (due to recursion stack)
///
/// Example:
/// ```dart
/// var matrix = [
///   [1, 1, 0],
///   [1, 0, 0],
///   [0, 0, 1],
/// ];
/// floodFill(matrix, 0, 0, 2); // [[2,2,0],[2,0,0],[0,0,1]]
/// ```
List<List<T>> floodFill<T>(List<List<T>> matrix, int sr, int sc, T newValue) {
  final m = matrix.length, n = matrix.isNotEmpty ? matrix[0].length : 0;
  if (m == 0 || n == 0) return matrix;
  final oldValue = matrix[sr][sc];
  if (oldValue == newValue) return matrix;
  void dfs(int r, int c) {
    if (r < 0 || r >= m || c < 0 || c >= n || matrix[r][c] != oldValue) return;
    matrix[r][c] = newValue;
    dfs(r + 1, c);
    dfs(r - 1, c);
    dfs(r, c + 1);
    dfs(r, c - 1);
  }

  dfs(sr, sc);
  return matrix;
}
