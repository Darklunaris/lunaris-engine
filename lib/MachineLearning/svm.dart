/// 🧭 Support Vector Machine (linear SVM, primal hinge loss)
///
/// A compact linear SVM trained with subgradient descent on the primal
/// hinge-loss objective. Returns weights `[bias, w1, w2, ...]` where the
/// first element is the intercept term. Designed for clarity and small
/// datasets; for large-scale problems prefer specialized libraries.
///
/// Contract:
/// - Input: `X` as `List<List<double>>` (n x m), `y` as `List<int>` with
///   labels {-1, +1}.
/// - Output: `List<double>` of length m+1 representing bias followed by weights.
///
/// Time Complexity: O(epochs * n * m)
/// Space Complexity: O(m)
library;

List<double> trainLinearSVM(
  List<List<double>> X,
  List<int> y, {
  double lr = 0.01,
  int epochs = 500,
  double C = 1.0,
}) {
  final n = X.length;
  if (n == 0) return [0.0];
  final m = X[0].length;
  if (y.length != n) throw ArgumentError('X and y must have same length');

  final weights = List<double>.filled(m, 0.0);
  var bias = 0.0;

  for (var epoch = 0; epoch < epochs; epoch++) {
    for (var i = 0; i < n; i++) {
      final xi = X[i];
      final yi = y[i];
      var dot = bias;
      for (var j = 0; j < m; j++) {
        dot += weights[j] * xi[j];
      }
      if (yi * dot < 1) {
        // subgradient for hinge loss with L2 regularization scaled by 1/2
        for (var j = 0; j < m; j++) {
          weights[j] = weights[j] - lr * (weights[j] - C * yi * xi[j]);
        }
        bias += lr * C * yi;
      } else {
        for (var j = 0; j < m; j++) {
          weights[j] = weights[j] - lr * weights[j];
        }
      }
    }
  }
  return [bias, ...weights];
}

int predictLinearSVM(List<double> model, List<double> x) {
  final bias = model[0];
  var dot = bias;
  for (var i = 0; i < x.length && i + 1 < model.length; i++) {
    dot += model[i + 1] * x[i];
  }
  return dot >= 0 ? 1 : -1;
}

/// Thin wrapper providing fit/predict interface for the linear SVM.
class SVMModel {
  List<double>? _model;

  /// Fit model with labels in {-1, +1}.
  void fit(
    List<List<double>> X,
    List<int> y, {
    double lr = 0.01,
    int epochs = 500,
    double C = 1.0,
  }) {
    _model = trainLinearSVM(X, y, lr: lr, epochs: epochs, C: C);
  }

  /// Predict a single example, returning {-1, +1}.
  int predictOne(List<double> x) {
    if (_model == null) throw StateError('Model not fitted');
    return predictLinearSVM(_model!, x);
  }

  /// Predict multiple examples.
  List<int> predict(List<List<double>> X) => X.map(predictOne).toList();
}
