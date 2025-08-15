import 'package:test/test.dart';
import 'package:lunaris_engine/network/ford_fulkerson.dart';

void main() {
  group('Ford-Fulkerson Algorithm Tests', () {
    group('Basic Functionality', () {
      test('Simple flow network', () {
        final graph = <String, Map<String, num>>{
          'S': {'A': 10, 'B': 10},
          'A': {'B': 2, 'T': 8},
          'B': {'T': 10},
          'T': {},
        };

        final maxFlow = fordFulkerson(graph, 'S', 'T');
        expect(maxFlow, equals(18));
      });

      test('Single path network', () {
        final graph = <String, Map<String, num>>{
          'S': {'A': 5},
          'A': {'T': 5},
          'T': {},
        };

        final maxFlow = fordFulkerson(graph, 'S', 'T');
        expect(maxFlow, equals(5));
      });

      test('Multiple paths network', () {
        final graph = <String, Map<String, num>>{
          'S': {'A': 3, 'B': 4},
          'A': {'T': 3},
          'B': {'T': 4},
          'T': {},
        };

        final maxFlow = fordFulkerson(graph, 'S', 'T');
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

        final maxFlow = fordFulkerson(graph, 'S', 'T');
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

        final maxFlow = fordFulkerson(graph, 'S', 'T');
        expect(maxFlow, equals(10));
      });

      test('Large network', () {
        final graph = <String, Map<String, num>>{};

        // Create a 5x5 grid network
        for (int i = 0; i < 5; i++) {
          for (int j = 0; j < 5; j++) {
            final node = '$i,$j';
            graph[node] = <String, num>{};

            if (i < 4) graph[node]!['${i + 1},$j'] = 1;
            if (j < 4) graph[node]!['$i,${j + 1}'] = 1;
          }
        }

        // Add source and sink
        graph['S'] = {'0,0': 10};
        graph['0,0']!['S'] = 0; // Remove reverse edge
        graph['4,4']!['T'] = 10;
        graph['T'] = {};

        final maxFlow = fordFulkerson(graph, 'S', 'T');
        expect(maxFlow, greaterThan(0));
      });
    });

    group('Edge Cases', () {
      test('Source equals sink', () {
        final graph = <String, Map<String, num>>{
          'A': {'B': 5},
          'B': {'A': 5},
        };

        expect(() => fordFulkerson(graph, 'A', 'A'), throwsArgumentError);
      });

      test('Source not in graph', () {
        final graph = <String, Map<String, num>>{
          'B': {'C': 5},
          'C': {'B': 5},
        };

        expect(() => fordFulkerson(graph, 'A', 'C'), throwsArgumentError);
      });

      test('Sink not in graph', () {
        final graph = <String, Map<String, num>>{
          'A': {'B': 5},
          'B': {'A': 5},
        };

        expect(() => fordFulkerson(graph, 'A', 'C'), throwsArgumentError);
      });

      test('Empty graph', () {
        final graph = <String, Map<String, num>>{};

        expect(() => fordFulkerson(graph, 'A', 'B'), throwsArgumentError);
      });

      test('Disconnected network', () {
        final graph = <String, Map<String, num>>{
          'S': {'A': 5},
          'A': {'S': 5},
          'B': {'T': 5},
          'T': {'B': 5},
        };

        final maxFlow = fordFulkerson(graph, 'S', 'T');
        expect(maxFlow, equals(0));
      });
    });

    group('FlowEdge Class', () {
      test('FlowEdge properties', () {
        final edge = FlowEdge<String>('A', 'B', 10);

        expect(edge.source, equals('A'));
        expect(edge.target, equals('B'));
        expect(edge.capacity, equals(10));
        expect(edge.flow, equals(0));
        expect(edge.residualCapacity, equals(10));
      });

      test('FlowEdge flow operations', () {
        final edge = FlowEdge<String>('A', 'B', 10);

        edge.addFlow(3);
        expect(edge.flow, equals(3));
        expect(edge.residualCapacity, equals(7));

        edge.addFlow(2);
        expect(edge.flow, equals(5));
        expect(edge.residualCapacity, equals(5));
      });

      test('FlowEdge reverse edge', () {
        final edge = FlowEdge<String>('A', 'B', 10);
        edge.addFlow(3);

        final reverse = edge.reverse;
        expect(reverse.source, equals('B'));
        expect(reverse.target, equals('A'));
        expect(reverse.capacity, equals(0));
        expect(reverse.flow, equals(-3));
        expect(reverse.residualCapacity, equals(3));
      });

      test('FlowEdge string representation', () {
        final edge = FlowEdge<String>('A', 'B', 10);
        edge.addFlow(3);

        final str = edge.toString();
        expect(str, contains('A -> B'));
        expect(str, contains('3/10'));
      });
    });

    group('Detailed Results', () {
      test('fordFulkersonDetailed returns correct result', () {
        final graph = <String, Map<String, num>>{
          'S': {'A': 10, 'B': 10},
          'A': {'B': 2, 'T': 8},
          'B': {'T': 10},
          'T': {},
        };

        final result = fordFulkersonDetailed(graph, 'S', 'T');

        expect(result.maxFlow, equals(18));
        expect(result.flowNetwork, isNotEmpty);
      });

      test('FordFulkersonResult methods', () {
        final graph = <String, Map<String, num>>{
          'S': {'A': 10},
          'A': {'T': 10},
          'T': {},
        };

        final result = fordFulkersonDetailed(graph, 'S', 'T');

        expect(result.getFlow('S', 'A'), equals(10));
        expect(result.getFlow('A', 'T'), equals(10));
        expect(result.getAllFlows(), isNotEmpty);
      });
    });

    group('Performance Tests', () {
      test('Large network performance', () {
        final graph = <String, Map<String, num>>{};

        // Create a 10x10 grid network
        for (int i = 0; i < 10; i++) {
          for (int j = 0; j < 10; j++) {
            final node = '$i,$j';
            graph[node] = <String, num>{};

            if (i < 9) graph[node]!['${i + 1},$j'] = 1;
            if (j < 9) graph[node]!['$i,${j + 1}'] = 1;
          }
        }

        graph['S'] = {'0,0': 10};
        graph['0,0']!['S'] = 0;
        graph['9,9']!['T'] = 10;
        graph['T'] = {};

        final stopwatch = Stopwatch()..start();
        final maxFlow = fordFulkerson(graph, 'S', 'T');
        stopwatch.stop();

        expect(maxFlow, greaterThan(0));
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      });
    });
  });
}
