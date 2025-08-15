/// 🧮 Gaussian Naive Bayes (continuous features)
///
/// Fits a Gaussian Naive Bayes model estimating per-class feature means and
/// variances. Uses log-probabilities for numerical stability. Returns a small
/// class that can `fit` and `predict`.
///
/// Contract:
/// - Input: `X` numeric features (n x m), `y` integer class labels.
/// - Output: `GaussianNB` instance with `fit` and `predict`.
///
/// Time Complexity: O(n * m)
/// Space Complexity: O(k * m)
library;

import 'dart:math';

class GaussianNB {
  late Map<int, List<double>> means;
  late Map<int, List<double>> variances;
  late Map<int, double> priors;

  void fit(List<List<double>> X, List<int> y) {
    final n = X.length;
    if (n == 0) return;
    final m = X[0].length;
    final sums = <int, List<double>>{};
    final sums2 = <int, List<double>>{};
    final counts = <int, int>{};
    for (var i = 0; i < n; i++) {
      final label = y[i];
      if (!sums.containsKey(label)) {
        sums[label] = List<double>.filled(m, 0.0);
        sums2[label] = List<double>.filled(m, 0.0);
        counts[label] = 0;
      }
      for (var j = 0; j < m; j++) {
        sums[label]![j] += X[i][j];
        sums2[label]![j] += X[i][j] * X[i][j];
      }
      counts[label] = counts[label]! + 1;
    }
    means = {};
    variances = {};
    priors = {};
    for (final label in sums.keys) {
      final c = counts[label]!;
      priors[label] = c / n;
      means[label] = List<double>.filled(m, 0.0);
      variances[label] = List<double>.filled(m, 1e-6);
      for (var j = 0; j < m; j++) {
        final mean = sums[label]![j] / c;
        final varr = sums2[label]![j] / c - mean * mean;
        means[label]![j] = mean;
        variances[label]![j] = varr <= 0 ? 1e-6 : varr;
      }
    }
  }

  int predict(List<double> x) {
    var bestLab = 0;
    var bestLog = double.negativeInfinity;
    for (final label in means.keys) {
      final mu = means[label]!;
      final varr = variances[label]!;
      var logp = log(priors[label]!);
      for (var j = 0; j < x.length; j++) {
        final diff = x[j] - mu[j];
        logp += -0.5 * (log(2 * pi * varr[j]) + diff * diff / varr[j]);
      }
      if (logp > bestLog) {
        bestLog = logp;
        bestLab = label;
      }
    }
    return bestLab;
  }
}
