/// 🐱 CatBoost-like Regressor (simplified)
///
/// Educational CatBoost-style regressor with a simple implementation of
/// ordered target statistics for categorical features and stump-based trees.
/// For real categorical handling, integrate with a robust encoding pipeline.
///
/// Contract:
/// - Input: `X` (n x m), `y` numeric targets. Pass `categoricalIndices` to
///   flag categorical columns (indices).
/// - Output: `CatBoostLikeRegressor` with `fit` and `predict`.
///
/// Time Complexity: O(n * m * n_estimators)
/// Space Complexity: O(n_estimators)
library;

class CatBoostLikeRegressor {
  final int nEstimators;
  final double learningRate;
  final List<_CBStump> _stumps = [];
  double _base = 0.0;
  final List<int> categoricalIndices;

  CatBoostLikeRegressor({
    this.nEstimators = 50,
    this.learningRate = 0.1,
    this.categoricalIndices = const [],
  });

  void fit(List<List<double>> X, List<double> y) {
    final n = X.length;
    if (n == 0) return;
    final m = X[0].length;
    _base = y.reduce((a, b) => a + b) / n;
    var preds = List<double>.filled(n, _base);

    // Precompute simple categorical target averages (ordered statistics)
    final catStats = <int, Map<double, double>>{};
    for (final ci in categoricalIndices) {
      final map = <double, List<double>>{};
      for (var i = 0; i < n; i++) {
        map[X[i][ci]] = (map[X[i][ci]] ?? [])..add(y[i]);
      }
      catStats[ci] = {
        for (final k in map.keys)
          k: map[k]!.reduce((a, b) => a + b) / map[k]!.length,
      };
    }

    for (var t = 0; t < nEstimators; t++) {
      final residuals = List<double>.generate(n, (i) => y[i] - preds[i]);
      _CBStump best = _CBStump();
      var bestErr = double.infinity;
      for (var f = 0; f < m; f++) {
        // if categorical, use precomputed stats as feature values
        final transformed = List<double>.generate(
          n,
          (i) =>
              categoricalIndices.contains(f)
                  ? (catStats[f]![X[i][f]] ?? 0.0)
                  : X[i][f],
        );
        final vals = transformed.toSet().toList()..sort();
        for (var i = 1; i < vals.length; i++) {
          final thresh = (vals[i - 1] + vals[i]) / 2.0;
          var leftSum = 0.0, rightSum = 0.0;
          var leftCnt = 0, rightCnt = 0;
          for (var r = 0; r < n; r++) {
            if (transformed[r] <= thresh) {
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
            final pred = transformed[r] <= thresh ? leftMean : rightMean;
            err += (residuals[r] - pred) * (residuals[r] - pred);
          }
          if (err < bestErr) {
            bestErr = err;
            best =
                _CBStump()
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
            (X[i][best.feature] <= best.threshold) ? best.left : best.right;
        preds[i] += learningRate * add;
      }
    }
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

class _CBStump {
  int feature = 0;
  double threshold = 0.0;
  double left = 0.0;
  double right = 0.0;
}
