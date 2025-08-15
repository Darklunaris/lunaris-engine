import 'package:lunaris_engine/Consensus/delegated_proof_of_stake.dart';
import 'package:test/test.dart';

void main() {
  group('DPoS', () {
    test('schedule cycles delegates', () {
      final delegates = [Delegate('p1', 10), Delegate('p2', 20)];
      final d = DPoS(delegates);
      final s = d.scheduleForSlots(3);
      expect(s.length, equals(3));
      expect(s[0], isNotNull);
    });
  });
}
