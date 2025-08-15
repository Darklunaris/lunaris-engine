/// QR decomposition using Householder reflections.
///
/// Produces `Q` (orthogonal) and `R` (upper-triangular) matrices for a given
/// dense matrix. This implementation favours numerical stability and is suitable
/// for solving least-squares problems and matrix factorizations.
///
/// Example:
/// ```dart
/// final A = [[12.0,-51.0,4.0],[6.0,167.0,-68.0],[-4.0,24.0,-41.0]];
/// final res = qrDecomposition(A);
/// ```
library;

import 'dart:math' show sqrt;

Map<String, List<List<double>>> qrDecomposition(List<List<double>> A) {
  final m = A.length;
  final n = A[0].length;
  final a = List<List<double>>.generate(m, (i) => List<double>.from(A[i]));
  final R = List<List<double>>.generate(
    m,
    (i) => List<double>.filled(n, 0.0),
    growable: false,
  );
  final Q = List<List<double>>.generate(
    m,
    (i) => List<double>.filled(m, 0.0),
    growable: false,
  ); // initialize Q as identity
  for (var i = 0; i < m; i++) {
    Q[i][i] = 1.0;
  }
  for (var k = 0; k < n; k++) {
    // Build Householder for column k
    var norm = 0.0;
    for (var i = k; i < m; i++) {
      norm += a[i][k] * a[i][k];
    }
    norm = norm >= 0 ? sqrt(norm) : -sqrt(norm);
    if (norm == 0.0) continue;
    final u = List<double>.filled(m, 0.0);
    u[k] = a[k][k] + (a[k][k] >= 0 ? norm : -norm);
    for (var i = k + 1; i < m; i++) {
      u[i] = a[i][k];
    }
    var uNorm2 = 0.0;
    for (var i = k; i < m; i++) {
      uNorm2 += u[i] * u[i];
    }
    if (uNorm2 == 0.0) continue;
    // Apply reflection to remaining columns
    for (var j = k; j < n; j++) {
      var dot = 0.0;
      for (var i = k; i < m; i++) {
        dot += u[i] * a[i][j];
      }
      dot *= 2.0 / uNorm2;
      for (var i = k; i < m; i++) {
        a[i][j] -= dot * u[i];
      }
    }
    // Update Q
    for (var j = 0; j < m; j++) {
      var dot = 0.0;
      for (var i = k; i < m; i++) {
        dot += u[i] * Q[i][j];
      }
      dot *= 2.0 / uNorm2;
      for (var i = k; i < m; i++) {
        Q[i][j] -= dot * u[i];
      }
    }
  }
  // R is the upper triangle of the transformed `a`
  for (var i = 0; i < m; i++) {
    for (var j = 0; j < n; j++) {
      R[i][j] = i <= j ? a[i][j] : 0.0;
    }
  }
  // Transpose Q to get the orthogonal matrix
  final qt = List<List<double>>.generate(m, (i) => List<double>.filled(m, 0.0));
  for (var i = 0; i < m; i++) {
    for (var j = 0; j < m; j++) {
      qt[i][j] = Q[j][i];
    }
  }
  return {'Q': qt, 'R': R};
}
