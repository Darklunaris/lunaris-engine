/// 🌀 Spiral Traversal of Matrix (Generic)
///
/// Returns the elements of the matrix in spiral order as a flat list.
/// Works for any type [T].
///
/// - Time Complexity: O(m * n)
/// - Space Complexity: O(m * n)
///
/// Example:
/// ```dart
/// var matrix = [
///   [1, 2, 3],
///   [4, 5, 6],
///   [7, 8, 9],
/// ];
/// spiralOrder(matrix); // [1,2,3,6,9,8,7,4,5]
/// ```
List<T> spiralOrder<T>(List<List<T>> matrix) {
  final result = <T>[];
  if (matrix.isEmpty || matrix[0].isEmpty) return result;
  int top = 0, bottom = matrix.length - 1;
  int left = 0, right = matrix[0].length - 1;
  while (top <= bottom && left <= right) {
    for (int j = left; j <= right; j++) {
      result.add(matrix[top][j]);
    }
    top++;
    for (int i = top; i <= bottom; i++) {
      result.add(matrix[i][right]);
    }
    right--;
    if (top <= bottom) {
      for (int j = right; j >= left; j--) {
        result.add(matrix[bottom][j]);
      }
      bottom--;
    }
    if (left <= right) {
      for (int i = bottom; i >= top; i--) {
        result.add(matrix[i][left]);
      }
      left++;
    }
  }
  return result;
}
