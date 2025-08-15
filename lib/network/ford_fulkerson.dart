/// 🌊 Ford-Fulkerson Algorithm (Maximum Flow)
///
/// Computes the maximum flow from source to sink in a flow network using
/// the Ford-Fulkerson method with depth-first search for finding augmenting paths.
///
/// - **Time Complexity**: O(VE²) where V is vertices, E is edges
/// - **Space Complexity**: O(V²) for residual graph storage
/// - **Optimality**: Guaranteed to find maximum flow
/// - **Completeness**: Always terminates for integer capacities
///
/// The algorithm works by finding augmenting paths in the residual graph and
/// pushing flow along these paths until no more augmenting paths exist.
///
/// Example:
/// ```dart
/// final graph = <String, Map<String, num>>{
///   'S': {'A': 10, 'B': 10},
///   'A': {'B': 2, 'T': 8},
///   'B': {'T': 10},
///   'T': {},
/// };
/// final maxFlow = fordFulkerson(graph, 'S', 'T');
/// // Result: 18 (maximum flow from S to T)
/// ```
library;

/// Represents a flow network edge with capacity and flow
class FlowEdge<T> {
  final T source;
  final T target;
  final num capacity;
  num flow;

  FlowEdge(this.source, this.target, this.capacity) : flow = 0;

  /// Returns the residual capacity (remaining capacity)
  num get residualCapacity => capacity - flow;

  /// Returns the reverse edge for residual graph
  FlowEdge<T> get reverse => FlowEdge<T>(target, source, 0)..flow = -flow;

  /// Adds flow to this edge
  void addFlow(num delta) {
    flow += delta;
  }

  @override
  String toString() => 'FlowEdge($source -> $target: $flow/$capacity)';
}

/// Ford-Fulkerson maximum flow algorithm implementation
///
/// [graph] represents the flow network as adjacency list with edge capacities
/// [source] is the source node
/// [sink] is the sink/target node
///
/// Returns the maximum flow value from source to sink.
///
/// Throws [ArgumentError] if source or sink nodes don't exist in the graph.
num fordFulkerson<T>(Map<T, Map<T, num>> graph, T source, T sink) {
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

  // Build flow network with FlowEdge objects
  final flowNetwork = <T, List<FlowEdge<T>>>{};
  final edgeMap = <String, FlowEdge<T>>{};

  for (final entry in graph.entries) {
    final from = entry.key;
    final neighbors = entry.value;

    flowNetwork[from] = <FlowEdge<T>>[];

    for (final neighborEntry in neighbors.entries) {
      final to = neighborEntry.key;
      final capacity = neighborEntry.value;

      if (capacity > 0) {
        final edge = FlowEdge<T>(from, to, capacity);
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
        final reverseEdge = FlowEdge<T>(edge.target, edge.source, 0);
        flowNetwork[edge.target] ??= <FlowEdge<T>>[];
        flowNetwork[edge.target]!.add(reverseEdge);
        edgeMap[reverseKey] = reverseEdge;
      }
    }
  }

  num maxFlow = 0;

  // Find augmenting paths and push flow
  while (true) {
    final path = _findAugmentingPath(flowNetwork, source, sink);
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

/// Finds an augmenting path using depth-first search
List<T> _findAugmentingPath<T>(
  Map<T, List<FlowEdge<T>>> flowNetwork,
  T source,
  T sink,
) {
  final visited = <T>{};
  final parent = <T, T>{};
  final parentEdge = <T, FlowEdge<T>>{};

  final stack = <T>[source];
  visited.add(source);

  while (stack.isNotEmpty) {
    final current = stack.removeLast();

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
        parentEdge[edge.target] = edge;
        stack.add(edge.target);
      }
    }
  }

  return []; // No augmenting path found
}

/// Finds an edge between two nodes in the flow network
FlowEdge<T>? _findEdge<T>(Map<T, List<FlowEdge<T>>> flowNetwork, T from, T to) {
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

/// Ford-Fulkerson with detailed flow information
///
/// Returns both the maximum flow value and the flow network with final flow values
class FordFulkersonResult<T> {
  final num maxFlow;
  final Map<T, List<FlowEdge<T>>> flowNetwork;

  const FordFulkersonResult({required this.maxFlow, required this.flowNetwork});

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
}

FordFulkersonResult<T> fordFulkersonDetailed<T>(
  Map<T, Map<T, num>> graph,
  T source,
  T sink,
) {
  // Build flow network
  final flowNetwork = <T, List<FlowEdge<T>>>{};
  final edgeMap = <String, FlowEdge<T>>{};

  for (final entry in graph.entries) {
    final from = entry.key;
    final neighbors = entry.value;

    flowNetwork[from] = <FlowEdge<T>>[];

    for (final neighborEntry in neighbors.entries) {
      final to = neighborEntry.key;
      final capacity = neighborEntry.value;

      if (capacity > 0) {
        final edge = FlowEdge<T>(from, to, capacity);
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
        final reverseEdge = FlowEdge<T>(edge.target, edge.source, 0);
        flowNetwork[edge.target] ??= <FlowEdge<T>>[];
        flowNetwork[edge.target]!.add(reverseEdge);
        edgeMap[reverseKey] = reverseEdge;
      }
    }
  }

  num maxFlow = 0;

  // Find augmenting paths and push flow
  while (true) {
    final path = _findAugmentingPath(flowNetwork, source, sink);
    if (path.isEmpty) break;

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

  return FordFulkersonResult<T>(maxFlow: maxFlow, flowNetwork: flowNetwork);
}
