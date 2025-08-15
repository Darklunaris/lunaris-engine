/// 🌊 DBSCAN (Density-Based Spatial Clustering of Applications with Noise)
///
/// A simple DBSCAN implementation with eps-neighborhood and minPts parameters.
/// Marks noise points with label -1 and returns cluster labels for each point.
///
/// Contract:
/// - Input: X (n x m), eps (distance threshold), minPts.
/// - Output: List<int> labels where -1 denotes noise.
/// - Error: throws ArgumentError on invalid input.
///
/// Time Complexity: O(n^2) naive neighborhood search
/// Space Complexity: O(n)
library;

double _distSq(List<double> a, List<double> b) {
  var s = 0.0;
  for (var i = 0; i < a.length && i < b.length; i++) {
    final d = a[i] - b[i];
    s += d * d;
  }
  return s;
}

class DBSCAN {
  final double eps;
  final int minPts;
  DBSCAN({this.eps = 0.5, this.minPts = 5}) {
    if (eps <= 0) throw ArgumentError('eps must be positive');
    if (minPts <= 0) throw ArgumentError('minPts must be positive');
  }

  List<int> fit(List<List<double>> X) {
    final n = X.length;
    if (n == 0) return [];
    final labels = List<int>.filled(n, 0);
    var clusterId = 0;
    final epsSq = eps * eps;
    for (var i = 0; i < n; i++) {
      if (labels[i] != 0) continue;
      final neigh = _regionQuery(X, i, epsSq);
      if (neigh.length < minPts) {
        labels[i] = -1; // noise
        continue;
      }
      clusterId++;
      labels[i] = clusterId;
      final seeds = List<int>.from(neigh.where((p) => p != i));
      while (seeds.isNotEmpty) {
        final cur = seeds.removeAt(0);
        if (labels[cur] == -1) labels[cur] = clusterId;
        if (labels[cur] != 0) continue;
        labels[cur] = clusterId;
        final curNeigh = _regionQuery(X, cur, epsSq);
        if (curNeigh.length >= minPts) {
          for (var p in curNeigh) {
            if (!seeds.contains(p)) seeds.add(p);
          }
        }
      }
    }
    return labels;
  }

  List<int> _regionQuery(List<List<double>> X, int i, double epsSq) {
    final res = <int>[];
    for (var j = 0; j < X.length; j++) {
      if (_distSq(X[i], X[j]) <= epsSq) res.add(j);
    }
    return res;
  }
}
