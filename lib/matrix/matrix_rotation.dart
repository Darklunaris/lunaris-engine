/// Rotates a square matrix (n x n) 90 degrees clockwise in-place.
///
/// This function modifies the input matrix directly.
///
/// Time Complexity: O(n^2), where n is the dimension of the matrix.
/// Space Complexity: O(1)
///
/// Example:
/// ```dart
/// var matrix = [
///   [1, 2, 3],
///   [4, 5, 6],
///   [7, 8, 9],
/// ];
/// rotateMatrix(matrix);
/// print(matrix); // Outputs: [[7,4,1],[8,5,2],[9,6,3]]
/// ```
void rotateMatrix(List<List<int>> matrix) {
  final n = matrix.length;
  for (int i = 0; i < n ~/ 2; i++) {
    for (int j = i; j < n - i - 1; j++) {
      int temp = matrix[i][j];
      matrix[i][j] = matrix[n - j - 1][i];
      matrix[n - j - 1][i] = matrix[n - i - 1][n - j - 1];
      matrix[n - i - 1][n - j - 1] = matrix[j][n - i - 1];
      matrix[j][n - i - 1] = temp;
    }
  }
}
