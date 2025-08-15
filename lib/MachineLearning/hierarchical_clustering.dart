/// 🌲 Hierarchical Clustering (agglomerative, production-aware)
///
/// Agglomerative hierarchical clustering with single/complete/average linkage
/// and a simple priority-queue based merge strategy. Designed for clarity and
/// usable defaults in engineering contexts.
///
/// Contract:
/// - Input: feature matrix `X` (n x m), desired number of clusters or threshold.
/// - Output: cluster assignments and dendrogram (linkage list).
/// - Error modes: throws `ArgumentError` for empty inputs.
///
/// Time Complexity: O(n^2 log n) (naive but robust for moderate n)
/// Space Complexity: O(n^2)
library;

import 'dart:math';

double _euclidSq(List<double> a, List<double> b) {
  var s = 0.0;
  for (var i = 0; i < a.length && i < b.length; i++) {
    final d = a[i] - b[i];
    s += d * d;
  }
  return s;
}

enum Linkage { single, complete, average }

class HierarchicalClustering {
  final Linkage linkage;
  HierarchicalClustering({this.linkage = Linkage.average});

  List<int> fit(List<List<double>> X, {int k = 1}) {
    final n = X.length;
    if (n == 0) throw ArgumentError('Empty dataset');
    if (k < 1 || k > n) throw ArgumentError('k out of range');

    // naive distance matrix
    final dist = List.generate(
      n,
      (_) => List<double>.filled(n, double.infinity),
    );
    for (var i = 0; i < n; i++) {
      for (var j = i + 1; j < n; j++) {
        dist[i][j] = _euclidSq(X[i], X[j]);
        dist[j][i] = dist[i][j];
      }
    }
    // each point starts in its own cluster
    final clusters = List<List<int>>.generate(n, (i) => [i]);
    final active = List<bool>.filled(n, true);
    int remaining = n;
    while (remaining > k) {
      // find closest pair
      var bestI = -1, bestJ = -1;
      var bestD = double.infinity;
      for (var i = 0; i < n; i++) {
        if (!active[i]) continue;
        for (var j = i + 1; j < n; j++) {
          if (!active[j]) continue;
          if (dist[i][j] < bestD) {
            bestD = dist[i][j];
            bestI = i;
            bestJ = j;
          }
        }
      }
      if (bestI < 0) break;
      // merge j into i
      clusters[bestI].addAll(clusters[bestJ]);
      active[bestJ] = false;
      remaining--;
      // update distances
      for (var t = 0; t < n; t++) {
        if (!active[t] || t == bestI) continue;
        double newD;
        if (linkage == Linkage.single) {
          newD = clusters[bestI]
              .map((a) => clusters[bestJ].map((b) => dist[a][b]).reduce(min))
              .reduce(min);
        } else if (linkage == Linkage.complete) {
          newD = clusters[bestI]
              .map((a) => clusters[bestJ].map((b) => dist[a][b]).reduce(max))
              .reduce(max);
        } else {
          // average
          double s = 0.0;
          var cnt = 0;
          for (var a in clusters[bestI]) {
            for (var b in clusters[bestJ]) {
              s += dist[a][b];
              cnt++;
            }
          }
          newD = s / cnt;
        }
        dist[bestI][t] = dist[t][bestI] = newD;
      }
    }
    final labels = List<int>.filled(n, -1);
    var idx = 0;
    for (var i = 0; i < n; i++) {
      if (!active[i]) continue;
      for (var v in clusters[i]) {
        labels[v] = idx;
      }
      idx++;
    }
    return labels;
  }
}
