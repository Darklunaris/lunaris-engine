/// ⚡ Gradient Boosting Regressor (stumps)
///
/// A concise gradient boosting regressor using decision stumps (one-feature
/// threshold learners) as weak learners. Uses squared-error loss and a
/// learning rate. Designed for clarity and small datasets.
///
/// Contract:
/// - Input: `X` (n x m), `y` numeric targets.
/// - Output: `GradientBoostingRegressor` with `fit` and `predict`.
///
/// Time Complexity: O(n * m * n_estimators)
/// Space Complexity: O(n_estimators)
library;

class _Stump {
  int feature = 0;
  double threshold = 0.0;
  double leftValue = 0.0;
  double rightValue = 0.0;
}

class GradientBoostingRegressor {
  final int nEstimators;
  final double learningRate;
  final List<_Stump> _stumps = [];
  double _init = 0.0;

  GradientBoostingRegressor({this.nEstimators = 50, this.learningRate = 0.1});

  void fit(List<List<double>> X, List<double> y) {
    final n = X.length;
    if (n == 0) return;
    final m = X[0].length;
    _init = y.reduce((a, b) => a + b) / n;
    var preds = List<double>.filled(n, _init);
    for (var t = 0; t < nEstimators; t++) {
      final residuals = List<double>.generate(n, (i) => y[i] - preds[i]);
      _Stump bestStump = _Stump();
      var bestError = double.infinity;
      for (var f = 0; f < m; f++) {
        final vals = X.map((r) => r[f]).toSet().toList()..sort();
        for (var i = 1; i < vals.length; i++) {
          final thresh = (vals[i - 1] + vals[i]) / 2.0;
          final left = <double>[];
          final right = <double>[];
          for (var r = 0; r < n; r++) {
            if (X[r][f] <= thresh) {
              left.add(residuals[r]);
            } else {
              right.add(residuals[r]);
            }
          }
          if (left.isEmpty || right.isEmpty) continue;
          final leftMean = left.reduce((a, b) => a + b) / left.length;
          final rightMean = right.reduce((a, b) => a + b) / right.length;
          var err = 0.0;
          for (var v in left) {
            err += (v - leftMean) * (v - leftMean);
          }
          for (var v in right) {
            err += (v - rightMean) * (v - rightMean);
          }
          if (err < bestError) {
            bestError = err;
            bestStump =
                _Stump()
                  ..feature = f
                  ..threshold = thresh
                  ..leftValue = leftMean
                  ..rightValue = rightMean;
          }
        }
      }
      _stumps.add(bestStump);
      for (var i = 0; i < n; i++) {
        final add =
            X[i][bestStump.feature] <= bestStump.threshold
                ? bestStump.leftValue
                : bestStump.rightValue;
        preds[i] += learningRate * add;
      }
    }
  }

  double predictOne(List<double> x) {
    var s = _init;
    for (final stump in _stumps) {
      s +=
          learningRate *
          (x[stump.feature] <= stump.threshold
              ? stump.leftValue
              : stump.rightValue);
    }
    return s;
  }

  List<double> predict(List<List<double>> X) =>
      X.map((x) => predictOne(x)).toList();
}
