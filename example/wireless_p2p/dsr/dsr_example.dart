import 'package:lunaris_engine/wireless_p2p/dsr.dart';

void main() {
  final a = DsrNode(1);
  final b = DsrNode(2);
  final c = DsrNode(3);
  a.addNeighbor(2);
  b.addNeighbor(1);
  b.addNeighbor(3);
  c.addNeighbor(2);
  final nodes = {1: a, 2: b, 3: c};
  for (var n in nodes.values) {
    n.sendHook = (from, to, msg) => nodes[to]?.receive(from, msg);
    n.onDeliver = (from, to, payload) => print('Node $to got: $payload');
  }
  a.send(3, 'payload');
  for (var i = 0; i < 6; i++) {
    for (var n in nodes.values) {
      n.tick();
    }
  }
}
