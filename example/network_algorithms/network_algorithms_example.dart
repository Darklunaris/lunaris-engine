import 'package:lunaris_engine/network/network_algorithms.dart';
import 'package:lunaris_engine/network/union_find.dart';

void main() {
  print('🌐 Network Algorithms Examples\n');

  // Example 1: A* Pathfinding
  _demonstrateAStar();

  // Example 2: Maximum Flow Algorithms
  _demonstrateMaximumFlow();

  // Example 3: Tarjan's Algorithm
  _demonstrateTarjansAlgorithm();

  // Example 4: Union-Find Data Structure
  _demonstrateUnionFind();
}

/// Demonstrates A* pathfinding algorithm with different heuristics
void _demonstrateAStar() {
  print('🎯 A* Algorithm Examples');
  print('=' * 50);

  // Create a grid-like graph
  final graph = <String, Map<String, num>>{
    '0,0': {'1,0': 1, '0,1': 1},
    '1,0': {'2,0': 1, '1,1': 1, '0,0': 1},
    '2,0': {'3,0': 1, '2,1': 1, '1,0': 1},
    '3,0': {'3,1': 1, '2,0': 1},
    '0,1': {'1,1': 1, '0,2': 1, '0,0': 1},
    '1,1': {'2,1': 1, '1,2': 1, '1,0': 1, '0,1': 1},
    '2,1': {'3,1': 1, '2,2': 1, '2,0': 1, '1,1': 1},
    '3,1': {'3,2': 1, '3,0': 1, '2,1': 1},
    '0,2': {'1,2': 1, '0,1': 1},
    '1,2': {'2,2': 1, '1,1': 1, '0,2': 1},
    '2,2': {'3,2': 1, '2,1': 1, '1,2': 1},
    '3,2': {'3,1': 1, '2,2': 1},
  };

  // Manhattan distance heuristic
  num manhattanHeuristic(String node, String goal) {
    if (node == goal) return 0;
    final coords1 = node.split(',').map(int.parse).toList();
    final coords2 = goal.split(',').map(int.parse).toList();
    return (coords1[0] - coords2[0]).abs() + (coords1[1] - coords2[1]).abs();
  }

  // Zero heuristic (Dijkstra-like)
  num zeroHeuristic(String node, String goal) => 0;

  print('Finding path from (0,0) to (3,2) using Manhattan distance heuristic:');
  final path1 = aStar(graph, '0,0', '3,2', manhattanHeuristic);
  print('Path: $path1');
  print('Path length: ${path1.length}');

  print('\nFinding path from (0,0) to (3,2) using zero heuristic:');
  final path2 = aStar(graph, '0,0', '3,2', zeroHeuristic);
  print('Path: $path2');
  print('Path length: ${path2.length}');

  // Test with cost calculation
  final result = aStarWithCost(graph, '0,0', '3,2', manhattanHeuristic);
  print('\nPath with cost calculation:');
  print('Path: ${result.path}');
  print('Total cost: ${result.cost}');

  print('\n${'-' * 50}');
}

/// Demonstrates maximum flow algorithms
void _demonstrateMaximumFlow() {
  print('\n🌊 Maximum Flow Algorithm Examples');
  print('=' * 50);

  // Create a flow network
  final graph = <String, Map<String, num>>{
    'S': {'A': 10, 'B': 10},
    'A': {'B': 2, 'C': 8, 'T': 10},
    'B': {'C': 5, 'T': 10},
    'C': {'T': 10},
    'T': {},
  };

  print('Flow network:');
  for (final entry in graph.entries) {
    print('  ${entry.key}: ${entry.value}');
  }

  // Ford-Fulkerson
  print('\nFord-Fulkerson Algorithm:');
  final maxFlow1 = fordFulkerson(graph, 'S', 'T');
  print('Maximum flow: $maxFlow1');

  // Edmonds-Karp
  print('\nEdmonds-Karp Algorithm:');
  final maxFlow2 = edmondsKarp(graph, 'S', 'T');
  print('Maximum flow: $maxFlow2');

  // Dinic's Algorithm
  print('\nDinic\'s Algorithm:');
  final maxFlow3 = dinicsAlgorithm(graph, 'S', 'T');
  print('Maximum flow: $maxFlow3');

  // Detailed analysis with Edmonds-Karp
  print('\nDetailed Edmonds-Karp Analysis:');
  final detailedResult = edmondsKarpDetailed(graph, 'S', 'T');
  print('Maximum flow: ${detailedResult.maxFlow}');
  print('Number of augmenting paths: ${detailedResult.augmentingPathsCount}');
  print(
    'Average path length: ${detailedResult.averagePathLength.toStringAsFixed(2)}',
  );
  print('Augmenting paths: ${detailedResult.augmentingPaths}');

  print('\n${'-' * 50}');
}

