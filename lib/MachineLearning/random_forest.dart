/// 🌲 Random Forest Classifier (bagging of decision trees)
///
/// Simple random forest implementation that bootstraps samples and trains
/// multiple `DecisionTreeClassifier` instances, then predicts by majority
/// voting. This is a compact, well-documented version fit for small to
/// medium toy datasets and educational use.
///
/// Contract:
/// - Input: feature matrix `X` and labels `y` (integers). Hyperparameters
///   control number of trees and sample ratio.
/// - Output: `RandomForestClassifier` instance with `fit` and `predict`.
///
/// Time Complexity: O(n_estimators * cost_of_tree_build)
/// Space Complexity: O(n_estimators * model_size)
library;

import 'dart:math';
import 'decision_tree.dart';

class RandomForestClassifier {
  final int nEstimators;
  final int maxDepth;
  final double sampleRatio;
  final List<DecisionTreeClassifier> _trees = [];
  final Random _rand = Random();

  RandomForestClassifier({
    this.nEstimators = 10,
    this.maxDepth = 5,
    this.sampleRatio = 0.8,
  });

  void fit(List<List<double>> X, List<int> y) {
    final n = X.length;
    final sampleSize = (n * sampleRatio).ceil();
    _trees.clear();
    for (var t = 0; t < nEstimators; t++) {
      final sampleX = <List<double>>[];
      final sampleY = <int>[];
      for (var i = 0; i < sampleSize; i++) {
        final idx = _rand.nextInt(n);
        sampleX.add(X[idx]);
        sampleY.add(y[idx]);
      }
      final tree = DecisionTreeClassifier(maxDepth: maxDepth);
      tree.fit(sampleX, sampleY);
      _trees.add(tree);
    }
  }

  int predict(List<double> x) {
    final votes = <int, int>{};
    for (final t in _trees) {
      final p = t.predict(x);
      votes[p] = (votes[p] ?? 0) + 1;
    }
    return votes.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }
}
