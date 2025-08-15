/// ⚡ Dinic's Algorithm (High-Performance Maximum Flow)
///
/// A highly efficient maximum flow algorithm that uses layered networks and
/// blocking flows to achieve superior performance for large networks.
///
/// - **Time Complexity**: O(V²E) where V is vertices, E is edges
/// - **Space Complexity**: O(V²) for layered network storage
/// - **Optimality**: Guaranteed to find maximum flow
/// - **Completeness**: Always terminates in polynomial time
/// - **Performance**: Significantly faster than Ford-Fulkerson and Edmonds-Karp
/// - **Best For**: Dense graphs and large networks
///
/// Dinic's algorithm works by building layered networks and finding blocking flows
/// in each layer, which dramatically reduces the number of augmenting paths needed.
///
/// Example:
/// ```dart
/// final graph = <String, Map<String, num>>{
///   'S': {'A': 10, 'B': 10},
///   'A': {'B': 2, 'T': 8},
///   'B': {'T': 10},
///   'T': {},
/// };
/// final maxFlow = dinicsAlgorithm(graph, 'S', 'T');
/// // Result: 18 (maximum flow from S to T)
/// ```
library;

import 'dart:collection';

/// Represents a flow network edge with capacity and flow
class DinicsEdge<T> {
  final T source;
  final T target;
  final num capacity;
  num flow;

  DinicsEdge(this.source, this.target, this.capacity) : flow = 0;

  /// Returns the residual capacity (remaining capacity)
  num get residualCapacity => capacity - flow;

  /// Returns the reverse edge for residual graph
  DinicsEdge<T> get reverse => DinicsEdge<T>(target, source, 0)..flow = -flow;

  /// Adds flow to this edge
  void addFlow(num delta) {
    flow += delta;
  }

  @override
  String toString() => 'DinicsEdge($source -> $target: $flow/$capacity)';
}

/// Represents a node in the layered network with its level
class LayeredNode<T> {
  final T node;
  final int level;

  const LayeredNode(this.node, this.level);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LayeredNode<T> &&
          runtimeType == other.runtimeType &&
          node == other.node &&
          level == other.level;

  @override
  int get hashCode => Object.hash(node, level);
}

/// Dinic's maximum flow algorithm implementation
///
/// [graph] represents the flow network as adjacency list with edge capacities
/// [source] is the source node
/// [sink] is the sink/target node
///
/// Returns the maximum flow value from source to sink.
///
/// Throws [ArgumentError] if source or sink nodes don't exist in the graph.
num dinicsAlgorithm<T>(Map<T, Map<T, num>> graph, T source, T sink) {
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

  // Build flow network with DinicsEdge objects
  final flowNetwork = <T, List<DinicsEdge<T>>>{};
  final edgeMap = <String, DinicsEdge<T>>{};

  for (final entry in graph.entries) {
    final from = entry.key;
    final neighbors = entry.value;

    flowNetwork[from] = <DinicsEdge<T>>[];

    for (final neighborEntry in neighbors.entries) {
      final to = neighborEntry.key;
      final capacity = neighborEntry.value;

      if (capacity > 0) {
        final edge = DinicsEdge<T>(from, to, capacity);
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
        final reverseEdge = DinicsEdge<T>(edge.target, edge.source, 0);
        flowNetwork[edge.target] ??= <DinicsEdge<T>>[];
        flowNetwork[edge.target]!.add(reverseEdge);
        edgeMap[reverseKey] = reverseEdge;
      }
    }
  }

  num maxFlow = 0;

  // Main Dinic's algorithm loop
  while (true) {
    // Build layered network using BFS
    final levels = _buildLayeredNetwork(flowNetwork, source, sink);
    if (levels[sink] == null) break; // No path exists

    // Find blocking flow in the layered network
    final blockingFlow = _findBlockingFlow(flowNetwork, source, sink, levels);
    if (blockingFlow == 0) break; // No more flow can be pushed

    maxFlow += blockingFlow;
  }

  return maxFlow;
}

/// Builds a layered network using breadth-first search
///
/// Returns a map from node to its level in the layered network
Map<T, int> _buildLayeredNetwork<T>(
  Map<T, List<DinicsEdge<T>>> flowNetwork,
  T source,
  T sink,
) {
  final levels = <T, int>{source: 0};
  final queue = Queue<T>();
  queue.add(source);

  while (queue.isNotEmpty) {
    final current = queue.removeFirst();
    final currentLevel = levels[current]!;

    if (current == sink) continue; // Don't explore beyond sink

    final edges = flowNetwork[current] ?? [];
    for (final edge in edges) {
      if (edge.residualCapacity > 0 && !levels.containsKey(edge.target)) {
        levels[edge.target] = currentLevel + 1;
        queue.add(edge.target);
      }
    }
  }

  return levels;
}

