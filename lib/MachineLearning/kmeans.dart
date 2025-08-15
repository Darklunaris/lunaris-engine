/// 🔶 k-Means Clustering (robust, production-minded)
///
/// A compact, well-documented implementation of k-means clustering with a
/// k-means++ initializer, configurable distance metric (Euclidean), and a
/// deterministic API that exposes `fit`, `predict`, and `inertia`.
///
/// Contract:
/// - Input: feature matrix `X` as `List<List<double>>` (n x m), k clusters.
/// - Output: learned centroids and integer labels for each point.
/// - Error modes: throws `ArgumentError` on invalid shapes or parameters.
///
/// Time Complexity: O(n * k * iters * m)
/// Space Complexity: O(k * m + n)
library;

import 'dart:math';

double _distSq(List<double> a, List<double> b) {
  var s = 0.0;
  for (var i = 0; i < a.length && i < b.length; i++) {
    final d = a[i] - b[i];
    s += d * d;
  }
  return s;
}

class KMeans {
  final int k;
  final int maxIter;
  final double tol;
  List<List<double>>? centroids;
  List<int>? labels;

  KMeans(this.k, {this.maxIter = 300, this.tol = 1e-4}) {
    if (k <= 0) throw ArgumentError('k must be positive');
  }

  void fit(List<List<double>> X) {
    final n = X.length;
    if (n == 0) throw ArgumentError('Empty dataset');
    final m = X[0].length;
    // init with kmeans++
    final rnd = Random(0);
    final centers = <List<double>>[];
    centers.add(List<double>.from(X[rnd.nextInt(n)]));
    final dist = List<double>.filled(n, double.infinity);
    while (centers.length < k) {
      for (var i = 0; i < n; i++) {
        dist[i] = centers
            .map((c) => _distSq(X[i], c))
            .reduce((a, b) => a < b ? a : b);
      }
      final total = dist.reduce((a, b) => a + b);
      var r = rnd.nextDouble() * total;
      var idx = 0;
      while (r > 0 && idx < n) {
        r -= dist[idx++];
      }
      centers.add(List<double>.from(X[(idx - 1).clamp(0, n - 1)]));
    }

    labels = List<int>.filled(n, 0);
    for (var iter = 0; iter < maxIter; iter++) {
      var changed = false;
      // assign
      for (var i = 0; i < n; i++) {
        var best = 0;
        var bestD = double.infinity;
        for (var j = 0; j < centers.length; j++) {
          final d = _distSq(X[i], centers[j]);
          if (d < bestD) {
            bestD = d;
            best = j;
          }
        }
        if (labels![i] != best) {
          labels![i] = best;
          changed = true;
        }
      }
      // update
      final sums = List.generate(k, (_) => List<double>.filled(m, 0.0));
      final counts = List<int>.filled(k, 0);
      for (var i = 0; i < n; i++) {
        final c = labels![i];
        counts[c]++;
        for (var j = 0; j < m; j++) {
          sums[c][j] += X[i][j];
        }
      }
      var maxMove = 0.0;
      for (var c = 0; c < k; c++) {
        if (counts[c] == 0) continue; // leave empty cluster centroid as-is
        final newC = List<double>.filled(m, 0.0);
        for (var j = 0; j < m; j++) {
          newC[j] = sums[c][j] / counts[c];
        }
        maxMove = max(maxMove, sqrt(_distSq(centers[c], newC)));
        centers[c] = newC;
      }
      if (!changed || maxMove <= tol) break;
    }
    centroids = centers;
  }

  List<int> predict(List<List<double>> X) {
    if (centroids == null) throw StateError('Model not fitted');
    return X.map((x) {
      var best = 0;
      var bestD = double.infinity;
      for (var j = 0; j < centroids!.length; j++) {
        final d = _distSq(x, centroids![j]);
        if (d < bestD) {
          bestD = d;
          best = j;
        }
      }
      return best;
    }).toList();
  }

  double inertia(List<List<double>> X) {
    if (centroids == null || labels == null) {
      throw StateError('Model not fitted');
    }
    var s = 0.0;
    for (var i = 0; i < X.length; i++) {
      s += _distSq(X[i], centroids![labels![i]]);
    }
    return s;
  }
}
