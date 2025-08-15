import 'package:test/test.dart';
import 'package:lunaris_engine/networkop/max_flow_min_cut.dart';

void main() {
  test('Dinic max flow simple', () {
    final d = Dinic(4);
    d.addEdge(0, 1, 40);
    d.addEdge(0, 2, 20);
    d.addEdge(1, 2, 10);
    d.addEdge(1, 3, 30);
    d.addEdge(2, 3, 20);
    expect(d.maxFlow(0, 3), equals(50));
  });
}
