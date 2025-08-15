/// 🌿 Prim's Algorithm (Minimum Spanning Tree/Forest)
///
/// Builds an MST by growing a frontier from an arbitrary start node, always
/// picking the lowest-weight edge crossing the cut.
///
/// - Input: undirected weighted graph adjacency list
/// - Time complexity (simple frontier list): O(E log E) worst, O(E·log E) due to sorting
/// - Space complexity: O(V + E)
///
/// Returns a list of edges in the MST (or MSF for disconnected graphs).
library;

import 'weighted_edge.dart';

List<WeightedEdge<T>> primMST<T>(Map<T, List<WeightedEdge<T>>> graph) {
  final Set<T> allNodes = {...graph.keys};
  for (final edges in graph.values) {
    for (final e in edges) {
      allNodes.add(e.source);
      allNodes.add(e.target);
    }
  }

  final Set<T> visited = <T>{};
  final List<WeightedEdge<T>> mst = [];

  void processComponent(T start) {
    visited.add(start);
    final List<WeightedEdge<T>> frontier = <WeightedEdge<T>>[
      ...(graph[start] ?? <WeightedEdge<T>>[]),
    ];

    while (frontier.isNotEmpty) {
      frontier.sort((a, b) => a.weight.compareTo(b.weight));
      final edge = frontier.removeAt(0);
      final T v = visited.contains(edge.source) ? edge.target : edge.source;
      if (visited.contains(v)) continue;
      visited.add(v);
      mst.add(edge);
      for (final e in graph[v] ?? <WeightedEdge<T>>[]) {
        final T next = visited.contains(e.source) ? e.target : e.source;
        if (!visited.contains(next)) frontier.add(e);
      }
    }
  }

  for (final n in allNodes) {
    if (!visited.contains(n)) {
      processComponent(n);
    }
  }
  return mst;
}
