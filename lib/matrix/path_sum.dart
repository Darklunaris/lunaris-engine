/// ➕ Path Sum in Matrix (DFS, Generic)
///
/// Returns true if there is a path from (0,0) to (m-1,n-1) with sum equal to [target].
/// Works for any numeric type [T extends num].
///
/// - Time Complexity: O(m * n)
/// - Space Complexity: O(m * n) (due to recursion stack)
///
/// Example:
/// ```dart
/// var matrix = [
///   [1, 2],
///   [3, 4],
/// ];
/// hasPathSum(matrix, 8); // true (1→2→4→1)
/// ```
bool hasPathSum<T extends num>(List<List<T>> matrix, T target) {
  final m = matrix.length, n = matrix.isNotEmpty ? matrix[0].length : 0;
  if (m == 0 || n == 0) return false;

  bool dfs(int r, int c, T sum) {
    if (r < 0 || r >= m || c < 0 || c >= n) return false;

    // Add current cell value to sum
    final currentSum = (sum + matrix[r][c]) as T;

    // If we reached the bottom-right corner, check if sum equals target
    if (r == m - 1 && c == n - 1) {
      return currentSum == target;
    }

    // Try moving right and down
    return dfs(r + 1, c, currentSum) || dfs(r, c + 1, currentSum);
  }

  // Start DFS from (0,0) with initial sum 0
  return dfs(0, 0, (0 as T));
}
