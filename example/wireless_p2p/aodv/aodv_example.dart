import 'package:lunaris_engine/wireless_p2p/aodv.dart';

void main() {
  final n1 = AodvNode(1);
  final n2 = AodvNode(2);
  final n3 = AodvNode(3);
  // simple line topology 1-2-3
  n1.addNeighbor(2);
  n2.addNeighbor(1);
  n2.addNeighbor(3);
  n3.addNeighbor(2);
  // wiring using simple in-memory sendHook
  final nodes = {1: n1, 2: n2, 3: n3};
  for (var node in nodes.values) {
    node.sendHook = (from, to, msg) {
      // deliver only to neighbor
      nodes[to]?.receive(from, msg);
    };
    node.onDeliver = (from, to, payload) {
      print('Node $to received payload from $from: $payload');
    };
  }
  n1.send(3, 'hello');
  // simulate ticks
  for (var i = 0; i < 5; i++) {
    for (var node in nodes.values) {
      node.tick();
    }
  }
}
