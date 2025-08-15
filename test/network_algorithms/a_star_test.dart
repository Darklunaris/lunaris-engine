import 'package:test/test.dart';
import 'package:lunaris_engine/network/a_star.dart';

void main() {
  group('A* Algorithm Tests', () {
    group('Basic Functionality', () {
      test('Simple path finding', () {
        final graph = <String, Map<String, num>>{
          'A': {'B': 1, 'C': 4},
          'B': {'D': 5, 'E': 2},
          'C': {'D': 3, 'F': 6},
          'D': {'G': 2},
          'E': {'G': 4},
          'F': {'G': 1},
          'G': {},
        };

        num heuristic(String node, String goal) => node == goal ? 0 : 1;

        final path = aStar(graph, 'A', 'G', heuristic);
        expect(path.first, equals('A'));
        expect(path.last, equals('G'));
        expect(path.length, greaterThan(1));
      });

      test('Same start and goal', () {
        final graph = <String, Map<String, num>>{
          'A': {'B': 1},
          'B': {'A': 1},
        };

        num heuristic(String node, String goal) => 0;

        final path = aStar(graph, 'A', 'A', heuristic);
        expect(path, equals(['A']));
      });

      test('Direct connection', () {
        final graph = <String, Map<String, num>>{
          'A': {'B': 5},
          'B': {'A': 5},
        };

        num heuristic(String node, String goal) => 0;

        final path = aStar(graph, 'A', 'B', heuristic);
        expect(path, equals(['A', 'B']));
      });
    });

    group('Heuristic Functions', () {
      test('Zero heuristic (Dijkstra-like)', () {
        final graph = <String, Map<String, num>>{
          'A': {'B': 1, 'C': 4},
          'B': {'D': 5},
          'C': {'D': 3},
          'D': {},
        };

        num heuristic(String node, String goal) => 0;

        final path = aStar(graph, 'A', 'D', heuristic);
        expect(path.first, equals('A'));
        expect(path.last, equals('D'));
        expect(path.length, greaterThan(1));
      });

      test('Manhattan distance heuristic', () {
        final graph = <String, Map<String, num>>{
          '0,0': {'1,0': 1, '0,1': 1},
          '1,0': {'2,0': 1, '1,1': 1},
          '0,1': {'1,1': 1, '0,2': 1},
          '1,1': {'2,1': 1, '1,2': 1},
          '2,0': {'2,1': 1},
          '0,2': {'1,2': 1},
          '2,1': {'2,2': 1},
          '1,2': {'2,2': 1},
          '2,2': {},
        };

        num heuristic(String node, String goal) {
          if (node == goal) return 0;
          final coords1 = node.split(',').map(int.parse).toList();
          final coords2 = goal.split(',').map(int.parse).toList();
          return (coords1[0] - coords2[0]).abs() +
              (coords1[1] - coords2[1]).abs();
        }

        final path = aStar(graph, '0,0', '2,2', heuristic);
        expect(path.length, greaterThan(1));
        expect(path.first, equals('0,0'));
        expect(path.last, equals('2,2'));
      });

      test('Euclidean distance heuristic', () {
        final graph = <String, Map<String, num>>{
          'A': {'B': 1, 'C': 1.4},
          'B': {'D': 1},
          'C': {'D': 1},
          'D': {},
        };

        num heuristic(String node, String goal) {
          if (node == goal) return 0;
          // Simple Euclidean-like heuristic
          return 1.0;
        }

        final path = aStar(graph, 'A', 'D', heuristic);
        expect(path, contains('A'));
        expect(path, contains('D'));
      });
    });

    group('Complex Graphs', () {
      test('Grid-like graph', () {
        final graph = <String, Map<String, num>>{};

        // Create a 5x5 grid
        for (int i = 0; i < 5; i++) {
          for (int j = 0; j < 5; j++) {
            final node = '$i,$j';
            graph[node] = <String, num>{};

            // Add edges to neighbors
            if (i > 0) graph[node]!['${i - 1},$j'] = 1;
            if (i < 4) graph[node]!['${i + 1},$j'] = 1;
            if (j > 0) graph[node]!['$i,${j - 1}'] = 1;
            if (j < 4) graph[node]!['$i,${j + 1}'] = 1;
          }
        }

        num heuristic(String node, String goal) {
          if (node == goal) return 0;
          final coords1 = node.split(',').map(int.parse).toList();
          final coords2 = goal.split(',').map(int.parse).toList();
          return (coords1[0] - coords2[0]).abs() +
              (coords1[1] - coords2[1]).abs();
        }

        final path = aStar(graph, '0,0', '4,4', heuristic);
        expect(path.first, equals('0,0'));
        expect(path.last, equals('4,4'));
        expect(path.length, equals(9)); // Manhattan distance + 1
      });

      test('Disconnected graph', () {
        final graph = <String, Map<String, num>>{
          'A': {'B': 1},
          'B': {'A': 1},
          'C': {'D': 1},
          'D': {'C': 1},
        };

        num heuristic(String node, String goal) => 0;

        final path = aStar(graph, 'A', 'C', heuristic);
        expect(path, isEmpty);
      });

      test('Graph with cycles', () {
        final graph = <String, Map<String, num>>{
          'A': {'B': 1, 'C': 4},
          'B': {'A': 1, 'D': 5, 'E': 2},
          'C': {'A': 4, 'D': 3, 'F': 6},
          'D': {'B': 5, 'C': 3, 'G': 2},
          'E': {'B': 2, 'G': 4},
          'F': {'C': 6, 'G': 1},
          'G': {'D': 2, 'E': 4, 'F': 1},
        };

        num heuristic(String node, String goal) => 0;

        final path = aStar(graph, 'A', 'G', heuristic);
        expect(path.first, equals('A'));
        expect(path.last, equals('G'));
        expect(path.length, greaterThan(1));
      });
    });

    group('Edge Cases', () {
      test('Empty graph', () {
        final graph = <String, Map<String, num>>{};

        num heuristic(String node, String goal) => 0;

        expect(() => aStar(graph, 'A', 'B', heuristic), throwsArgumentError);
      });

      test('Source node not in graph', () {
        final graph = <String, Map<String, num>>{
          'B': {'C': 1},
          'C': {'B': 1},
        };

        num heuristic(String node, String goal) => 0;

        expect(() => aStar(graph, 'A', 'C', heuristic), throwsArgumentError);
      });

      test('Goal node not in graph', () {
        final graph = <String, Map<String, num>>{
          'A': {'B': 1},
          'B': {'A': 1},
        };

        num heuristic(String node, String goal) => 0;

        expect(() => aStar(graph, 'A', 'C', heuristic), throwsArgumentError);
      });

      test('Single node graph', () {
        final graph = <String, Map<String, num>>{'A': {}};

        num heuristic(String node, String goal) => 0;

        final path = aStar(graph, 'A', 'A', heuristic);
        expect(path, equals(['A']));
      });
    });

    group('Performance and Limits', () {
      test('Max iterations exceeded', () {
        final graph = <String, Map<String, num>>{
          'A': {'B': 1},
          'B': {'A': 1},
        };

        num heuristic(String node, String goal) => 0;

        expect(
          () => aStar(graph, 'A', 'B', heuristic, maxIterations: 0),
          throwsStateError,
        );
      });

      test('Large graph performance', () {
        final graph = <String, Map<String, num>>{};

        // Create a 10x10 grid
        for (int i = 0; i < 10; i++) {
          for (int j = 0; j < 10; j++) {
            final node = '$i,$j';
            graph[node] = <String, num>{};

            if (i > 0) graph[node]!['${i - 1},$j'] = 1;
            if (i < 9) graph[node]!['${i + 1},$j'] = 1;
            if (j > 0) graph[node]!['$i,${j - 1}'] = 1;
            if (j < 9) graph[node]!['$i,${j + 1}'] = 1;
          }
        }

        num heuristic(String node, String goal) {
          if (node == goal) return 0;
          final coords1 = node.split(',').map(int.parse).toList();
          final coords2 = goal.split(',').map(int.parse).toList();
          return (coords1[0] - coords2[0]).abs() +
              (coords1[1] - coords2[1]).abs();
        }

        final stopwatch = Stopwatch()..start();
        final path = aStar(graph, '0,0', '9,9', heuristic);
        stopwatch.stop();

        expect(path.isNotEmpty, isTrue);
        expect(path.first, equals('0,0'));
        expect(path.last, equals('9,9'));
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(1000),
        ); // Should complete quickly
      });
    });

    group('AStarResult and Cost Calculation', () {
      test('aStarWithCost returns correct path and cost', () {
        final graph = <String, Map<String, num>>{
          'A': {'B': 1, 'C': 4},
          'B': {'D': 5},
          'C': {'D': 3},
          'D': {},
        };

        num heuristic(String node, String goal) => 0;

        final result = aStarWithCost(graph, 'A', 'D', heuristic);
        expect(result.path.first, equals('A'));
        expect(result.path.last, equals('D'));
        expect(result.cost, greaterThan(0));
      });

      test('aStarWithCost with no path returns infinity cost', () {
        final graph = <String, Map<String, num>>{
          'A': {'B': 1},
          'B': {'A': 1},
          'C': {'D': 1},
          'D': {'C': 1},
        };

        num heuristic(String node, String goal) => 0;

        final result = aStarWithCost(graph, 'A', 'C', heuristic);
        expect(result.path, isEmpty);
        expect(result.cost, equals(double.infinity));
      });

      test('AStarResult properties', () {
        final result = AStarResult<String>(path: ['A', 'B', 'C'], cost: 5.5);

        expect(result.path, equals(['A', 'B', 'C']));
        expect(result.cost, equals(5.5));
      });
    });

    group('PriorityQueue Implementation', () {
      test('PriorityQueue basic operations', () {
        final queue = PriorityQueue<int>((a, b) => a.compareTo(b));

        expect(queue.isEmpty, isTrue);
        expect(queue.length, equals(0));

        queue.add(3);
        queue.add(1);
        queue.add(2);

        expect(queue.isNotEmpty, isTrue);
        expect(queue.length, equals(3));

        expect(queue.removeFirst(), equals(1));
        expect(queue.removeFirst(), equals(2));
        expect(queue.removeFirst(), equals(3));

        expect(queue.isEmpty, isTrue);
      });

      test('PriorityQueue with custom comparator', () {
        final queue = PriorityQueue<String>(
          (a, b) => b.compareTo(a),
        ); // Reverse order

        queue.add('A');
        queue.add('C');
        queue.add('B');

        expect(queue.removeFirst(), equals('C'));
        expect(queue.removeFirst(), equals('B'));
        expect(queue.removeFirst(), equals('A'));
      });

      test('PriorityQueue removeFirst on empty queue throws error', () {
        final queue = PriorityQueue<int>((a, b) => a.compareTo(b));

        expect(() => queue.removeFirst(), throwsStateError);
      });
    });
  });
}
