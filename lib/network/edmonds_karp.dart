/// 🚀 Edmonds-Karp Algorithm (Improved Maximum Flow)
///
/// An optimized version of Ford-Fulkerson that uses breadth-first search (BFS)
/// to find shortest augmenting paths, ensuring polynomial time complexity.
///
/// - **Time Complexity**: O(VE²) where V is vertices, E is edges
/// - **Space Complexity**: O(V²) for residual graph storage
/// - **Optimality**: Guaranteed to find maximum flow
/// - **Completeness**: Always terminates in polynomial time
/// - **Advantage**: BFS ensures shortest augmenting paths, leading to fewer iterations
///
/// The algorithm improves upon Ford-Fulkerson by always selecting the shortest
/// augmenting path, which guarantees polynomial time complexity and better performance
/// in practice.
///
/// Example:
/// ```dart
/// final graph = <String, Map<String, num>>{
///   'S': {'A': 10, 'B': 10},
///   'A': {'B': 2, 'T': 8},
///   'B': {'T': 10},
///   'T': {},
/// };
/// final maxFlow = edmondsKarp(graph, 'S', 'T');
/// // Result: 18 (maximum flow from S to T)
/// ```
library;

import 'dart:collection';

/// Represents a flow network edge with capacity and flow
class EdmondsKarpEdge<T> {
  final T source;
  final T target;
  final num capacity;
  num flow;

  EdmondsKarpEdge(this.source, this.target, this.capacity) : flow = 0;

  /// Returns the residual capacity (remaining capacity)
  num get residualCapacity => capacity - flow;

  /// Returns the reverse edge for residual graph
  EdmondsKarpEdge<T> get reverse =>
      EdmondsKarpEdge<T>(target, source, 0)..flow = -flow;

  /// Adds flow to this edge
  void addFlow(num delta) {
    flow += delta;
  }

  @override
  String toString() => 'EdmondsKarpEdge($source -> $target: $flow/$capacity)';
}

/// Edmonds-Karp maximum flow algorithm implementation
///
/// [graph] represents the flow network as adjacency list with edge capacities
/// [source] is the source node
/// [sink] is the sink/target node
///
/// Returns the maximum flow value from source to sink.
///
/// Throws [ArgumentError] if source or sink nodes don't exist in the graph.
num edmondsKarp<T>(Map<T, Map<T, num>> graph, T source, T sink) {
  // Input validation
  if (!graph.containsKey(source)) {
    throw ArgumentError('Source node $source not found in graph');
  }
  if (!graph.containsKey(sink)) {
    throw ArgumentError('Sink node $sink not found in graph');
  }
  if (source == sink) {
    throw ArgumentError('Source and sink cannot be the same node');
  }

  // Build flow network with EdmondsKarpEdge objects
  final flowNetwork = <T, List<EdmondsKarpEdge<T>>>{};
  final edgeMap = <String, EdmondsKarpEdge<T>>{};

  for (final entry in graph.entries) {
    final from = entry.key;
    final neighbors = entry.value;

    flowNetwork[from] = <EdmondsKarpEdge<T>>[];

    for (final neighborEntry in neighbors.entries) {
      final to = neighborEntry.key;
      final capacity = neighborEntry.value;

      if (capacity > 0) {
        final edge = EdmondsKarpEdge<T>(from, to, capacity);
        flowNetwork[from]!.add(edge);

        // Store edge for reverse edge creation
        final edgeKey = '${from}_$to';
        edgeMap[edgeKey] = edge;
      }
    }
  }

  // Add reverse edges for residual graph
  for (final edges in flowNetwork.values) {
    for (final edge in edges) {
      final reverseKey = '${edge.target}_${edge.source}';
      if (!edgeMap.containsKey(reverseKey)) {
        final reverseEdge = EdmondsKarpEdge<T>(edge.target, edge.source, 0);
        flowNetwork[edge.target] ??= <EdmondsKarpEdge<T>>[];
        flowNetwork[edge.target]!.add(reverseEdge);
        edgeMap[reverseKey] = reverseEdge;
      }
    }
  }

  num maxFlow = 0;

  // Find augmenting paths using BFS and push flow
  while (true) {
    final path = _findShortestAugmentingPath(flowNetwork, source, sink);
    if (path.isEmpty) break;

    // Find bottleneck capacity along the path
    num bottleneck = double.infinity;
    for (int i = 0; i < path.length - 1; i++) {
      final current = path[i];
      final next = path[i + 1];
      final edge = _findEdge(flowNetwork, current, next);
      if (edge != null) {
        bottleneck = min(bottleneck, edge.residualCapacity);
      }
    }

    // Push flow along the path
    for (int i = 0; i < path.length - 1; i++) {
      final current = path[i];
      final next = path[i + 1];

      // Forward edge
      final forwardEdge = _findEdge(flowNetwork, current, next);
      if (forwardEdge != null) {
        forwardEdge.addFlow(bottleneck);
      }

      // Reverse edge
      final reverseEdge = _findEdge(flowNetwork, next, current);
      if (reverseEdge != null) {
        reverseEdge.addFlow(-bottleneck);
      }
    }

    maxFlow += bottleneck;
  }

  return maxFlow;
}

