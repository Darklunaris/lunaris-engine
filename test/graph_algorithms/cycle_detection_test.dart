import 'package:test/test.dart';
import 'package:lunaris_engine/Graph/cycle_detection.dart';

void main() {
  test('Directed cycle detection', () {
    final gCycle = <int, List<int>>{
      1: [2],
      2: [3],
      3: [1],
    };
    final gDag = <int, List<int>>{
      1: [2],
      2: [3],
      3: [],
    };
    expect(hasCycleDirected(gCycle), isTrue);
    expect(hasCycleDirected(gDag), isFalse);
  });

  test('Undirected cycle detection', () {
    final gCycle = <String, List<String>>{
      'A': ['B', 'C'],
      'B': ['A', 'C'],
      'C': ['A', 'B'],
    };
    final gTree = <String, List<String>>{
      'A': ['B'],
      'B': ['A', 'C'],
      'C': ['B'],
    };
    expect(hasCycleUndirected(gCycle), isTrue);
    expect(hasCycleUndirected(gTree), isFalse);
  });
}
