import 'package:lunaris_engine/wireless_p2p/kademlia.dart';

void main() {
  final a = KademliaNode(1);
  a.storeValue(55, 'value55');
  print('findValue 55 on a -> ${a.findValue(55)}');
  // ensure b and c are used for bucket touches
  a.touch(Contact(42, 'endpoint-b'));
  a.touch(Contact(100, 'endpoint-c'));
  // touch contacts
  a.touch(Contact(42, null));
  a.touch(Contact(100, null));
  final closest = a.findClosest(60, 2);
  print('closest to 60: ${closest.map((c) => c.id).toList()}');
}
