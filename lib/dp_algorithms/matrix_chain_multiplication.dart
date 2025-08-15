/// 📐 Matrix Chain Multiplication (DP)
///
/// Given dimensions of matrices as a list `dims` of length n+1 where the i-th
/// matrix has dimensions dims[i-1] x dims[i], compute the minimum number of
/// scalar multiplications needed to compute the matrix product.
///
/// Contract:
/// - Input: List<int> dims with length >= 2.
/// - Output: int minimum number of multiplications.
///
/// Time Complexity: O(n^3)
/// Space Complexity: O(n^2)
///
/// Example:
/// ```dart
/// final dims = [40,20,30,10,30];
/// expect(matrixChainOrder(dims), equals(26000));
/// ```
int matrixChainOrder(List<int> dims) {
  final n = dims.length - 1;
  if (n <= 0) return 0;
  final dp = List.generate(n + 1, (_) => List<int>.filled(n + 1, 0));

  for (var len = 2; len <= n; len++) {
    for (var i = 1; i <= n - len + 1; i++) {
      final j = i + len - 1;
      dp[i][j] = 1 << 62; // large
      for (var k = i; k < j; k++) {
        final cost = dp[i][k] + dp[k + 1][j] + dims[i - 1] * dims[k] * dims[j];
        if (cost < dp[i][j]) dp[i][j] = cost;
      }
    }
  }

  return dp[1][n];
}
