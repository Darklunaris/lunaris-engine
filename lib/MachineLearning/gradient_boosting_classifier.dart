/// 🧠 Gradient Boosting Classifier (simple logistic variant)
///
/// A concise gradient boosting classifier using decision stumps as weak
/// learners and a logistic-like squared approximation; this implementation
/// focuses on clarity and API parity with the regressor.
///
/// Contract:
/// - Input: `X` (n x m), labels `y` in {0,1}.
/// - Output: `GradientBoostingClassifier` instance with `fit` and `predict`.
///
/// Time Complexity: O(n * m * n_estimators)
/// Space Complexity: O(n_estimators)
library;

import 'gradient_boosting.dart';

class GradientBoostingClassifier {
  final GradientBoostingRegressor _reg;

  GradientBoostingClassifier({int nEstimators = 50, double learningRate = 0.1})
    : _reg = GradientBoostingRegressor(
        nEstimators: nEstimators,
        learningRate: learningRate,
      );

  void fit(List<List<double>> X, List<int> y) {
    // encode labels 0/1 as numeric targets and fit a regressor to approximate
    // the logit of probabilities; for simplicity we fit directly to y.
    final targets = y.map((v) => v.toDouble()).toList();
    _reg.fit(X, targets);
  }

  int predict(List<double> x, {double threshold = 0.5}) {
    final p = _reg.predictOne(x);
    return p >= threshold ? 1 : 0;
  }
}
