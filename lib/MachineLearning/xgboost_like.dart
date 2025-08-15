/// 🧰 Simplified XGBoost-like Regressor (stump + second-order)
///
/// A simplified, educational XGBoost-style regressor using decision stumps
/// and second-order approximation (gradients & hessians) to compute optimal
/// leaf weights. This implements regularization lambda and learning rate.
///
/// Contract:
/// - Input: `X` (n x m), targets `y` numeric.
/// - Output: `XGBoostLikeRegressor` with `fit` and `predict`.
///
/// Time Complexity: O(n * m * n_estimators)
/// Space Complexity: O(n_estimators)
library;

class _XGStump {
  int feature = 0;
  double threshold = 0.0;
  double wLeft = 0.0;
  double wRight = 0.0;
}

class XGBoostLikeRegressor {
  final int nEstimators;
  final double learningRate;
  final double lambda;
  final List<_XGStump> _stumps = [];
  double _base = 0.0;

  XGBoostLikeRegressor({
    this.nEstimators = 50,
    this.learningRate = 0.1,
    this.lambda = 1.0,
  });

  void fit(List<List<double>> X, List<double> y) {
    final n = X.length;
    if (n == 0) return;
    final m = X[0].length;
    _base = y.reduce((a, b) => a + b) / n;
    var preds = List<double>.filled(n, _base);

    for (var t = 0; t < nEstimators; t++) {
      final grads = List<double>.generate(
        n,
        (i) => preds[i] - y[i],
      ); // gradient of squared loss: pred - y
      final hess = List<double>.filled(
        n,
        1.0,
      ); // second derivative of squared loss is 1
      _XGStump best = _XGStump();
      double bestScore = double.negativeInfinity;

      for (var f = 0; f < m; f++) {
        final vals = X.map((r) => r[f]).toSet().toList()..sort();
        for (var i = 1; i < vals.length; i++) {
          final thresh = (vals[i - 1] + vals[i]) / 2.0;
          double gl = 0.0, hl = 0.0, gr = 0.0, hr = 0.0;
          for (var r = 0; r < n; r++) {
            if (X[r][f] <= thresh) {
              gl += grads[r];
              hl += hess[r];
            } else {
              gr += grads[r];
              hr += hess[r];
            }
          }
          final wl = -(gl) / (hl + lambda);
          final wr = -(gr) / (hr + lambda);
          final score =
              0.5 * (gl * gl / (hl + lambda) + gr * gr / (hr + lambda)) -
              lambda * (wl * wl + wr * wr) * 0.5;
          if (score > bestScore) {
            bestScore = score;
            best =
                _XGStump()
                  ..feature = f
                  ..threshold = thresh
                  ..wLeft = wl
                  ..wRight = wr;
          }
        }
      }
      _stumps.add(best);
      for (var i = 0; i < n; i++) {
        final w =
            X[i][best.feature] <= best.threshold ? best.wLeft : best.wRight;
        preds[i] += learningRate * w;
      }
    }
  }

  double predictOne(List<double> x) {
    var s = _base;
    for (final stump in _stumps) {
      s +=
          learningRate *
          (x[stump.feature] <= stump.threshold ? stump.wLeft : stump.wRight);
    }
    return s;
  }

  List<double> predict(List<List<double>> X) =>
      X.map((x) => predictOne(x)).toList();
}
