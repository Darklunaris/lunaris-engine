/// 📐 Principal Component Analysis (PCA)
///
/// A minimalist PCA implementation using the covariance method and power-iteration
/// for the top components. Focused on clarity and good docstring quality for
/// engineering usage. Returns projected data and principal components.
///
/// Contract:
/// - Input: X (n x m), desired number of components `d`.
/// - Output: projected matrix (n x d) and components (d x m).
/// - Error: throws ArgumentError for invalid shapes.
///
/// Time Complexity: O(n * m * d * iters)
/// Space Complexity: O(m*m)
library;

import 'dart:math';

// ...existing code...

List<double> _normalize(List<double> v) {
  final n = sqrt(v.map((x) => x * x).reduce((a, b) => a + b));
  if (n == 0) return List<double>.filled(v.length, 0.0);
  return v.map((x) => x / n).toList();
}

class PCA {
  final int components;
  PCA({required this.components}) {
    if (components <= 0) throw ArgumentError('components must be positive');
  }

  Map<String, dynamic> fitTransform(List<List<double>> X) {
    final n = X.length;
    if (n == 0) throw ArgumentError('Empty dataset');
    final m = X[0].length;
    // center
    final mean = List<double>.filled(m, 0.0);
    for (var i = 0; i < n; i++) {
      for (var j = 0; j < m; j++) {
        mean[j] += X[i][j];
      }
    }
    for (var j = 0; j < m; j++) {
      mean[j] /= n;
    }
    final xCentered = List.generate(n, (i) => List<double>.filled(m, 0.0));
    for (var i = 0; i < n; i++) {
      for (var j = 0; j < m; j++) {
        xCentered[i][j] = X[i][j] - mean[j];
      }
    }

    // covariance matrix
    final cov = List.generate(m, (_) => List<double>.filled(m, 0.0));
    for (var i = 0; i < n; i++) {
      for (var a = 0; a < m; a++) {
        for (var b = 0; b < m; b++) {
          cov[a][b] += xCentered[i][a] * xCentered[i][b];
        }
      }
    }
    for (var a = 0; a < m; a++) {
      for (var b = 0; b < m; b++) {
        cov[a][b] /= (n - 1);
      }
    }

    // power iteration for top components
    final comps = <List<double>>[];
    for (var k = 0; k < components; k++) {
      var v = List<double>.filled(m, 1.0);
      for (var iter = 0; iter < 1000; iter++) {
        final w = List<double>.filled(m, 0.0);
        for (var i = 0; i < m; i++) {
          for (var j = 0; j < m; j++) {
            w[i] += cov[i][j] * v[j];
          }
        }
        final nv = _normalize(w);
        // deflate
        if ((nv
                .asMap()
                .entries
                .map((e) => (nv[e.key] - v[e.key]) * (nv[e.key] - v[e.key]))
                .reduce((a, b) => a + b)).abs() <
            1e-9) {
          break;
        }
        v = nv;
      }
      comps.add(v);
      // deflate cov (simple subtraction)
      for (var i = 0; i < m; i++) {
        for (var j = 0; j < m; j++) {
          cov[i][j] -= v[i] * v[j];
        }
      }
    }

    final projected = List.generate(
      n,
      (_) => List<double>.filled(components, 0.0),
    );
    for (var i = 0; i < n; i++) {
      for (var k = 0; k < components; k++) {
        var s = 0.0;
        for (var j = 0; j < m; j++) {
          s += xCentered[i][j] * comps[k][j];
        }
        projected[i][k] = s;
      }
    }

    return {'projected': projected, 'components': comps, 'mean': mean};
  }
}
