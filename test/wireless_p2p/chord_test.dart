import 'package:test/test.dart';
import 'package:lunaris_engine/wireless_p2p/chord.dart';

void main() {
  test('Chord put/get basic', () {
    final a = ChordNode(1, m: 5);
    final b = ChordNode(10, m: 5);
    final c = ChordNode(20, m: 5);
    b.join(a);
    c.join(a);
    a.join(a);
    a.stabilize();
    b.stabilize();
    c.stabilize();
    a.fixFingers();
    b.fixFingers();
    c.fixFingers();
    a.put(3, 'v3');
    expect(b.get(3), equals('v3'));
  });
}
