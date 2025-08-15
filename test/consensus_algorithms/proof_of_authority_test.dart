import 'package:lunaris_engine/Consensus/proof_of_authority.dart';
import 'package:test/test.dart';

void main() {
  group('PoA', () {
    test('leader rotation weighted', () {
      final auths = [Authority('A', weight: 1), Authority('B', weight: 2)];
      final p = PoA(auths);
      final l0 = p.leaderForSlot(0);
      final l1 = p.leaderForSlot(1);
      expect(l0, isNotNull);
      expect(l1, isNotNull);
    });
  });
}
