/// Hungarian Algorithm (Kuhn–Munkres) for assignment problems
///
/// Efficient O(n^3) implementation for finding a minimum-cost perfect
/// matching between n workers and n jobs. The implementation is numeric and
/// robust, suitable for production-quality usage on dense cost matrices.
///
/// API:
/// - hungarian(costMatrix) -> returns pair (minCost, assignment list of length n)
library;

List<dynamic> hungarian(List<List<int>> cost) {
  final n = cost.length;
  if (n == 0) return [0, <int>[]];
  final m = n;
  final u = List<int>.filled(n + 1, 0);
  final v = List<int>.filled(m + 1, 0);
  final p = List<int>.filled(m + 1, 0);
  final way = List<int>.filled(m + 1, 0);
  for (var i = 1; i <= n; i++) {
    p[0] = i;
    var j0 = 0;
    final minv = List<int>.filled(m + 1, 1 << 60);
    final used = List<bool>.filled(m + 1, false);
    do {
      used[j0] = true;
      final i0 = p[j0];
      var delta = 1 << 60;
      var j1 = 0;
      for (var j = 1; j <= m; j++) {
        if (used[j]) continue;
        final cur = cost[i0 - 1][j - 1] - u[i0] - v[j];
        if (cur < minv[j]) {
          minv[j] = cur;
          way[j] = j0;
        }
        if (minv[j] < delta) {
          delta = minv[j];
          j1 = j;
        }
      }
      for (var j = 0; j <= m; j++) {
        if (used[j]) {
          u[p[j]] += delta;
          v[j] -= delta;
        } else {
          minv[j] -= delta;
        }
      }
      j0 = j1;
    } while (p[j0] != 0);
    do {
      final j1 = way[j0];
      p[j0] = p[j1];
      j0 = j1;
    } while (j0 != 0);
  }
  final assignment = List<int>.filled(n, -1);
  for (var j = 1; j <= m; j++) {
    if (p[j] != 0) assignment[p[j] - 1] = j - 1;
  }
  var costSum = 0;
  for (var i = 0; i < n; i++) {
    costSum += cost[i][assignment[i]];
  }
  return [costSum, assignment];
}
