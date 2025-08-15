/// 🎯 A* Algorithm (Optimal Path Finding with Heuristics)
///
/// An informed search algorithm that finds the shortest path between two nodes
/// using a heuristic function to guide the search. A* is optimal when the
/// heuristic is admissible (never overestimates the actual cost).
///
/// - **Time Complexity**: O(b^d) where b is branching factor, d is depth
/// - **Space Complexity**: O(b^d) for storing the frontier
/// - **Optimality**: Guaranteed when heuristic is admissible
/// - **Completeness**: Always finds a solution if one exists
///
/// The algorithm uses a priority queue to explore the most promising paths first,
/// combining the actual cost from start (g-score) with the estimated cost to goal (h-score).
///
/// Example:
/// ```dart
/// final graph = <String, Map<String, num>>{
///   'A': {'B': 1, 'C': 4},
///   'B': {'D': 5, 'E': 2},
///   'C': {'D': 3, 'F': 6},
///   'D': {'G': 2},
///   'E': {'G': 4},
///   'F': {'G': 1},
///   'G': {},
/// };
///
/// num heuristic(String node, String goal) =>
///   node == goal ? 0 : 1; // Simple heuristic
///
/// final path = aStar(graph, 'A', 'G', heuristic);
/// // Result: ['A', 'B', 'D', 'G'] with cost 8
/// ```
library;

/// Represents a node in the A* search with its f-score (g + h)
class AStarNode<T> implements Comparable<AStarNode<T>> {
  final T node;
  final T? parent;
  final num gScore; // Cost from start to current node
  final num fScore; // gScore + heuristic estimate to goal

  const AStarNode({
    required this.node,
    this.parent,
    required this.gScore,
    required this.fScore,
  });

  @override
  int compareTo(AStarNode<T> other) => fScore.compareTo(other.fScore);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AStarNode<T> &&
          runtimeType == other.runtimeType &&
          node == other.node;

  @override
  int get hashCode => node.hashCode;
}

/// Simple priority queue implementation for A* algorithm
class PriorityQueue<T> {
  final List<T> _elements = [];
  final int Function(T a, T b) _comparator;

  PriorityQueue(this._comparator);

  void add(T element) {
    _elements.add(element);
    _elements.sort(_comparator);
  }

  T removeFirst() {
    if (_elements.isEmpty) {
      throw StateError('Cannot remove from empty priority queue');
    }
    return _elements.removeAt(0);
  }

  bool get isNotEmpty => _elements.isNotEmpty;

  bool get isEmpty => _elements.isEmpty;

  int get length => _elements.length;
}

/// A* pathfinding algorithm implementation
///
/// [graph] represents the graph as an adjacency list with edge weights
/// [start] is the starting node
/// [goal] is the target node
/// [heuristic] estimates the cost from a node to the goal
/// [maxIterations] prevents infinite loops (default: 10000)
///
/// Returns a list representing the optimal path from start to goal,
/// or an empty list if no path exists.
///
/// Throws [ArgumentError] if start or goal nodes don't exist in the graph.
List<T> aStar<T>(
  Map<T, Map<T, num>> graph,
  T start,
  T goal,
  num Function(T node, T goal) heuristic, {
  int maxIterations = 10000,
}) {
  // Input validation
  if (!graph.containsKey(start)) {
    throw ArgumentError('Start node $start not found in graph');
  }
  if (!graph.containsKey(goal)) {
    throw ArgumentError('Goal node $goal not found in graph');
  }

  // Early exit for same start/goal
  if (start == goal) return [start];

  // Priority queue for frontier (open set)
  final frontier = PriorityQueue<AStarNode<T>>((a, b) => a.compareTo(b));

  // Track g-scores (actual cost from start)
  final gScores = <T, num>{start: 0};

  // Track f-scores (g + heuristic)
  final fScores = <T, num>{start: heuristic(start, goal)};

  // Track parent nodes for path reconstruction
  final cameFrom = <T, T>{};

  // Closed set (already evaluated nodes)
  final closedSet = <T>{};

  // Initialize frontier with start node
  frontier.add(
    AStarNode<T>(node: start, gScore: 0, fScore: heuristic(start, goal)),
  );

  int iterations = 0;

  while (frontier.isNotEmpty && iterations < maxIterations) {
    iterations++;

    // Get node with lowest f-score
    final current = frontier.removeFirst();

    // Skip if already evaluated
    if (closedSet.contains(current.node)) continue;

    // Add to closed set
    closedSet.add(current.node);

    // Check if we reached the goal
    if (current.node == goal) {
      return _reconstructPath(cameFrom, current.node);
    }

    // Explore neighbors
    final neighbors = graph[current.node] ?? {};

    for (final entry in neighbors.entries) {
      final neighbor = entry.key;
      final edgeCost = entry.value;

      // Skip if already evaluated
      if (closedSet.contains(neighbor)) continue;

      // Calculate tentative g-score
      final tentativeGScore = gScores[current.node]! + edgeCost;

      // Check if this path is better than previous ones
      if (!gScores.containsKey(neighbor) ||
          tentativeGScore < gScores[neighbor]!) {
        // Update path information
        cameFrom[neighbor] = current.node;
        gScores[neighbor] = tentativeGScore;

        final fScore = tentativeGScore + heuristic(neighbor, goal);
        fScores[neighbor] = fScore;

        // Add to frontier
        frontier.add(
          AStarNode<T>(
            node: neighbor,
            parent: current.node,
            gScore: tentativeGScore,
            fScore: fScore,
          ),
        );
      }
    }
  }

  // No path found or max iterations exceeded
  if (iterations >= maxIterations) {
    throw StateError(
      'A* algorithm exceeded maximum iterations ($maxIterations)',
    );
  }

  return []; // No path found
}

/// Reconstructs the path from start to goal using the parent map
List<T> _reconstructPath<T>(Map<T, T> cameFrom, T current) {
  final path = <T>[current];

  while (cameFrom.containsKey(current)) {
    current = cameFrom[current] as T;
    path.insert(0, current);
  }

  return path;
}

/// A* with path cost calculation
///
/// Returns both the path and the total cost
///
/// Example:
/// ```dart
/// final result = aStarWithCost(graph, 'A', 'G', heuristic);
/// print('Path: ${result.path}'); // ['A', 'B', 'D', 'G']
/// print('Cost: ${result.cost}'); // 8.0
/// ```
class AStarResult<T> {
  final List<T> path;
  final num cost;

  const AStarResult({required this.path, required this.cost});
}

AStarResult<T> aStarWithCost<T>(
  Map<T, Map<T, num>> graph,
  T start,
  T goal,
  num Function(T node, T goal) heuristic, {
  int maxIterations = 10000,
}) {
  final path = aStar(
    graph,
    start,
    goal,
    heuristic,
    maxIterations: maxIterations,
  );

  if (path.isEmpty) return AStarResult<T>(path: [], cost: double.infinity);

  // Calculate total cost
  num totalCost = 0;
  for (int i = 0; i < path.length - 1; i++) {
    final current = path[i];
    final next = path[i + 1];
    totalCost += graph[current]![next]!;
  }

  return AStarResult<T>(path: path, cost: totalCost);
}
