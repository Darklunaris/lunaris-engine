/// LU decomposition with partial pivoting (Doolittle algorithm).
///
/// Returns a map with keys `L`, `U`, and `P` where `L` and `U` are lower and
/// upper triangular matrices respectively and `P` is a permutation vector
/// representing the row swaps. Designed for robustness and numerical stability
/// for dense double matrices.
///
/// Example:
/// ```dart
/// final A = [[4.0,3.0],[6.0,3.0]];
/// final res = luDecomposition(A);
/// ```
List<Map<String, dynamic>> luDecomposition(List<List<double>> A) {
  final n = A.length;
  if (A.any((row) => row.length != n)) {
    throw ArgumentError('Matrix must be square');
  }
  // Make a copy
  final a = List<List<double>>.generate(
    n,
    (i) => List<double>.from(A[i]),
    growable: false,
  );
  final piv = List<int>.generate(n, (i) => i);
  for (var k = 0; k < n; k++) {
    // partial pivot
    var maxRow = k;
    var maxVal = a[k][k].abs();
    for (var i = k + 1; i < n; i++) {
      final v = a[i][k].abs();
      if (v > maxVal) {
        maxVal = v;
        maxRow = i;
      }
    }
    if (maxRow != k) {
      final tmp = a[k];
      a[k] = a[maxRow];
      a[maxRow] = tmp;
      final ptmp = piv[k];
      piv[k] = piv[maxRow];
      piv[maxRow] = ptmp;
    }
    final akk = a[k][k];
    if (akk == 0.0) continue; // singular or nearly-singular
    for (var i = k + 1; i < n; i++) {
      a[i][k] /= akk;
      final aik = a[i][k];
      for (var j = k + 1; j < n; j++) {
        a[i][j] -= aik * a[k][j];
      }
    }
  }
  // Extract L and U
  final L = List<List<double>>.generate(
    n,
    (i) => List<double>.filled(n, 0.0),
    growable: false,
  );
  final U = List<List<double>>.generate(
    n,
    (i) => List<double>.filled(n, 0.0),
    growable: false,
  );
  for (var i = 0; i < n; i++) {
    for (var j = 0; j < n; j++) {
      if (i > j) {
        L[i][j] = a[i][j];
      } else if (i == j) {
        L[i][j] = 1.0;
        U[i][j] = a[i][j];
      } else {
        U[i][j] = a[i][j];
      }
    }
  }
  return [
    {'L': L, 'U': U, 'P': piv},
  ];
}
