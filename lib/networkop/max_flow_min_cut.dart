/// Maximum Flow (Dinic) and Minimum s-t Cut utilities
///
/// High-performance Dinic implementation with level graph and blocking flow.
/// Designed for reproducible, deterministic runs and clear, auditable
/// behavior suitable for benchmarks and production simulations.
///
/// API:
/// - Dinic(n) where n is the number of integer vertices [0..n-1]
/// - addEdge(u,v,capacity)
/// - maxFlow(s,t) -> returns numeric max flow
/// - minCut(s) -> returns Set<int> reachable from s in residual graph
library;

class _Edge {
  final int to;
  int rev;
  int cap;
  // original capacity (useful for resets and diagnostics)
  int origCap;
  // current flow on this directed edge (flow from this edge's owner -> to)
  int flow = 0;

  _Edge(this.to, this.rev, this.cap) : origCap = cap;
}

class Dinic {
  final int n;
  final List<List<_Edge>> _g;
  late List<int> level;
  late List<int> it;

  Dinic(this.n) : _g = List.generate(n, (_) => <_Edge>[]) {
    level = List<int>.filled(n, -1);
    it = List<int>.filled(n, 0);
  }

  void addEdge(int u, int v, int cap) {
    if (u < 0 || u >= n || v < 0 || v >= n) {
      throw ArgumentError('vertex out of range');
    }
    final a = _Edge(v, _g[v].length, cap);
    final b = _Edge(u, _g[u].length, 0);
    _g[u].add(a);
    _g[v].add(b);
  }

  /// Convenience: add an undirected edge (capacity on both directions).
  void addUndirectedEdge(int u, int v, int cap) {
    if (u < 0 || u >= n || v < 0 || v >= n) {
      throw ArgumentError('vertex out of range');
    }
    // For undirected edges we add two directed edges with the same capacity.
    final a = _Edge(v, _g[v].length, cap);
    final b = _Edge(u, _g[u].length, cap);
    _g[u].add(a);
    _g[v].add(b);
  }

  bool _bfs(int s, int t) {
    for (var i = 0; i < n; i++) {
      level[i] = -1;
    }
    final q = <int>[];
    q.add(s);
    level[s] = 0;
    for (var idx = 0; idx < q.length; idx++) {
      final v = q[idx];
      for (var e in _g[v]) {
        if (e.cap > 0 && level[e.to] < 0) {
          level[e.to] = level[v] + 1;
          q.add(e.to);
        }
      }
    }
    return level[t] >= 0;
  }

  int _dfs(int v, int t, int f) {
    if (v == t) return f;
    for (var i = it[v]; i < _g[v].length; i++, it[v] = i) {
      final e = _g[v][i];
      if (e.cap > 0 && level[v] < level[e.to]) {
        final d = _dfs(e.to, t, f < e.cap ? f : e.cap);
        if (d > 0) {
          e.cap -= d;
          _g[e.to][e.rev].cap += d;
          // update flow bookkeeping
          e.flow += d;
          _g[e.to][e.rev].flow -= d;
          return d;
        }
      }
    }
    return 0;
  }

  int maxFlow(int s, int t) {
    if (s < 0 || s >= n || t < 0 || t >= n) {
      throw ArgumentError('vertex out of range');
    }
    var flow = 0;
    while (_bfs(s, t)) {
      for (var i = 0; i < n; i++) {
        it[i] = 0;
      }
      while (true) {
        final f = _dfs(s, t, 1 << 60);
        if (f == 0) break;
        flow += f;
      }
    }
    return flow;
  }