/// Demonstrates Tarjan's algorithm for finding bridges and articulation points
void _demonstrateTarjansAlgorithm() {
  print('\n🔗 Tarjan\'s Algorithm Examples');
  print('=' * 50);

  // Create a graph with bridges and articulation points
  final graph = <int, List<int>>{
    0: [1, 2],
    1: [0, 2],
    2: [0, 1, 3],
    3: [2, 4],
    4: [3],
  };

  print('Graph structure:');
  for (final entry in graph.entries) {
    print('  ${entry.key}: ${entry.value}');
  }

  // Basic Tarjan's algorithm
  print('\nBasic Tarjan\'s Algorithm:');
  final result = tarjansAlgorithm(graph);
  print('Bridges found: ${result.bridges}');
  print('Articulation points: ${result.articulationPoints}');
  print('Bridge count: ${result.bridgeCount}');
  print('Articulation point count: ${result.articulationPointCount}');
  print('Is 2-edge-connected: ${result.is2EdgeConnected}');
  print('Is 2-vertex-connected: ${result.is2VertexConnected}');

  // Detailed analysis
  print('\nDetailed Tarjan\'s Analysis:');
  final detailedResult = tarjansAlgorithmDetailed(graph);
  print('Total nodes: ${detailedResult.totalNodes}');
  print('Total edges: ${detailedResult.totalEdges}');
  print('Connected components: ${detailedResult.componentCount}');
  print('Largest component size: ${detailedResult.largestComponentSize}');
  print(
    'Average component size: ${detailedResult.averageComponentSize.toStringAsFixed(2)}',
  );
  print('Graph density: ${detailedResult.density.toStringAsFixed(3)}');
  print(
    'Criticality ratio: ${detailedResult.criticalityRatio.toStringAsFixed(3)}',
  );

  print('\n${'-' * 50}');
}

/// Demonstrates Union-Find data structure
void _demonstrateUnionFind() {
  print('\n🔗 Union-Find Data Structure Examples');
  print('=' * 50);

  // Create a Union-Find instance
  final uf = UnionFind<String>();

  // Add elements
  print('Creating sets for elements: A, B, C, D, E, F');
  for (final element in ['A', 'B', 'C', 'D', 'E', 'F']) {
    uf.makeSet(element);
  }

  print('Initial state:');
  print('  Total elements: ${uf.elementCount}');
  print('  Number of sets: ${uf.setCount}');
  print('  All sets: ${uf.getAllSets()}');

  // Perform unions
  print('\nPerforming unions:');
  print('  Union(A, B)');
  uf.union('A', 'B');
  print('  Union(C, D)');
  uf.union('C', 'D');
  print('  Union(E, F)');
  uf.union('E', 'F');

  print('\nAfter unions:');
  print('  Number of sets: ${uf.setCount}');
  print('  All sets: ${uf.getAllSets()}');
  print('  Is A connected to B? ${uf.isConnected('A', 'B')}');
  print('  Is A connected to C? ${uf.isConnected('A', 'C')}');
  print('  Is C connected to D? ${uf.isConnected('C', 'D')}');

  // More unions
  print('\nMore unions:');
  print('  Union(B, C)');
  uf.union('B', 'C');
  print('  Union(D, E)');
  uf.union('D', 'E');

  print('\nFinal state:');
  print('  Number of sets: ${uf.setCount}');
  print('  All sets: ${uf.getAllSets()}');
  print('  Is A connected to F? ${uf.isConnected('A', 'F')}');
  print('  Largest set size: ${uf.largestSetSize}');
  print('  Average set size: ${uf.averageSetSize.toStringAsFixed(2)}');

  // Detailed Union-Find with statistics
  print('\nDetailed Union-Find with Statistics:');
  final detailedUf = UnionFindDetailed<String>();

  for (final element in ['X', 'Y', 'Z']) {
    detailedUf.makeSet(element);
  }

  detailedUf.union('X', 'Y');
  detailedUf.union('Y', 'Z');

  print('Performance statistics:');
  final stats = detailedUf.performanceStats;
  for (final entry in stats.entries) {
    print('  ${entry.key}: ${entry.value}');
  }

  print('\n${'-' * 50}');
}
