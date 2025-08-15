/// 🌩 LightGBM-like Regressor (simplified)
///
/// Simplified LightGBM-style regressor that demonstrates key ideas: feature
/// subsampling, leaf-wise growth via greedy stump selection, and fast split
/// enumeration using unique feature values. This is educational, not a
/// production implementation.
///
/// Contract:
/// - Input: `X` (n x m), `y` numeric targets.
/// - Output: `LightGBMLikeRegressor` with `fit` and `predict`.
///
/// Time Complexity: O(n * m * n_estimators)
/// Space Complexity: O(n_estimators)
library;

import 'dart:math';

class LightGBMLikeRegressor {
  final int nEstimators;
  final double learningRate;
  final double featureFraction;
  final Random _rand = Random();
  final List<_GBStump> _stumps = [];
  double _base = 0.0;

  LightGBMLikeRegressor({
    this.nEstimators = 50,
    this.learningRate = 0.1,
    this.featureFraction = 0.7,
  });

  void fit(List<List<double>> X, List<double> y) {
    final n = X.length;
    if (n == 0) return;
    final m = X[0].length;
    _base = y.reduce((a, b) => a + b) / n;
    var preds = List<double>.filled(n, _base);

    for (var t = 0; t < nEstimators; t++) {
      final residuals = List<double>.generate(n, (i) => y[i] - preds[i]);
      final features = _sampleFeatures(m);
      _GBStump best = _GBStump();
      var bestErr = double.infinity;
      for (final f in features) {
        final vals = X.map((r) => r[f]).toSet().toList()..sort();
        for (var i = 1; i < vals.length; i++) {
          final thresh = (vals[i - 1] + vals[i]) / 2.0;
          var leftSum = 0.0, rightSum = 0.0;
          var leftCnt = 0, rightCnt = 0;
          for (var r = 0; r < n; r++) {
            if (X[r][f] <= thresh) {
              leftSum += residuals[r];
              leftCnt++;
            } else {
              rightSum += residuals[r];
              rightCnt++;
            }
          }
          if (leftCnt == 0 || rightCnt == 0) continue;
          final leftMean = leftSum / leftCnt;
          final rightMean = rightSum / rightCnt;
          var err = 0.0;
          for (var r = 0; r < n; r++) {
            final pred = X[r][f] <= thresh ? leftMean : rightMean;
            err += (residuals[r] - pred) * (residuals[r] - pred);
          }
          if (err < bestErr) {
            bestErr = err;
            best =
                _GBStump()
                  ..feature = f
                  ..threshold = thresh
                  ..left = leftMean
                  ..right = rightMean;
          }
        }
      }
      _stumps.add(best);
      for (var i = 0; i < n; i++) {
        final add =
            X[i][best.feature] <= best.threshold ? best.left : best.right;
        preds[i] += learningRate * add;
      }
    }
  }

  List<int> _sampleFeatures(int m) {
    final k = max(1, (m * featureFraction).floor());
    final idxs = List<int>.generate(m, (i) => i)..shuffle(_rand);
    return idxs.sublist(0, k);
  }

  double predictOne(List<double> x) {
    var s = _base;
    for (final st in _stumps) {
      s += learningRate * (x[st.feature] <= st.threshold ? st.left : st.right);
    }
    return s;
  }

  List<double> predict(List<List<double>> X) =>
      X.map((x) => predictOne(x)).toList();
}

class _GBStump {
  int feature = 0;
  double threshold = 0.0;
  double left = 0.0;
  double right = 0.0;
}
