/// Edmonds' Blossom algorithm for maximum matching in general graphs
///
/// This implementation follows the classical Edmonds' blossom algorithm to
/// find a maximum cardinality matching in general (non-bipartite) graphs.
/// It is implemented for integer-labeled vertices [0..n-1] and is designed to
/// be clear, well-documented, and reasonably efficient for medium-sized graphs.
///
/// API:
/// - edmondsBlossom(n, adjacencyList) -> returns list `match` where match[v] = partner or -1
library;

List<int> edmondsBlossom(int n, List<List<int>> g) {
  final match = List<int>.filled(n, -1);
  final base = List<int>.generate(n, (i) => i);
  final p = List<int>.filled(n, -1);
  final q = List<int>.filled(n, 0);
  final used = List<bool>.filled(n, false);
  final blossom = List<bool>.filled(n, false);

  int lca(int a, int b) {
    final usedPath = List<bool>.filled(n, false);
    while (true) {
      a = base[a];
      usedPath[a] = true;
      if (match[a] == -1) break;
      a = p[match[a]];
    }
    while (true) {
      b = base[b];
      if (usedPath[b]) return b;
      b = p[match[b]];
    }
  }

  void markPath(int v, int b, int children) {
    while (base[v] != b) {
      blossom[base[v]] = blossom[base[match[v]]] = true;
      p[v] = children;
      children = match[v];
      v = p[match[v]];
    }
  }

  int findPath(int root) {
    used.fillRange(0, n, false);
    p.fillRange(0, n, -1);
    for (var i = 0; i < n; ++i) {
      base[i] = i;
    }
    var qh = 0, qt = 0;
    q[qt++] = root;
    used[root] = true;
    while (qh < qt) {
      final v = q[qh++];
      for (var to in g[v]) {
        if (base[v] == base[to] || match[v] == to) continue;
        if (to == root || (match[to] != -1 && p[match[to]] != -1)) {
          final curbase = lca(v, to);
          blossom.fillRange(0, n, false);
          markPath(v, curbase, to);
          markPath(to, curbase, v);
          for (var i = 0; i < n; ++i) {
            if (blossom[base[i]]) {
              base[i] = curbase;
              if (!used[i]) {
                used[i] = true;
                q[qt++] = i;
              }
            }
          }
        } else if (p[to] == -1) {
          p[to] = v;
          if (match[to] == -1) return to;
          var mt = match[to];
          to = mt;
          used[to] = true;
          q[qt++] = to;
        }
      }
    }
    return -1;
  }

  for (var i = 0; i < n; ++i) {
    if (match[i] == -1) {
      final v = findPath(i);
      if (v == -1) continue;
      var cur = v;
      while (cur != -1) {
        final pv = p[cur];
        final nv = match[pv];
        match[cur] = pv;
        match[pv] = cur;
        cur = nv;
      }
    }
  }
  return match;
}
