/// 🔢 Logistic Regression (binary, gradient descent)
///
/// A small, production-aware implementation of binary logistic regression
/// trained with batch gradient descent. Supports multiple continuous
/// features and an intercept term. Returns learned weights where the first
/// weight is the intercept.
///
/// Contract:
/// - Input: feature matrix `X` (n x m) and labels `y` with values {0,1}.
/// - Output: List<double> weights of length m+1.
///
/// Time Complexity: O(epochs * n * m)
/// Space Complexity: O(m)
library;

import 'dart:math';

double _sigmoid(double z) => 1.0 / (1.0 + exp(-z));

List<double> logisticRegressionFit(
  List<List<double>> X,
  List<int> y, {
  double lr = 0.1,
  int epochs = 500,
}) {
  final n = X.length;
  if (n == 0) return [0.0];
  final m = X[0].length;
  if (y.length != n) throw ArgumentError('X and y length mismatch');

  final w = List<double>.filled(m + 1, 0.0); // intercept + weights
  for (var epoch = 0; epoch < epochs; epoch++) {
    final grad = List<double>.filled(m + 1, 0.0);
    for (var i = 0; i < n; i++) {
      var z = w[0];
      for (var j = 0; j < m; j++) {
        z += w[j + 1] * X[i][j];
      }
      final p = _sigmoid(z);
      final diff = p - y[i];
      grad[0] += diff;
      for (var j = 0; j < m; j++) {
        grad[j + 1] += diff * X[i][j];
      }
    }
    for (var k = 0; k <= m; k++) {
      w[k] -= lr * grad[k] / n;
    }
  }
  return w;
}

int logisticRegressionPredictClass(
  List<double> weights,
  List<double> features, {
  double threshold = 0.5,
}) {
  var z = weights[0];
  for (var i = 0; i < features.length && i + 1 < weights.length; i++) {
    z += weights[i + 1] * features[i];
  }
  return _sigmoid(z) >= threshold ? 1 : 0;
}

/// Thin adapter providing a fit/predict interface for logistic regression.
class LogisticRegressionModel {
  List<double>? _weights;

  /// Fit the logistic regression model.
  void fit(
    List<List<double>> X,
    List<int> y, {
    double lr = 0.1,
    int epochs = 500,
  }) {
    _weights = logisticRegressionFit(X, y, lr: lr, epochs: epochs);
  }

  /// Predict probability for a single example.
  double predictProba(List<double> features) {
    if (_weights == null) throw StateError('Model not fitted');
    var z = _weights![0];
    for (var i = 0; i < features.length && i + 1 < _weights!.length; i++) {
      z += _weights![i + 1] * features[i];
    }
    return _sigmoid(z);
  }

  /// Predict label (0/1) using 0.5 threshold.
  int predictOne(List<double> features) =>
      predictProba(features) >= 0.5 ? 1 : 0;

  /// Predict labels for multiple examples.
  List<int> predict(List<List<double>> X) => X.map(predictOne).toList();
}