/// Finds a blocking flow in the layered network using DFS
///
/// A blocking flow is a flow that saturates at least one edge in every path
/// from source to sink in the layered network.
num _findBlockingFlow<T>(
  Map<T, List<DinicsEdge<T>>> flowNetwork,
  T source,
  T sink,
  Map<T, int> levels,
) {
  num totalFlow = 0;

  // Use DFS to find blocking flow
  while (true) {
    final path = _findPathInLayeredNetwork(flowNetwork, source, sink, levels);
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

    totalFlow += bottleneck;
  }

  return totalFlow;
}

/// Finds a path in the layered network using DFS
List<T> _findPathInLayeredNetwork<T>(
  Map<T, List<DinicsEdge<T>>> flowNetwork,
  T source,
  T sink,
  Map<T, int> levels,
) {
  final visited = <T>{};
  final parent = <T, T>{};

  bool dfs(T current) {
    if (current == sink) return true;

    visited.add(current);
    final edges = flowNetwork[current] ?? [];

    for (final edge in edges) {
      if (edge.residualCapacity > 0 &&
          levels[edge.target] == levels[current]! + 1 &&
          !visited.contains(edge.target)) {
        parent[edge.target] = current;
        if (dfs(edge.target)) return true;
      }
    }

    return false;
  }

  if (dfs(source)) {
    // Reconstruct path
    final path = <T>[sink];
    var node = sink;
    while (parent.containsKey(node)) {
      node = parent[node] as T;
      path.insert(0, node);
    }
    return path;
  }

  return [];
}

/// Finds an edge between two nodes in the flow network
DinicsEdge<T>? _findEdge<T>(
  Map<T, List<DinicsEdge<T>>> flowNetwork,
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

/// Dinic's algorithm with detailed analysis and performance metrics
///
/// Returns comprehensive information about the algorithm execution
class DinicsResult<T> {
  final num maxFlow;
  final Map<T, List<DinicsEdge<T>>> flowNetwork;
  final int phasesCount;
  final List<Map<T, int>> layeredNetworks;
  final List<num> blockingFlows;
  final Stopwatch executionTime;

  const DinicsResult({
    required this.maxFlow,
    required this.flowNetwork,
    required this.phasesCount,
    required this.layeredNetworks,
    required this.blockingFlows,
    required this.executionTime,
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

  /// Gets execution time in milliseconds
  int get executionTimeMs => executionTime.elapsedMilliseconds;

  /// Gets execution time in microseconds
  int get executionTimeMicros => executionTime.elapsedMicroseconds;

  /// Gets the average blocking flow size
  double get averageBlockingFlow {
    if (blockingFlows.isEmpty) return 0.0;
    final total = blockingFlows.fold<num>(0, (sum, flow) => sum + flow);
    return total / blockingFlows.length;
  }

  /// Gets the maximum layer depth reached
  int get maxLayerDepth {
    if (layeredNetworks.isEmpty) return 0;
    int maxDepth = 0;
    for (final network in layeredNetworks) {
      for (final level in network.values) {
        if (level > maxDepth) maxDepth = level;
      }
    }
    return maxDepth;
  }
}

DinicsResult<T> dinicsAlgorithmDetailed<T>(
  Map<T, Map<T, num>> graph,
  T source,
  T sink,
) {
  final stopwatch = Stopwatch()..start();

  // Build flow network
  final flowNetwork = <T, List<DinicsEdge<T>>>{};
  final edgeMap = <String, DinicsEdge<T>>{};

  for (final entry in graph.entries) {
    final from = entry.key;
    final neighbors = entry.value;

    flowNetwork[from] = <DinicsEdge<T>>[];

    for (final neighborEntry in neighbors.entries) {
      final to = neighborEntry.key;
      final capacity = neighborEntry.value;

      if (capacity > 0) {
        final edge = DinicsEdge<T>(from, to, capacity);
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
        final reverseEdge = DinicsEdge<T>(edge.target, edge.source, 0);
        flowNetwork[edge.target] ??= <DinicsEdge<T>>[];
        flowNetwork[edge.target]!.add(reverseEdge);
        edgeMap[reverseKey] = reverseEdge;
      }
    }
  }

  num maxFlow = 0;
  final layeredNetworks = <Map<T, int>>[];
  final blockingFlows = <num>[];

  // Main Dinic's algorithm loop
  while (true) {
    // Build layered network
    final levels = _buildLayeredNetwork(flowNetwork, source, sink);
    if (levels[sink] == null) break;

    layeredNetworks.add(Map<T, int>.from(levels));

    // Find blocking flow
    final blockingFlow = _findBlockingFlow(flowNetwork, source, sink, levels);
    if (blockingFlow == 0) break;

    blockingFlows.add(blockingFlow);
    maxFlow += blockingFlow;
  }

  stopwatch.stop();

  return DinicsResult<T>(
    maxFlow: maxFlow,
    flowNetwork: flowNetwork,
    phasesCount: layeredNetworks.length,
    layeredNetworks: layeredNetworks,
    blockingFlows: blockingFlows,
    executionTime: stopwatch,
  );
}