  /// Dinic with capacity scaling: can be faster on graphs with large capacities.
  int maxFlowScaling(int s, int t) {
    // find max capacity
    var maxC = 0;
    for (var u = 0; u < n; u++) {
      for (var e in _g[u]) {
        if (e.origCap > maxC) maxC = e.origCap;
      }
    }
    if (maxC == 0) return 0;
    // highest power of two <= maxC
    var scale = 1;
    while (scale <= maxC) {
      scale <<= 1;
    }
    scale >>= 1;

    var flow = 0;
    while (scale > 0) {
      // blocking flows considering only edges with cap >= scale
      bool progressed = true;
      while (progressed) {
        progressed = false;
        if (!_bfsThreshold(s, t, scale)) break;
        for (var i = 0; i < n; i++) {
          it[i] = 0;
        }
        while (true) {
          final f = _dfsThreshold(s, t, 1 << 60, scale);
          if (f == 0) break;
          flow += f;
          progressed = true;
        }
      }
      scale >>= 1;
    }
    return flow;
  }

  bool _bfsThreshold(int s, int t, int threshold) {
    for (var i = 0; i < n; i++) {
      level[i] = -1;
    }
    final q = <int>[];
    q.add(s);
    level[s] = 0;
    for (var idx = 0; idx < q.length; idx++) {
      final v = q[idx];
      for (var e in _g[v]) {
        if (e.cap >= threshold && level[e.to] < 0) {
          level[e.to] = level[v] + 1;
          q.add(e.to);
        }
      }
    }
    return level[t] >= 0;
  }

  int _dfsThreshold(int v, int t, int f, int threshold) {
    if (v == t) return f;
    for (var i = it[v]; i < _g[v].length; i++, it[v] = i) {
      final e = _g[v][i];
      if (e.cap >= threshold && level[v] < level[e.to]) {
        final d = _dfsThreshold(e.to, t, f < e.cap ? f : e.cap, threshold);
        if (d > 0) {
          e.cap -= d;
          _g[e.to][e.rev].cap += d;
          e.flow += d;
          _g[e.to][e.rev].flow -= d;
          return d;
        }
      }
    }
    return 0;
  }

  /// After a maxFlow run, decompose the resulting flow into simple s->t paths
  /// with positive flow. Returns list of maps { 'path': List<int>, 'flow': int }.
  List<Map<String, dynamic>> flowDecomposition(int s, int t) {
    // build mutable remaining flow per edge index
    final rem = List<List<int>>.generate(
      n,
      (u) => List<int>.filled(_g[u].length, 0),
    );
    for (var u = 0; u < n; u++) {
      for (var i = 0; i < _g[u].length; i++) {
        rem[u][i] = _g[u][i].flow > 0 ? _g[u][i].flow : 0;
      }
    }
    final List<Map<String, dynamic>> paths = [];
    while (true) {
      // find path using edges with rem > 0
      final parent = List<int>.filled(n, -1);
      final parentEdge = List<int>.filled(n, -1);
      final q = <int>[s];
      parent[s] = s;
      for (var idx = 0; idx < q.length; idx++) {
        final u = q[idx];
        for (var ei = 0; ei < _g[u].length; ei++) {
          if (rem[u][ei] > 0) {
            final v = _g[u][ei].to;
            if (parent[v] == -1) {
              parent[v] = u;
              parentEdge[v] = ei;
              q.add(v);
              if (v == t) break;
            }
          }
        }
        if (parent[t] != -1) break;
      }
      if (parent[t] == -1) break;
      // find bottleneck
      var addf = 1 << 60;
      var v = t;
      while (v != s) {
        final u = parent[v];
        final ei = parentEdge[v];
        addf = addf < rem[u][ei] ? addf : rem[u][ei];
        v = u;
      }
      // record path
      var path = <int>[];
      v = t;
      while (v != s) {
        final u = parent[v];
        final ei = parentEdge[v];
        rem[u][ei] -= addf;
        path.add(v);
        v = u;
      }
      path.add(s);
      path = path.reversed.toList();
      paths.add({'path': path, 'flow': addf});
    }
    return paths;
  }

  /// After `maxFlow`, returns vertices reachable from `s` in residual graph.
  Set<int> minCut(int s) {
    final visited = <int>{};
    final stack = [s];
    while (stack.isNotEmpty) {
      final v = stack.removeLast();
      if (visited.contains(v)) continue;
      visited.add(v);
      for (var e in _g[v]) {
        if (e.cap > 0 && !visited.contains(e.to)) stack.add(e.to);
      }
    }
    return visited;
  }
}
