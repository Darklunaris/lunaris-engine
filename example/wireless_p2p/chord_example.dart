import 'package:lunaris_engine/wireless_p2p/chord.dart';

void main() {
  final a = ChordNode(1, m: 5);
  final b = ChordNode(10, m: 5);
  final c = ChordNode(20, m: 5);
  // join ring
  b.join(a);
  c.join(a);
  a.join(a);
  a.stabilize();
  b.stabilize();
  c.stabilize();
  a.fixFingers();
  b.fixFingers();
  c.fixFingers();
  a.put(3, 'hello');
  print('lookup 3 -> ${b.get(3)}');
}
