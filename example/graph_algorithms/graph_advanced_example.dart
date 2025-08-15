import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  // Johnson's Algorithm
  final johnsonGraph = {
    'A': {'B': 2, 'C': 4},
    'B': {'C': 1, 'D': 7},
    'C': {'D': 3},
    'D': {'A': 5},
  };
  final johnsonResult = johnsonsAlgorithm(johnsonGraph);
  print(
    'Johnson\'s Algorithm: Shortest path from A to D: ${johnsonResult['A']!['D']}',
  );

  // Edmonds-Karp
  final Map<String, Map<String, num>> ekGraph = {
    'S': {'A': 10, 'C': 10},
    'A': {'B': 4, 'C': 2, 'D': 8},
    'B': {'D': 10},
    'C': {'D': 9},
    'D': {},
  };
  final maxFlow = edmondsKarp(ekGraph, 'S', 'D');
  print('Edmonds-Karp: Max flow from S to D: $maxFlow');

  // Dinic's Algorithm
  final dinicFlow = dinicsAlgorithm(ekGraph, 'S', 'D');
  print('Dinic\'s Algorithm: Max flow from S to D: $dinicFlow');

  // Eulerian Path
  final eulerianGraph = {
    0: [1, 2],
    1: [2],
    2: [0, 1],
  };
  final eulerianPath = findEulerianPath(eulerianGraph);
  print('Eulerian Path: $eulerianPath');

  // Hamiltonian Path
  final hamiltonianGraph = {
    0: [1, 3],
    1: [0, 2, 3],
    2: [1, 3],
    3: [0, 1, 2],
  };
  final hamiltonianPath = findHamiltonianPath(hamiltonianGraph, cycle: true);
  print('Hamiltonian Path: $hamiltonianPath');

  // Chinese Postman
  final cppGraph = {
    0: {1: 1, 2: 1},
    1: {0: 1, 2: 1},
    2: {0: 1, 1: 1},
  };
  final cppCost = chinesePostman(cppGraph);
  print('Chinese Postman Problem: Min cost: $cppCost');

  // Stoer-Wagner Min Cut
  final swGraph = {
    0: {1: 3, 2: 1},
    1: {0: 3, 2: 3},
    2: {0: 1, 1: 3},
  };
  final minCut = stoerWagnerMinCut(swGraph);
  print('Stoer-Wagner Min Cut: $minCut');

  // Transitive Closure
  final tcGraph = {
    0: [1],
    1: [2],
    2: [0, 3],
    3: [],
  };
  final closure = transitiveClosure(tcGraph);
  print('Transitive Closure: 0->3 reachable? ${closure[0]![3]}');

  // Graph Coloring
  final coloringGraph = {
    0: [1, 2],
    1: [0, 2],
    2: [0, 1],
  };
  final coloring = graphColoring(coloringGraph, 3);
  print('Graph Coloring: $coloring');

  // SPFA
  final spfaGraph = {
    0: {1: 2, 2: 4},
    1: {2: 1, 3: 7},
    2: {3: 3},
    3: {0: 5},
  };
  final spfaDist = spfa(spfaGraph, 0);
  print('SPFA: Shortest path from 0 to 3: ${spfaDist[3]}');

  // Tarjan's SCC
  final sccGraph = {
    0: [1],
    1: [2],
    2: [0, 3],
    3: [],
  };
  final sccs = tarjansSCC(sccGraph);
  print('Tarjan\'s SCCs: $sccs');

  // Bridge Finding
  final bridgeGraph = {
    0: [1, 2],
    1: [0, 2],
    2: [0, 1, 3],
    3: [2],
  };
  final bridges = findBridges(bridgeGraph);
  print('Bridges: $bridges');

  // Tree Diameter
  final tree = {
    0: [1, 2],
    1: [0, 3, 4],
    2: [0],
    3: [1],
    4: [1],
  };
  final diameter = treeDiameter(tree);
  print(
    'Tree Diameter: length=${diameter['length']}, path=${diameter['path']}',
  );

  // Hierholzer's Algorithm
  final hierholzerGraph = {
    0: [1, 2],
    1: [2],
    2: [0, 1],
  };
  final trail = hierholzer(hierholzerGraph);
  print('Hierholzer\'s Algorithm: $trail');

  // Yen's Algorithm
  final Map<int, Map<int, num>> yenGraph = {
    0: {1: 1, 2: 5},
    1: {2: 1, 3: 2},
    2: {3: 1},
    3: {},
  };
  final kPaths = yensAlgorithm(yenGraph, 0, 3, 3);
  print('Yen\'s Algorithm: Top-3 shortest paths from 0 to 3: $kPaths');
}
