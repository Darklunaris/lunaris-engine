import 'package:test/test.dart';
import 'package:lunaris_engine/network/union_find.dart';

void main() {
  group('Union-Find Data Structure Tests', () {
    group('Basic Functionality', () {
      test('Create and find elements', () {
        final uf = UnionFind<String>();

        uf.makeSet('A');
        uf.makeSet('B');
        uf.makeSet('C');

        expect(uf.find('A'), equals('A'));
        expect(uf.find('B'), equals('B'));
        expect(uf.find('C'), equals('C'));
        expect(uf.elementCount, equals(3));
        expect(uf.setCount, equals(3));
      });

      test('Union and find operations', () {
        final uf = UnionFind<String>();

        uf.makeSet('A');
        uf.makeSet('B');
        uf.makeSet('C');

        uf.union('A', 'B');

        expect(uf.find('A'), equals(uf.find('B')));
        expect(uf.find('C'), equals('C'));
        expect(uf.setCount, equals(2));
        expect(uf.isConnected('A', 'B'), isTrue);
        expect(uf.isConnected('A', 'C'), isFalse);
      });

      test('Multiple unions', () {
        final uf = UnionFind<String>();

        uf.makeSet('A');
        uf.makeSet('B');
        uf.makeSet('C');
        uf.makeSet('D');

        uf.union('A', 'B');
        uf.union('C', 'D');
        uf.union('B', 'C');

        expect(uf.find('A'), equals(uf.find('B')));
        expect(uf.find('B'), equals(uf.find('C')));
        expect(uf.find('C'), equals(uf.find('D')));
        expect(uf.setCount, equals(1));
        expect(uf.isConnected('A', 'D'), isTrue);
      });
    });

    group('Edge Cases', () {
      test('Union with non-existent elements', () {
        final uf = UnionFind<String>();

        uf.makeSet('A');
        uf.makeSet('B');

        // Union with non-existent element should have no effect
        uf.union('A', 'C');
        uf.union('C', 'B');

        expect(uf.find('A'), equals('A'));
        expect(uf.find('B'), equals('B'));
        expect(uf.setCount, equals(2));
        expect(uf.isConnected('A', 'B'), isFalse);
      });

      test('Find non-existent element', () {
        final uf = UnionFind<String>();

        expect(uf.find('A'), isNull);
        expect(uf.isConnected('A', 'B'), isFalse);
      });

      test('Union same element', () {
        final uf = UnionFind<String>();

        uf.makeSet('A');
        uf.union('A', 'A');

        expect(uf.find('A'), equals('A'));
        expect(uf.setCount, equals(1));
      });

      test('Empty Union-Find', () {
        final uf = UnionFind<String>();

        expect(uf.elementCount, equals(0));
        expect(uf.setCount, equals(0));
        expect(uf.elements, isEmpty);
        expect(uf.getAllSets(), isEmpty);
      });
    });

    group('Set Operations', () {
      test('Get set size', () {
        final uf = UnionFind<String>();

        uf.makeSet('A');
        uf.makeSet('B');
        uf.makeSet('C');

        expect(uf.getSetSize('A'), equals(1));
        expect(uf.getSetSize('B'), equals(1));
        expect(uf.getSetSize('C'), equals(1));

        uf.union('A', 'B');
        expect(uf.getSetSize('A'), equals(2));
        expect(uf.getSetSize('B'), equals(2));
        expect(uf.getSetSize('C'), equals(1));
      });

      test('Get set elements', () {
        final uf = UnionFind<String>();

        uf.makeSet('A');
        uf.makeSet('B');
        uf.makeSet('C');
        uf.union('A', 'B');

        final setA = uf.getSetElements('A');
        final setB = uf.getSetElements('B');
        final setC = uf.getSetElements('C');

        expect(setA, equals({'A', 'B'}));
        expect(setB, equals({'A', 'B'}));
        expect(setC, equals({'C'}));
      });

      test('Get all sets', () {
        final uf = UnionFind<String>();

        uf.makeSet('A');
        uf.makeSet('B');
        uf.makeSet('C');
        uf.union('A', 'B');

        final allSets = uf.getAllSets();

        expect(allSets.length, equals(2));
        expect(
          allSets.any((set) => set.contains('A') && set.contains('B')),
          isTrue,
        );
        expect(allSets.any((set) => set.contains('C')), isTrue);
      });
    });

    group('Statistics and Analysis', () {
      test('Largest and average set sizes', () {
        final uf = UnionFind<String>();

        uf.makeSet('A');
        uf.makeSet('B');
        uf.makeSet('C');
        uf.makeSet('D');
        uf.makeSet('E');

        uf.union('A', 'B');
        uf.union('C', 'D');
        uf.union('D', 'E');

        expect(uf.largestSetSize, equals(3));
        expect(uf.averageSetSize, equals(2.5)); // (2 + 3) / 2 = 2.5
      });

      test('Contains and clear operations', () {
        final uf = UnionFind<String>();

        uf.makeSet('A');
        uf.makeSet('B');

        expect(uf.contains('A'), isTrue);
        expect(uf.contains('B'), isTrue);
        expect(uf.contains('C'), isFalse);

        uf.clear();
        expect(uf.elementCount, equals(0));
        expect(uf.setCount, equals(0));
        expect(uf.contains('A'), isFalse);
      });

      test('Reset operation', () {
        final uf = UnionFind<String>();

        uf.makeSet('A');
        uf.makeSet('B');
        uf.union('A', 'B');

        uf.reset(['X', 'Y', 'Z']);

        expect(uf.elementCount, equals(3));
        expect(uf.setCount, equals(3));
        expect(uf.find('X'), equals('X'));
        expect(uf.find('Y'), equals('Y'));
        expect(uf.find('Z'), equals('Z'));
        expect(uf.isConnected('X', 'Y'), isFalse);
      });
    });

    group('UnionFindNode Class', () {
      test('UnionFindNode properties', () {
        final node = UnionFindNode<String>('A');

        expect(node.value, equals('A'));
        expect(node.parent, isNull);
        expect(node.rank, equals(0));
      });

      test('UnionFindNode string representation', () {
        final node = UnionFindNode<String>('A');
        node.rank = 2;

        final str = node.toString();
        expect(str, contains('A'));
        expect(str, contains('rank: 2'));
      });
    });

    group('Constructor Variants', () {
      test('From elements constructor', () {
        final uf = UnionFind<String>.fromElements(['A', 'B', 'C']);

        expect(uf.elementCount, equals(3));
        expect(uf.setCount, equals(3));
        expect(uf.find('A'), equals('A'));
        expect(uf.find('B'), equals('B'));
        expect(uf.find('C'), equals('C'));
      });
    });

    group('Path Compression and Union by Rank', () {
      test('Path compression efficiency', () {
        final uf = UnionFind<String>();

        // Create a chain: A -> B -> C -> D
        uf.makeSet('A');
        uf.makeSet('B');
        uf.makeSet('C');
        uf.makeSet('D');

        uf.union('A', 'B');
        uf.union('B', 'C');
        uf.union('C', 'D');

        // After path compression, all should point directly to the root
        final rootA = uf.find('A');
        final rootB = uf.find('B');
        final rootC = uf.find('C');
        final rootD = uf.find('D');

        expect(rootA, equals(rootB));
        expect(rootB, equals(rootC));
        expect(rootC, equals(rootD));
      });

      test('Union by rank optimization', () {
        final uf = UnionFind<String>();

        uf.makeSet('A');
        uf.makeSet('B');
        uf.makeSet('C');
        uf.makeSet('D');

        // Union smaller trees to larger ones
        uf.union('A', 'B'); // A becomes root with rank 1
        uf.union('C', 'D'); // C becomes root with rank 1
        uf.union('A', 'C'); // A becomes root with rank 2

        expect(uf.setCount, equals(1));
        expect(uf.find('B'), equals(uf.find('A')));
        expect(uf.find('C'), equals(uf.find('A')));
        expect(uf.find('D'), equals(uf.find('A')));
      });
    });

    group('Detailed Union-Find', () {
      test('UnionFindDetailed basic operations', () {
        final uf = UnionFindDetailed<String>();

        uf.makeSet('A');
        uf.makeSet('B');
        uf.union('A', 'B');

        expect(
          uf.totalOperations,
          greaterThanOrEqualTo(3),
        ); // makeSet, makeSet, union
        expect(
          uf.getOperationCount('A'),
          greaterThanOrEqualTo(2),
        ); // makeSet + union
        expect(
          uf.getOperationCount('B'),
          greaterThanOrEqualTo(2),
        ); // makeSet + union
      });

      test('Operation history tracking', () {
        final uf = UnionFindDetailed<String>();

        uf.makeSet('A');
        uf.makeSet('B');
        uf.union('A', 'B');

        final history = uf.operationHistory;
        expect(history.length, greaterThanOrEqualTo(3));

        expect(history.any((op) => op['operation'] == 'makeSet'), isTrue);
        expect(history.any((op) => op['operation'] == 'union'), isTrue);
      });

      test('Performance statistics', () {
        final uf = UnionFindDetailed<String>();

        uf.makeSet('A');
        uf.makeSet('B');
        uf.makeSet('C');
        uf.union('A', 'B');
        uf.union('B', 'C');

        final stats = uf.performanceStats;

        expect(stats['totalOperations'], greaterThanOrEqualTo(5));
        expect(stats['elementCount'], equals(3));
        expect(stats['setCount'], equals(1));
        expect(stats['averageOperationsPerElement'], greaterThan(0));
      });

      test('Operation distribution', () {
        final uf = UnionFindDetailed<String>();

        uf.makeSet('A');
        uf.makeSet('B');
        uf.union('A', 'B');

        final distribution = uf.operationDistribution;

        expect(distribution['makeSet'], equals(2));
        expect(distribution['union'], equals(1));
      });

      test('Set size distribution', () {
        final uf = UnionFindDetailed<String>();

        uf.makeSet('A');
        uf.makeSet('B');
        uf.makeSet('C');
        uf.union('A', 'B');

        final distribution = uf.setSizeDistribution;

        expect(distribution[1], equals(1)); // One set with size 1 (C)
        expect(distribution[2], equals(1)); // One set with size 2 (A, B)
      });

      test('Most and least frequent elements', () {
        final uf = UnionFindDetailed<String>();

        uf.makeSet('A');
        uf.makeSet('B');
        uf.union('A', 'B');
        uf.find('A'); // Additional operation on A
        uf.find('A'); // Another operation on A

        expect(uf.mostFrequentElements.first, equals('A'));
        expect(uf.leastFrequentElements.first, equals('B'));
      });

      test('Clear history', () {
        final uf = UnionFindDetailed<String>();

        uf.makeSet('A');
        uf.makeSet('B');
        uf.union('A', 'B');

        expect(uf.totalOperations, greaterThanOrEqualTo(3));

        uf.clearHistory();

        expect(uf.totalOperations, equals(0));
        expect(uf.operationHistory, isEmpty);
        expect(uf.getOperationCount('A'), equals(0));
      });
    });

    group('Performance Tests', () {
      test('Large number of operations', () {
        final uf = UnionFind<String>();

        // Create many elements
        for (int i = 0; i < 1000; i++) {
          uf.makeSet('node$i');
        }

        expect(uf.elementCount, equals(1000));
        expect(uf.setCount, equals(1000));

        // Perform many unions
        for (int i = 0; i < 999; i++) {
          uf.union('node$i', 'node${i + 1}');
        }

        expect(uf.setCount, equals(1));
        expect(uf.find('node0'), equals(uf.find('node999')));
      });

      test('Performance with detailed tracking', () {
        final uf = UnionFindDetailed<String>();

        final stopwatch = Stopwatch()..start();

        // Create and union many elements
        for (int i = 0; i < 100; i++) {
          uf.makeSet('node$i');
        }

        for (int i = 0; i < 99; i++) {
          uf.union('node$i', 'node${i + 1}');
        }

        stopwatch.stop();

        expect(uf.totalOperations, greaterThanOrEqualTo(199));
        expect(uf.setCount, equals(1));
      });
    });

    group('Algorithm Correctness', () {
      test('Transitive connectivity', () {
        final uf = UnionFind<String>();

        uf.makeSet('A');
        uf.makeSet('B');
        uf.makeSet('C');
        uf.makeSet('D');

        uf.union('A', 'B');
        uf.union('C', 'D');
        uf.union('B', 'C');

        // A should be connected to D through B and C
        expect(uf.isConnected('A', 'D'), isTrue);
        expect(uf.find('A'), equals(uf.find('D')));
      });

      test('Reflexive connectivity', () {
        final uf = UnionFind<String>();

        uf.makeSet('A');

        expect(uf.isConnected('A', 'A'), isTrue);
        expect(uf.find('A'), equals('A'));
      });

      test('Symmetric connectivity', () {
        final uf = UnionFind<String>();

        uf.makeSet('A');
        uf.makeSet('B');
        uf.union('A', 'B');

        expect(uf.isConnected('A', 'B'), isTrue);
        expect(uf.isConnected('B', 'A'), isTrue);
      });
    });
  });
}
