/// 🌳 Decision Tree Classifier (CART-style, numeric features)
///
/// A compact CART-style decision tree classifier for numeric features using
/// Gini impurity and greedy splits. Supports a `maxDepth` parameter and
/// `minSamplesSplit` to avoid overfitting. Designed for clarity and small
/// datasets; uses recursion to build a tree of splits.
///
/// Contract:
/// - Input: feature matrix `X` (n x m) and integer labels `y` (0..k-1).
/// - Output: `DecisionTreeClassifier` object with `fit` and `predict`.
///
/// Time Complexity: O(n * m * n_splits) per depth (naive)
/// Space Complexity: O(n)
library;

class _Node {
  int? featureIndex;
  double? threshold;
  int? prediction;
  _Node? left;
  _Node? right;

  _Node();
}

class DecisionTreeClassifier {
  final int maxDepth;
  final int minSamplesSplit;
  _Node? _root;

  DecisionTreeClassifier({this.maxDepth = 5, this.minSamplesSplit = 2});

  void fit(List<List<double>> X, List<int> y) {
    _root = _build(X, y, 0);
  }

  int predict(List<double> x) {
    var node = _root;
    while (node != null) {
      if (node.prediction != null) return node.prediction!;
      final f = node.featureIndex!;
      if (x[f] <= node.threshold!) {
        node = node.left;
      } else {
        node = node.right;
      }
    }
    return 0;
  }

  _Node? _build(List<List<double>> X, List<int> y, int depth) {
    final n = X.length;
    final counts = <int, int>{};
    for (final v in y) {
      counts[v] = (counts[v] ?? 0) + 1;
    }
    if (counts.length == 1 || depth >= maxDepth || n < minSamplesSplit) {
      final node = _Node();
      node.prediction =
          counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
      return node;
    }

    final m = X[0].length;
    var bestGini = double.infinity;
    int bestFeature = 0;
    double bestThreshold = 0.0;
    List<int>? bestLeftIdx;
    for (var feature = 0; feature < m; feature++) {
      final values = X.map((r) => r[feature]).toSet().toList()..sort();
      for (var i = 1; i < values.length; i++) {
        final thresh = (values[i - 1] + values[i]) / 2.0;
        final leftIdx = <int>[];
        final rightIdx = <int>[];
        for (var j = 0; j < n; j++) {
          if (X[j][feature] <= thresh) {
            leftIdx.add(j);
          } else {
            rightIdx.add(j);
          }
        }
        if (leftIdx.isEmpty || rightIdx.isEmpty) continue;
        final giniLeft = _gini([for (var idx in leftIdx) y[idx]]);
        final giniRight = _gini([for (var idx in rightIdx) y[idx]]);
        final gini =
            (leftIdx.length * giniLeft + rightIdx.length * giniRight) / n;
        if (gini < bestGini) {
          bestGini = gini;
          bestFeature = feature;
          bestThreshold = thresh;
          bestLeftIdx = List<int>.from(leftIdx);
        }
      }
    }
    if (bestLeftIdx == null) {
      final node = _Node();
      node.prediction =
          counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
      return node;
    }
    final leftX = <List<double>>[];
    final leftY = <int>[];
    final rightX = <List<double>>[];
    final rightY = <int>[];
    for (var i = 0; i < n; i++) {
      if (X[i][bestFeature] <= bestThreshold) {
        leftX.add(X[i]);
        leftY.add(y[i]);
      } else {
        rightX.add(X[i]);
        rightY.add(y[i]);
      }
    }
    final node =
        _Node()
          ..featureIndex = bestFeature
          ..threshold = bestThreshold
          ..left = _build(leftX, leftY, depth + 1)
          ..right = _build(rightX, rightY, depth + 1);
    return node;
  }

  double _gini(List<int> labels) {
    final n = labels.length;
    final counts = <int, int>{};
    for (final v in labels) {
      counts[v] = (counts[v] ?? 0) + 1;
    }
    var g = 1.0;
    for (final c in counts.values) {
      final p = c / n;
      g -= p * p;
    }
    return g;
  }
}
