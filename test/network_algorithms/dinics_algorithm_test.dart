import 'package:test/test.dart';
import 'package:lunaris_engine/network/dinics_algorithm.dart';

void main() {
  group('Dinic\'s Algorithm Tests', () {
    group('Basic Functionality', () {
      test('Simple flow network', () {
        final graph = <String, Map<String, num>>{
          'S': {'A': 10, 'B': 10},
          'A': {'B': 2, 'T': 8},
          'B': {'T': 10},
          'T': {},
        };

        final maxFlow = dinicsAlgorithm(graph, 'S', 'T');
        expect(maxFlow, equals(18));
      });

      test('Single path network', () {
        final graph = <String, Map<String, num>>{
          'S': {'A': 5},
          'A': {'T': 5},
          'T': {},
        };

        final maxFlow = dinicsAlgorithm(graph, 'S', 'T');
        expect(maxFlow, equals(5));
      });

      test('Multiple paths network', () {
        final graph = <String, Map<String, num>>{
          'S': {'A': 3, 'B': 4},
          'A': {'T': 3},
          'B': {'T': 4},
          'T': {},
        };

        final maxFlow = dinicsAlgorithm(graph, 'S', 'T');
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

        final maxFlow = dinicsAlgorithm(graph, 'S', 'T');
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

        final maxFlow = dinicsAlgorithm(graph, 'S', 'T');
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

        final maxFlow = dinicsAlgorithm(graph, 'S', 'T');
        expect(maxFlow, greaterThan(0));
      });
    });

    group('Edge Cases', () {
      test('Source equals sink', () {
        final graph = <String, Map<String, num>>{
          'A': {'B': 5},
          'B': {'A': 5},
        };

        expect(() => dinicsAlgorithm(graph, 'A', 'A'), throwsArgumentError);
      });

      test('Source not in graph', () {
        final graph = <String, Map<String, num>>{
          'B': {'C': 5},
          'C': {'B': 5},
        };

        expect(() => dinicsAlgorithm(graph, 'A', 'C'), throwsArgumentError);
      });

      test('Sink not in graph', () {
        final graph = <String, Map<String, num>>{
          'A': {'B': 5},
          'B': {'A': 5},
        };

        expect(() => dinicsAlgorithm(graph, 'A', 'C'), throwsArgumentError);
      });

      test('Empty graph', () {
        final graph = <String, Map<String, num>>{};

        expect(() => dinicsAlgorithm(graph, 'A', 'B'), throwsArgumentError);
      });

      test('Disconnected network', () {
        final graph = <String, Map<String, num>>{
          'S': {'A': 5},
          'A': {'S': 5},
          'B': {'T': 5},
          'T': {'B': 5},
        };

        final maxFlow = dinicsAlgorithm(graph, 'S', 'T');
        expect(maxFlow, equals(0));
      });
    });

    group('DinicsEdge Class', () {
      test('DinicsEdge properties', () {
        final edge = DinicsEdge<String>('A', 'B', 10);

        expect(edge.source, equals('A'));
        expect(edge.target, equals('B'));
        expect(edge.capacity, equals(10));
        expect(edge.flow, equals(0));
        expect(edge.residualCapacity, equals(10));
      });

      test('DinicsEdge flow operations', () {
        final edge = DinicsEdge<String>('A', 'B', 10);

        edge.addFlow(3);
        expect(edge.flow, equals(3));
        expect(edge.residualCapacity, equals(7));

        edge.addFlow(2);
        expect(edge.flow, equals(5));
        expect(edge.residualCapacity, equals(5));
      });

      test('DinicsEdge reverse edge', () {
        final edge = DinicsEdge<String>('A', 'B', 10);
        edge.addFlow(3);

        final reverse = edge.reverse;
        expect(reverse.source, equals('B'));
        expect(reverse.target, equals('A'));
        expect(reverse.capacity, equals(0));
        expect(reverse.flow, equals(-3));
        expect(reverse.residualCapacity, equals(3));
      });

      test('DinicsEdge string representation', () {
        final edge = DinicsEdge<String>('A', 'B', 10);
        edge.addFlow(3);

        final str = edge.toString();
        expect(str, contains('A -> B'));
        expect(str, contains('3/10'));
      });
    });

    group('Layered Network', () {
      test('LayeredNode properties', () {
        final node = LayeredNode<String>('A', 2);

        expect(node.node, equals('A'));
        expect(node.level, equals(2));
      });

      test('LayeredNode equality', () {
        final node1 = LayeredNode<String>('A', 2);
        final node2 = LayeredNode<String>('A', 2);
        final node3 = LayeredNode<String>('A', 3);

        expect(node1, equals(node2));
        expect(node1, isNot(equals(node3)));
      });

      test('LayeredNode hashCode', () {
        final node1 = LayeredNode<String>('A', 2);
        final node2 = LayeredNode<String>('A', 2);

        expect(node1.hashCode, equals(node2.hashCode));
      });
    });

    group('Detailed Results', () {
      test('dinicsAlgorithmDetailed returns correct result', () {
        final graph = <String, Map<String, num>>{
          'S': {'A': 10, 'B': 10},
          'A': {'B': 2, 'T': 8},
          'B': {'T': 10},
          'T': {},
        };

        final result = dinicsAlgorithmDetailed(graph, 'S', 'T');

        expect(result.maxFlow, equals(18));
        expect(result.flowNetwork, isNotEmpty);
        expect(result.layeredNetworks, isNotEmpty);
        expect(result.blockingFlows, isNotEmpty);
        expect(result.executionTime, isNotNull);
      });

      test('DinicsResult methods', () {
        final graph = <String, Map<String, num>>{
          'S': {'A': 10},
          'A': {'T': 10},
          'T': {},
        };

        final result = dinicsAlgorithmDetailed(graph, 'S', 'T');

        expect(result.getFlow('S', 'A'), equals(10));
        expect(result.getFlow('A', 'T'), equals(10));
        expect(result.getAllFlows(), isNotEmpty);
        expect(result.executionTimeMs, greaterThanOrEqualTo(0));
        expect(result.executionTimeMicros, greaterThanOrEqualTo(0));
      });

      test('Performance metrics', () {
        final graph = <String, Map<String, num>>{
          'S': {'A': 5, 'B': 5},
          'A': {'T': 5},
          'B': {'T': 5},
          'T': {},
        };

        final result = dinicsAlgorithmDetailed(graph, 'S', 'T');

        expect(result.averageBlockingFlow, greaterThan(0));
        expect(result.maxLayerDepth, greaterThan(0));
        expect(result.phasesCount, greaterThan(0));
      });
    });

    group('Layered Network Building', () {
      test('Layered network structure', () {
        final graph = <String, Map<String, num>>{
          'S': {'A': 10, 'B': 10},
          'A': {'C': 5, 'T': 5},
          'B': {'C': 5, 'T': 5},
          'C': {'T': 5},
          'T': {},
        };

        final result = dinicsAlgorithmDetailed(graph, 'S', 'T');

        // Should have multiple layered networks
        expect(result.layeredNetworks.length, greaterThan(1));

        // Each layered network should have levels
        for (final network in result.layeredNetworks) {
          expect(network['S'], equals(0)); // Source at level 0
          expect(network['T'], isNotNull); // Sink should be reachable
        }
      });
    });

    group('Blocking Flow', () {
      test('Blocking flow calculation', () {
        final graph = <String, Map<String, num>>{
          'S': {'A': 10, 'B': 10},
          'A': {'T': 10},
          'B': {'T': 10},
          'T': {},
        };

        final result = dinicsAlgorithmDetailed(graph, 'S', 'T');

        // Should have at least one blocking flow
        expect(result.blockingFlows.length, greaterThanOrEqualTo(1));

        // Each blocking flow should be positive
        for (final flow in result.blockingFlows) {
          expect(flow, greaterThan(0));
        }
      });
    });

    group('Performance Tests', () {
      test('Large network performance', () {
        final graph = <String, Map<String, num>>{};

        // Create a 6x6 grid network
        for (int i = 0; i < 6; i++) {
          for (int j = 0; j < 6; j++) {
            final node = '$i,$j';
            graph[node] = <String, num>{};

            if (i < 5) graph[node]!['${i + 1},$j'] = 1;
            if (j < 5) graph[node]!['$i,${j + 1}'] = 1;
          }
        }

        graph['S'] = {'0,0': 10};
        graph['0,0']!['S'] = 0;
        graph['5,5']!['T'] = 10;
        graph['T'] = {};

        final stopwatch = Stopwatch()..start();
        final maxFlow = dinicsAlgorithm(graph, 'S', 'T');
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
        final result = dinicsAlgorithmDetailed(graph, 'S', 'T');
        stopwatch.stop();

        expect(result.maxFlow, equals(24));
        expect(result.phasesCount, greaterThan(0));
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
      });
    });

    group('Algorithm Efficiency', () {
      test('Dinic\'s should be efficient for layered networks', () {
        final graph = <String, Map<String, num>>{};

        // Create a network that benefits from layering
        for (int i = 0; i < 4; i++) {
          final node = 'L$i';
          graph[node] = <String, num>{};

          if (i < 3) {
            graph[node]!['L${i + 1}'] = 10;
          }
        }

        graph['S'] = {'L0': 10};
        graph['L3']!['T'] = 10;
        graph['T'] = {};

        final result = dinicsAlgorithmDetailed(graph, 'S', 'T');

        // Should find the flow efficiently
        expect(result.maxFlow, equals(10));
        expect(result.phasesCount, greaterThan(0));
      });
    });
  });
}
