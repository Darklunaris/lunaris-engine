/// 📈 Linear Regression (Ordinary Least Squares)
///
/// Simple linear regression (ordinary least squares) for a single predictor
/// or multiple predictors implemented with a numerically stable formula for
/// the slope(s) and intercept. Returns fitted coefficients in the shape
/// `[intercept, b1, b2, ...]` and provides a small predictor helper.
///
/// Contract:
/// - Input: feature matrix `X` as List<List<double>> (n x m) and target
///   vector `y` as List<double> of length n. For single predictor you may
///   pass X as a list of single-element lists.
/// - Output: List<double> coefficients where first element is intercept.
///
/// Time Complexity: O(n*m^2) (naive normal-equation with small m)
/// Space Complexity: O(m^2)
library;

// no external imports required

List<double> linearRegressionFit(List<List<double>> X, List<double> y) {
  final n = X.length;
  if (n == 0) return [0.0];
  final m = X[0].length;
  if (y.length != n) throw ArgumentError('X and y length mismatch');

  // Build design matrix with intercept column and compute normal equation
  // using X^T * X and X^T * y. For small m this is acceptable.
  final xtx = List.generate(m + 1, (_) => List<double>.filled(m + 1, 0.0));
  final xty = List<double>.filled(m + 1, 0.0);

  for (var i = 0; i < n; i++) {
    final row = [1.0, ...X[i]];
    final yi = y[i];
    for (var a = 0; a <= m; a++) {
      for (var b = 0; b <= m; b++) {
        xtx[a][b] += row[a] * row[b];
      }
      xty[a] += row[a] * yi;
    }
  }

  // Solve linear system xtx * beta = xty using Gaussian elimination
  final A = List.generate(m + 1, (i) => List<double>.from(xtx[i]));
  final B = List<double>.from(xty);
  final dim = m + 1;

  for (var i = 0; i < dim; i++) {
    // pivot
    var pivot = i;
    for (var r = i + 1; r < dim; r++) {
      if (A[r][i].abs() > A[pivot][i].abs()) pivot = r;
    }
    if (A[pivot][i].abs() < 1e-12) continue; // singular-ish
    if (pivot != i) {
      final tmp = A[i];
      A[i] = A[pivot];
      A[pivot] = tmp;
      final bt = B[i];
      B[i] = B[pivot];
      B[pivot] = bt;
    }
    final div = A[i][i];
    for (var j = i; j < dim; j++) {
      A[i][j] /= div;
    }
    B[i] /= div;
    for (var r = 0; r < dim; r++) {
      if (r == i) continue;
      final factor = A[r][i];
      for (var c = i; c < dim; c++) {
        A[r][c] -= factor * A[i][c];
      }
      B[r] -= factor * B[i];
    }
  }
  return B;
}

double linearRegressionPredict(List<double> coeffs, List<double> features) {
  var out = coeffs[0];
  for (var i = 0; i < features.length && i + 1 < coeffs.length; i++) {
    out += coeffs[i + 1] * features[i];
  }
  return out;
}

/// Thin object wrapper around the functional API to provide a uniform
/// fit/predict interface used across the ML modules.
class LinearRegressionModel {
  List<double>? _coeffs;

  /// Fit the model to features `X` and targets `y`.
  void fit(List<List<double>> X, List<double> y) {
    _coeffs = linearRegressionFit(X, y);
  }

  /// Predict a single example's target value.
  double predictOne(List<double> features) {
    if (_coeffs == null) throw StateError('Model not fitted');
    return linearRegressionPredict(_coeffs!, features);
  }

  /// Predict a list of examples.
  List<double> predict(List<List<double>> X) => X.map(predictOne).toList();
}