/// Finds the shortest augmenting path using breadth-first search
///
/// This is the key improvement over Ford-Fulkerson - BFS ensures we always
/// find the shortest augmenting path, leading to better performance.
List<T> _findShortestAugmentingPath<T>(
  Map<T, List<EdmondsKarpEdge<T>>> flowNetwork,
  T source,
  T sink,
) {
  final visited = <T>{};
  final parent = <T, T>{};
  final queue = Queue<T>();

  queue.add(source);
  visited.add(source);

  while (queue.isNotEmpty) {
    final current = queue.removeFirst();

    if (current == sink) {
      // Reconstruct path
      final path = <T>[sink];
      var node = sink;
      while (parent.containsKey(node)) {
        node = parent[node] as T;
        path.insert(0, node);
      }
      return path;
    }

    final edges = flowNetwork[current] ?? [];
    for (final edge in edges) {
      if (edge.residualCapacity > 0 && !visited.contains(edge.target)) {
        visited.add(edge.target);
        parent[edge.target] = current;
        queue.add(edge.target);
      }
    }
  }

  return []; // No augmenting path found
}

/// Finds an edge between two nodes in the flow network
EdmondsKarpEdge<T>? _findEdge<T>(
  Map<T, List<EdmondsKarpEdge<T>>> flowNetwork,
  T from,
  T to,
) {
  final edges = flowNetwork[from] ?? [];
  for (final edge in edges) {
    if (edge.target == to) {
      return edge;
    }
  }
  return null;
}

/// Utility function for finding minimum of two numbers
T min<T extends num>(T a, T b) => a < b ? a : b;

/// Edmonds-Karp with detailed flow information and path analysis
///
/// Returns the maximum flow value, flow network, and analysis of augmenting paths
class EdmondsKarpResult<T> {
  final num maxFlow;
  final Map<T, List<EdmondsKarpEdge<T>>> flowNetwork;
  final int augmentingPathsCount;
  final List<List<T>> augmentingPaths;

  const EdmondsKarpResult({
    required this.maxFlow,
    required this.flowNetwork,
    required this.augmentingPathsCount,
    required this.augmentingPaths,
  });

  /// Gets the flow value on a specific edge
  num getFlow(T from, T to) {
    final edge = _findEdge(flowNetwork, from, to);
    return edge?.flow ?? 0;
  }

  /// Gets all edges with their flow values
  Map<String, num> getAllFlows() {
    final flows = <String, num>{};
    for (final edges in flowNetwork.values) {
      for (final edge in edges) {
        if (edge.capacity > 0) {
          // Only original edges, not reverse edges
          final key = '${edge.source}->${edge.target}';
          flows[key] = edge.flow;
        }
      }
    }
    return flows;
  }

  /// Gets the average path length of augmenting paths
  double get averagePathLength {
    if (augmentingPaths.isEmpty) return 0.0;
    final totalLength = augmentingPaths.fold<int>(
      0,
      (sum, path) => sum + path.length,
    );
    return totalLength / augmentingPaths.length;
  }
}

EdmondsKarpResult<T> edmondsKarpDetailed<T>(
  Map<T, Map<T, num>> graph,
  T source,
  T sink,
) {
  // Build flow network
  final flowNetwork = <T, List<EdmondsKarpEdge<T>>>{};
  final edgeMap = <String, EdmondsKarpEdge<T>>{};

  for (final entry in graph.entries) {
    final from = entry.key;
    final neighbors = entry.value;

    flowNetwork[from] = <EdmondsKarpEdge<T>>[];

    for (final neighborEntry in neighbors.entries) {
      final to = neighborEntry.key;
      final capacity = neighborEntry.value;

      if (capacity > 0) {
        final edge = EdmondsKarpEdge<T>(from, to, capacity);
        flowNetwork[from]!.add(edge);
        edgeMap['${from}_$to'] = edge;
      }
    }
  }

  // Add reverse edges
  for (final edges in flowNetwork.values) {
    for (final edge in edges) {
      final reverseKey = '${edge.target}_${edge.source}';
      if (!edgeMap.containsKey(reverseKey)) {
        final reverseEdge = EdmondsKarpEdge<T>(edge.target, edge.source, 0);
        flowNetwork[edge.target] ??= <EdmondsKarpEdge<T>>[];
        flowNetwork[edge.target]!.add(reverseEdge);
        edgeMap[reverseKey] = reverseEdge;
      }
    }
  }

  num maxFlow = 0;
  final augmentingPaths = <List<T>>[];

  // Find augmenting paths using BFS and push flow
  while (true) {
    final path = _findShortestAugmentingPath(flowNetwork, source, sink);
    if (path.isEmpty) break;

    augmentingPaths.add(List<T>.from(path));

    // Find bottleneck capacity along the path
    num bottleneck = double.infinity;
    for (int i = 0; i < path.length - 1; i++) {
      final current = path[i];
      final next = path[i + 1];
      final edge = _findEdge(flowNetwork, current, next);
      if (edge != null) {
        bottleneck = min(bottleneck, edge.residualCapacity);
      }
    }

    // Push flow along the path
    for (int i = 0; i < path.length - 1; i++) {
      final current = path[i];
      final next = path[i + 1];

      final forwardEdge = _findEdge(flowNetwork, current, next);
      if (forwardEdge != null) {
        forwardEdge.addFlow(bottleneck);
      }

      final reverseEdge = _findEdge(flowNetwork, next, current);
      if (reverseEdge != null) {
        reverseEdge.addFlow(-bottleneck);
      }
    }

    maxFlow += bottleneck;
  }

  return EdmondsKarpResult<T>(
    maxFlow: maxFlow,
    flowNetwork: flowNetwork,
    augmentingPathsCount: augmentingPaths.length,
    augmentingPaths: augmentingPaths,
  );
}
