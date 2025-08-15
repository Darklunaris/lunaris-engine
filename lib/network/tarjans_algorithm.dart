/// 🔗 Tarjan's Algorithm (Bridges and Articulation Points)
///
/// Finds all bridges (critical edges) and articulation points (critical nodes)
/// in an undirected graph using depth-first search with low-link values.
///
/// - **Time Complexity**: O(V + E) where V is vertices, E is edges
/// - **Space Complexity**: O(V) for DFS stack and arrays
/// - **Optimality**: Guaranteed to find all bridges and articulation points
/// - **Completeness**: Always terminates and finds all critical components
/// - **Applications**: Network reliability, social network analysis, circuit design
///
/// Tarjan's algorithm uses DFS to identify critical components by tracking
/// discovery times and low-link values for each node.
///
/// Example:
/// ```dart
/// final graph = <int, List<int>>{
///   0: [1, 2],
///   1: [0, 2],
///   2: [0, 1, 3],
///   3: [2, 4],
///   4: [3],
/// };
/// final result = tarjansAlgorithm(graph);
/// print('Bridges: ${result.bridges}'); // [[2, 3]]
/// print('Articulation Points: ${result.articulationPoints}'); // [2]
/// ```
library;

/// Represents a bridge (critical edge) in the graph
class Bridge<T> {
  final T u;
  final T v;

  const Bridge(this.u, this.v);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Bridge<T> &&
          runtimeType == other.runtimeType &&
          ((u == other.u && v == other.v) || (u == other.v && v == other.u));

  @override
  int get hashCode => Object.hash(u, v);

  @override
  String toString() => 'Bridge($u - $v)';
}

/// Result of Tarjan's algorithm containing bridges and articulation points
class TarjansResult<T> {
  final List<Bridge<T>> bridges;
  final Set<T> articulationPoints;

  const TarjansResult({
    required this.bridges,
    required this.articulationPoints,
  });

  /// Gets the number of bridges found
  int get bridgeCount => bridges.length;

  /// Gets the number of articulation points found
  int get articulationPointCount => articulationPoints.length;

  /// Checks if the graph is 2-edge-connected (no bridges)
  bool get is2EdgeConnected => bridges.isEmpty;

  /// Checks if the graph is 2-vertex-connected (no articulation points)
  bool get is2VertexConnected => articulationPoints.isEmpty;

  /// Gets all critical edges as a list of pairs
  List<List<T>> get criticalEdges =>
      bridges.map((bridge) => [bridge.u, bridge.v]).toList();

  @override
  String toString() =>
      'TarjansResult(bridges: $bridges, articulationPoints: $articulationPoints)';
}

/// Tarjan's algorithm for finding bridges and articulation points
///
/// [graph] represents the undirected graph as adjacency list
///
/// Returns a TarjansResult containing all bridges and articulation points.
///
/// Throws [ArgumentError] if the graph is empty.
TarjansResult<T> tarjansAlgorithm<T>(Map<T, List<T>> graph) {
  // Input validation
  if (graph.isEmpty) {
    throw ArgumentError('Graph cannot be empty');
  }

  final bridges = <Bridge<T>>[];
  final articulationPoints = <T>{};
  final discovery = <T, int>{};
  final low = <T, int>{};
  final parent = <T, T?>{};
  final children = <T, int>{};
  int time = 0;

  // Initialize all nodes
  for (final node in graph.keys) {
    discovery[node] = -1;
    low[node] = -1;
    parent[node] = null;
    children[node] = 0;
  }

  // DFS from each unvisited node (handles disconnected components)
  for (final node in graph.keys) {
    if (discovery[node] == -1) {
      _dfs(
        node,
        graph,
        bridges,
        articulationPoints,
        discovery,
        low,
        parent,
        children,
        time,
      );
    }
  }

  return TarjansResult<T>(
    bridges: bridges,
    articulationPoints: articulationPoints,
  );
}

/// Depth-first search implementation for Tarjan's algorithm
void _dfs<T>(
  T u,
  Map<T, List<T>> graph,
  List<Bridge<T>> bridges,
  Set<T> articulationPoints,
  Map<T, int> discovery,
  Map<T, int> low,
  Map<T, T?> parent,
  Map<T, int> children,
  int time,
) {
  discovery[u] = time;
  low[u] = time;
  time++;

  final neighbors = graph[u] ?? [];

  for (final v in neighbors) {
    // Skip parent to avoid going back in undirected graph
    if (parent[u] == v) continue;

    if (discovery[v] == -1) {
      // v is not visited yet
      parent[v] = u;
      children[u] = children[u]! + 1;

      _dfs(
        v,
        graph,
        bridges,
        articulationPoints,
        discovery,
        low,
        parent,
        children,
        time,
      );

      // Check if subtree rooted at v has connection to ancestors of u
      low[u] = min(low[u]!, low[v]!);

      // Check for articulation point
      if (parent[u] == null && children[u]! > 1) {
        // u is root and has more than one child
        articulationPoints.add(u);
      } else if (parent[u] != null && low[v]! >= discovery[u]!) {
        // u is not root and v's subtree has no back edge to u's ancestors
        articulationPoints.add(u);
      }

      // Check for bridge
      if (low[v]! > discovery[u]!) {
        bridges.add(Bridge<T>(u, v));
      }
    } else {
      // v is already visited (back edge)
      low[u] = min(low[u]!, discovery[v]!);
    }
  }
}

