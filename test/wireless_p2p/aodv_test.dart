import 'package:test/test.dart';
import 'package:lunaris_engine/wireless_p2p/aodv.dart';

void main() {
  test('AODV basic route discovery', () {
    final n1 = AodvNode(1);
    final n2 = AodvNode(2);
    final n3 = AodvNode(3);
    n1.addNeighbor(2);
    n2.addNeighbor(1);
    n2.addNeighbor(3);
    n3.addNeighbor(2);
    final nodes = {1: n1, 2: n2, 3: n3};
    for (var node in nodes.values) {
      node.sendHook = (from, to, msg) => nodes[to]?.receive(from, msg);
      node.onDeliver = (from, to, payload) {
        expect(payload, equals('hello'));
      };
    }
    n1.send(3, 'hello');
    for (var i = 0; i < 6; i++) {
      for (var node in nodes.values) {
        node.tick();
      }
    }
  });
}
