import 'package:lunaris_engine/networkop/max_flow_min_cut.dart';

void main() {
  final dinic = Dinic(4);
  dinic.addEdge(0, 1, 40);
  dinic.addEdge(0, 2, 20);
  dinic.addEdge(1, 2, 10);
  dinic.addEdge(1, 3, 30);
  dinic.addEdge(2, 3, 20);
  final flow = dinic.maxFlow(0, 3);
  print('max flow = $flow');
}
