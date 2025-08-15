/// 🔎 k-Nearest Neighbors (k-NN) Classifier
///
/// Simple k-NN classifier using Euclidean distance and majority vote. This
/// implementation is intentionally straightforward and non-optimized.
///
/// Contract:
/// - Input: training features `X` (n x m), labels `y`, query point `q`, and k.
/// - Output: predicted integer class (majority vote).
///
/// Time Complexity: O(n * m) per query
/// Space Complexity: O(n)
library;

import 'dart:math';

double _euclidean(List<double> a, List<double> b) {
  var s = 0.0;
  for (var i = 0; i < a.length && i < b.length; i++) {
    final d = a[i] - b[i];
    s += d * d;
  }
  return sqrt(s);
}

int knnPredict(List<List<double>> X, List<int> y, List<double> q, int k) {
  final n = X.length;
  if (n == 0) throw ArgumentError('Empty training set');
  final dists = <MapEntry<double, int>>[];
  for (var i = 0; i < n; i++) {
    dists.add(MapEntry(_euclidean(X[i], q), y[i]));
  }
  dists.sort((a, b) => a.key.compareTo(b.key));
  final counts = <int, int>{};
  for (var i = 0; i < k && i < dists.length; i++) {
    counts[dists[i].value] = (counts[dists[i].value] ?? 0) + 1;
  }
  return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
}

/// Simple object wrapper for k-NN storing training data and exposing predict.
class KNNModel {
  List<List<double>>? _x;
  List<int>? _y;
  int _k = 3;

  void fit(List<List<double>> X, List<int> y, {int k = 3}) {
    _x = X;
    _y = y;
    _k = k;
  }

  int predictOne(List<double> q) {
    if (_x == null || _y == null) throw StateError('Model not fitted');
    return knnPredict(_x!, _y!, q, _k);
  }

  List<int> predict(List<List<double>> Q) => Q.map(predictOne).toList();
}
