import 'package:test/test.dart';
import 'package:lunaris_engine/Graph/articulation_points.dart';

void main() {
  test('Articulation points in a simple graph', () {
    // Graph: 1-2-3 with 2-4
    final graph = <int, List<int>>{
      1: [2],
      2: [1, 3, 4],
      3: [2],
      4: [2],
    };
    final aps = articulationPoints(graph);
    expect(aps, equals({2}));
  });
}
