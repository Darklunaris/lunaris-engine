import 'package:lunaris_engine/networkop/min_cost_flow.dart';

void main() {
  final mcf = MinCostFlow(4);
  mcf.addEdge(0, 1, 2, 1);
  mcf.addEdge(0, 2, 1, 2);
  mcf.addEdge(1, 2, 1, 1);
  mcf.addEdge(1, 3, 1, 3);
  mcf.addEdge(2, 3, 2, 1);
  final res = mcf.minCostMaxFlow(0, 3, 3);
  print('flow=${res['flow']} cost=${res['cost']}');
}
