/// Minimum-Cost Maximum Flow (Successive Shortest Path with potentials)
///
/// Production-minded successive shortest path implementation using
/// Johnson-style potentials and Dijkstra with potentials for efficiency.
/// Provides deterministic, auditable operations with clear error handling.
///
/// API:
/// - MinCostFlow(n)
/// - addEdge(u,v,cap,cost)
/// - minCostMaxFlow(s,t,maxf) -> returns (flow, cost)
library;

class _HeapEntry {
  final int dist;
  final int v;
  _HeapEntry(this.dist, this.v);
}

class _MinHeap {
  final List<_HeapEntry> _data = [];

  bool get isEmpty => _data.isEmpty;

  void add(int dist, int v) {
    _data.add(_HeapEntry(dist, v));
    var i = _data.length - 1;
    while (i > 0) {
      final p = (i - 1) >> 1;
      if (_data[p].dist <= _data[i].dist) break;
      final tmp = _data[p];
      _data[p] = _data[i];
      _data[i] = tmp;
      i = p;
    }
  }

  _HeapEntry pop() {
    final res = _data.first;
    final last = _data.removeLast();
    if (_data.isEmpty) return res;
    _data[0] = last;
    var i = 0;
    while (true) {
      var l = i * 2 + 1;
      var r = l + 1;
      if (l >= _data.length) break;
      var m = l;
      if (r < _data.length && _data[r].dist < _data[l].dist) m = r;
      if (_data[i].dist <= _data[m].dist) break;
      final tmp = _data[i];
      _data[i] = _data[m];
      _data[m] = tmp;
      i = m;
    }
    return res;
  }
}

class MCFEdge {
  final int to;
  int rev;
  int cap;
  int cost;
  MCFEdge(this.to, this.rev, this.cap, this.cost);
}

class MinCostFlow {
  final int n;
  final List<List<MCFEdge>> g;
  MinCostFlow(this.n) : g = List.generate(n, (_) => []);

  void addEdge(int u, int v, int cap, int cost) {
    g[u].add(MCFEdge(v, g[v].length, cap, cost));
    g[v].add(MCFEdge(u, g[u].length - 1, 0, -cost));
  }

  Map<String, int> minCostMaxFlow(int s, int t, int maxf) {
    final inf = 1 << 60;
    var flow = 0;
    var cost = 0;
    final pot = List<int>.filled(n, 0);
    final dist = List<int>.filled(n, 0);
    final prevv = List<int>.filled(n, -1);
    final preve = List<int>.filled(n, -1);

    while (flow < maxf) {
      // Dijkstra with potentials
      for (var i = 0; i < n; i++) {
        dist[i] = inf;
      }
      dist[s] = 0;
      // Small in-file min-heap to avoid bringing additional dependencies.
      final heap = _MinHeap();
      heap.add(0, s);
      while (!heap.isEmpty) {
        final cur = heap.pop();
        final d = cur.dist;
        final v = cur.v;
        if (dist[v] < d) continue;
        for (var i = 0; i < g[v].length; i++) {
          final e = g[v][i];
          if (e.cap > 0 && dist[e.to] > dist[v] + e.cost + pot[v] - pot[e.to]) {
            dist[e.to] = dist[v] + e.cost + pot[v] - pot[e.to];
            prevv[e.to] = v;
            preve[e.to] = i;
            heap.add(dist[e.to], e.to);
          }
        }
      }
      if (dist[t] == inf) break;
      for (var v = 0; v < n; v++) {
        if (dist[v] < inf) pot[v] += dist[v];
      }
      var addf = maxf - flow;
      var v = t;
      while (v != s) {
        addf =
            addf < g[prevv[v]][preve[v]].cap ? addf : g[prevv[v]][preve[v]].cap;
        v = prevv[v];
      }
      flow += addf;
      v = t;
      while (v != s) {
        final e = g[prevv[v]][preve[v]];
        e.cap -= addf;
        g[v][e.rev].cap += addf;
        cost += addf * e.cost;
        v = prevv[v];
      }
    }
    return {'flow': flow, 'cost': cost};
  }
}
