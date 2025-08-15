import 'package:test/test.dart';
import 'package:lunaris_engine/wireless_p2p/kademlia.dart';

void main() {
  test('Kademlia basic store/find and buckets', () {
    final a = KademliaNode(1);
    final b = KademliaNode(42);
    a.storeValue(100, 'x');
    expect(a.findValue(100), equals('x'));
    a.touch(Contact(b.id, null));
    final closest = a.findClosest(50, 1);
    expect(closest.length, equals(1));
  });
}