/// Utility function for finding minimum of two numbers
T min<T extends num>(T a, T b) => a < b ? a : b;

/// Enhanced Tarjan's algorithm with detailed analysis
///
/// Returns comprehensive information about the graph's connectivity
class TarjansDetailedResult<T> {
  final TarjansResult<T> basicResult;
  final Map<T, int> discoveryTimes;
  final Map<T, int> lowValues;
  final Map<T, T?> parentNodes;
  final Map<T, int> childCounts;
  final List<List<T>> connectedComponents;
  final int totalNodes;
  final int totalEdges;

  const TarjansDetailedResult({
    required this.basicResult,
    required this.discoveryTimes,
    required this.lowValues,
    required this.parentNodes,
    required this.childCounts,
    required this.connectedComponents,
    required this.totalNodes,
    required this.totalEdges,
  });

  /// Gets the basic result (bridges and articulation points)
  TarjansResult<T> get result => basicResult;

  /// Gets the bridges found
  List<Bridge<T>> get bridges => basicResult.bridges;

  /// Gets the articulation points found
  Set<T> get articulationPoints => basicResult.articulationPoints;

  /// Gets the discovery time of a specific node
  int getDiscoveryTime(T node) => discoveryTimes[node] ?? -1;

  /// Gets the low value of a specific node
  int getLowValue(T node) => lowValues[node] ?? -1;

  /// Gets the parent of a specific node
  T? getParent(T node) => parentNodes[node];

  /// Gets the number of children of a specific node
  int getChildCount(T node) => childCounts[node] ?? 0;

  /// Gets the number of connected components
  int get componentCount => connectedComponents.length;

  /// Gets the largest connected component size
  int get largestComponentSize {
    if (connectedComponents.isEmpty) return 0;
    return connectedComponents.map((component) => component.length).reduce(max);
  }

  /// Gets the average component size
  double get averageComponentSize {
    if (connectedComponents.isEmpty) return 0.0;
    final totalSize = connectedComponents.fold<int>(
      0,
      (sum, component) => sum + component.length,
    );
    return totalSize / connectedComponents.length;
  }

  /// Checks if the graph is connected (single component)
  bool get isConnected => connectedComponents.length == 1;

  /// Gets the graph density (edges / (nodes * (nodes-1) / 2))
  double get density {
    if (totalNodes <= 1) return 0.0;
    final maxEdges = totalNodes * (totalNodes - 1) / 2;
    return totalEdges / maxEdges;
  }

  /// Gets the criticality ratio (critical nodes / total nodes)
  double get criticalityRatio {
    if (totalNodes == 0) return 0.0;
    return articulationPoints.length / totalNodes;
  }
}

/// Utility function for finding maximum of two numbers
T max<T extends num>(T a, T b) => a > b ? a : b;

/// Enhanced Tarjan's algorithm with detailed analysis
TarjansDetailedResult<T> tarjansAlgorithmDetailed<T>(Map<T, List<T>> graph) {
  if (graph.isEmpty) {
    throw ArgumentError('Graph cannot be empty');
  }

  final bridges = <Bridge<T>>[];
  final articulationPoints = <T>{};
  final discovery = <T, int>{};
  final low = <T, int>{};
  final parent = <T, T?>{};
  final children = <T, int>{};
  int time = 0;

  // Initialize all nodes
  for (final node in graph.keys) {
    discovery[node] = -1;
    low[node] = -1;
    parent[node] = null;
    children[node] = 0;
  }

  // DFS from each unvisited node
  for (final node in graph.keys) {
    if (discovery[node] == -1) {
      _dfs(
        node,
        graph,
        bridges,
        articulationPoints,
        discovery,
        low,
        parent,
        children,
        time,
      );
    }
  }

  // Find connected components
  final connectedComponents = _findConnectedComponents(graph);

  // Calculate total edges
  int totalEdges = 0;
  for (final neighbors in graph.values) {
    totalEdges += neighbors.length;
  }
  totalEdges = totalEdges ~/ 2; // Undirected graph

  final basicResult = TarjansResult<T>(
    bridges: bridges,
    articulationPoints: articulationPoints,
  );

  return TarjansDetailedResult<T>(
    basicResult: basicResult,
    discoveryTimes: Map<T, int>.from(discovery),
    lowValues: Map<T, int>.from(low),
    parentNodes: Map<T, T?>.from(parent),
    childCounts: Map<T, int>.from(children),
    connectedComponents: connectedComponents,
    totalNodes: graph.length,
    totalEdges: totalEdges,
  );
}

/// Finds all connected components in the graph
List<List<T>> _findConnectedComponents<T>(Map<T, List<T>> graph) {
  final visited = <T>{};
  final components = <List<T>>[];

  for (final node in graph.keys) {
    if (!visited.contains(node)) {
      final component = <T>[];
      _dfsComponent(node, graph, visited, component);
      components.add(component);
    }
  }

  return components;
}

/// DFS to find a single connected component
void _dfsComponent<T>(
  T node,
  Map<T, List<T>> graph,
  Set<T> visited,
  List<T> component,
) {
  visited.add(node);
  component.add(node);

  final neighbors = graph[node] ?? [];
  for (final neighbor in neighbors) {
    if (!visited.contains(neighbor)) {
      _dfsComponent(neighbor, graph, visited, component);
    }
  }
}
