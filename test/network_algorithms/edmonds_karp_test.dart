import 'package:test/test.dart';
import 'package:lunaris_engine/network/edmonds_karp.dart';

void main() {
  group('Edmonds-Karp Algorithm Tests', () {
    group('Basic Functionality', () {
      test('Simple flow network', () {
        final graph = <String, Map<String, num>>{
          'S': {'A': 10, 'B': 10},
          'A': {'B': 2, 'T': 8},
          'B': {'T': 10},
          'T': {},
        };

        final maxFlow = edmondsKarp(graph, 'S', 'T');
        expect(maxFlow, equals(18));
      });

      test('Single path network', () {
        final graph = <String, Map<String, num>>{
          'S': {'A': 5},
          'A': {'T': 5},
          'T': {},
        };

        final maxFlow = edmondsKarp(graph, 'S', 'T');
        expect(maxFlow, equals(5));
      });

      test('Multiple paths network', () {
        final graph = <String, Map<String, num>>{
          'S': {'A': 3, 'B': 4},
          'A': {'T': 3},
          'B': {'T': 4},
          'T': {},
        };

        final maxFlow = edmondsKarp(graph, 'S', 'T');
        expect(maxFlow, equals(7));
      });
    });

    group('Complex Networks', () {
      test('Network with bottlenecks', () {
        final graph = <String, Map<String, num>>{
          'S': {'A': 10, 'B': 10},
          'A': {'C': 5, 'D': 5},
          'B': {'C': 5, 'D': 5},
          'C': {'T': 8},
          'D': {'T': 8},
          'T': {},
        };

        final maxFlow = edmondsKarp(graph, 'S', 'T');
        expect(maxFlow, equals(16));
      });

      test('Network with cycles', () {
        final graph = <String, Map<String, num>>{
          'S': {'A': 10},
          'A': {'B': 5, 'C': 5},
          'B': {'C': 2, 'T': 5},
          'C': {'T': 5},
          'T': {},
        };

        final maxFlow = edmondsKarp(graph, 'S', 'T');
        expect(maxFlow, equals(10));
      });

      test('Grid network', () {
        final graph = <String, Map<String, num>>{};

        // Create a 3x3 grid network
        for (int i = 0; i < 3; i++) {
          for (int j = 0; j < 3; j++) {
            final node = '$i,$j';
            graph[node] = <String, num>{};

            if (i < 2) graph[node]!['${i + 1},$j'] = 1;
            if (j < 2) graph[node]!['$i,${j + 1}'] = 1;
          }
        }

        graph['S'] = {'0,0': 5};
        graph['0,0']!['S'] = 0;
        graph['2,2']!['T'] = 5;
        graph['T'] = {};

        final maxFlow = edmondsKarp(graph, 'S', 'T');
        expect(maxFlow, greaterThan(0));
      });
    });

    group('Edge Cases', () {
      test('Source equals sink', () {
        final graph = <String, Map<String, num>>{
          'A': {'B': 5},
          'B': {'A': 5},
        };

        expect(() => edmondsKarp(graph, 'A', 'A'), throwsArgumentError);
      });

      test('Source not in graph', () {
        final graph = <String, Map<String, num>>{
          'B': {'C': 5},
          'C': {'B': 5},
        };

        expect(() => edmondsKarp(graph, 'A', 'C'), throwsArgumentError);
      });

      test('Sink not in graph', () {
        final graph = <String, Map<String, num>>{
          'A': {'B': 5},
          'B': {'A': 5},
        };

        expect(() => edmondsKarp(graph, 'A', 'C'), throwsArgumentError);
      });

      test('Empty graph', () {
        final graph = <String, Map<String, num>>{};

        expect(() => edmondsKarp(graph, 'A', 'B'), throwsArgumentError);
      });

      test('Disconnected network', () {
        final graph = <String, Map<String, num>>{
          'S': {'A': 5},
          'A': {'S': 5},
          'B': {'T': 5},
          'T': {'B': 5},
        };

        final maxFlow = edmondsKarp(graph, 'S', 'T');
        expect(maxFlow, equals(0));
      });
    });

    group('EdmondsKarpEdge Class', () {
      test('EdmondsKarpEdge properties', () {
        final edge = EdmondsKarpEdge<String>('A', 'B', 10);

        expect(edge.source, equals('A'));
        expect(edge.target, equals('B'));
        expect(edge.capacity, equals(10));
        expect(edge.flow, equals(0));
        expect(edge.residualCapacity, equals(10));
      });

      test('EdmondsKarpEdge flow operations', () {
        final edge = EdmondsKarpEdge<String>('A', 'B', 10);

        edge.addFlow(3);
        expect(edge.flow, equals(3));
        expect(edge.residualCapacity, equals(7));

        edge.addFlow(2);
        expect(edge.flow, equals(5));
        expect(edge.residualCapacity, equals(5));
      });

      test('EdmondsKarpEdge reverse edge', () {
        final edge = EdmondsKarpEdge<String>('A', 'B', 10);
        edge.addFlow(3);

        final reverse = edge.reverse;
        expect(reverse.source, equals('B'));
        expect(reverse.target, equals('A'));
        expect(reverse.capacity, equals(0));
        expect(reverse.flow, equals(-3));
        expect(reverse.residualCapacity, equals(3));
      });

      test('EdmondsKarpEdge string representation', () {
        final edge = EdmondsKarpEdge<String>('A', 'B', 10);
        edge.addFlow(3);

        final str = edge.toString();
        expect(str, contains('A -> B'));
        expect(str, contains('3/10'));
      });
    });

    group('Detailed Results', () {
      test('edmondsKarpDetailed returns correct result', () {
        final graph = <String, Map<String, num>>{
          'S': {'A': 10, 'B': 10},
          'A': {'B': 2, 'T': 8},
          'B': {'T': 10},
          'T': {},
        };

        final result = edmondsKarpDetailed(graph, 'S', 'T');

        expect(result.maxFlow, equals(18));
        expect(result.flowNetwork, isNotEmpty);
        expect(result.augmentingPathsCount, greaterThan(0));
        expect(result.augmentingPaths, isNotEmpty);
      });

      test('EdmondsKarpResult methods', () {
        final graph = <String, Map<String, num>>{
          'S': {'A': 10},
          'A': {'T': 10},
          'T': {},
        };

        final result = edmondsKarpDetailed(graph, 'S', 'T');

        expect(result.getFlow('S', 'A'), equals(10));
        expect(result.getFlow('A', 'T'), equals(10));
        expect(result.getAllFlows(), isNotEmpty);
        expect(result.averagePathLength, greaterThan(0));
      });

      test('Augmenting paths analysis', () {
        final graph = <String, Map<String, num>>{
          'S': {'A': 5, 'B': 5},
          'A': {'T': 5},
          'B': {'T': 5},
          'T': {},
        };

        final result = edmondsKarpDetailed(graph, 'S', 'T');

        expect(result.augmentingPathsCount, equals(2));
        expect(result.augmentingPaths.length, equals(2));

        // Check that paths are shortest (BFS ensures this)
        for (final path in result.augmentingPaths) {
          expect(path.length, equals(3)); // S -> X -> T
        }
      });
    });

    group('BFS vs DFS Comparison', () {
      test('Edmonds-Karp finds shortest paths', () {
        final graph = <String, Map<String, num>>{
          'S': {'A': 10, 'B': 10},
          'A': {'C': 5, 'D': 5},
          'B': {'C': 5, 'D': 5},
          'C': {'T': 8},
          'D': {'T': 8},
          'T': {},
        };

        final result = edmondsKarpDetailed(graph, 'S', 'T');

        // Edmonds-Karp should find shorter augmenting paths
        // compared to Ford-Fulkerson with DFS
        for (final path in result.augmentingPaths) {
          expect(path.length, lessThanOrEqualTo(4)); // S -> X -> Y -> T
        }
      });
    });

    group('Performance Tests', () {
      test('Large network performance', () {
        final graph = <String, Map<String, num>>{};

        // Create a 8x8 grid network
        for (int i = 0; i < 8; i++) {
          for (int j = 0; j < 8; j++) {
            final node = '$i,$j';
            graph[node] = <String, num>{};

            if (i < 7) graph[node]!['${i + 1},$j'] = 1;
            if (j < 7) graph[node]!['$i,${j + 1}'] = 1;
          }
        }

        graph['S'] = {'0,0': 10};
        graph['0,0']!['S'] = 0;
        graph['7,7']!['T'] = 10;
        graph['T'] = {};

        final stopwatch = Stopwatch()..start();
        final maxFlow = edmondsKarp(graph, 'S', 'T');
        stopwatch.stop();

        expect(maxFlow, greaterThan(0));
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      });

      test('Performance comparison with detailed analysis', () {
        final graph = <String, Map<String, num>>{
          'S': {'A': 10, 'B': 10, 'C': 10},
          'A': {'D': 5, 'E': 5},
          'B': {'D': 5, 'F': 5},
          'C': {'E': 5, 'F': 5},
          'D': {'T': 8},
          'E': {'T': 8},
          'F': {'T': 8},
          'T': {},
        };

        final stopwatch = Stopwatch()..start();
        final result = edmondsKarpDetailed(graph, 'S', 'T');
        stopwatch.stop();

        expect(result.maxFlow, equals(24));
        expect(result.augmentingPathsCount, greaterThan(0));
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
      });
    });
  });
}
