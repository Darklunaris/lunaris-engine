import 'package:lunaris_engine/Consensus/proof_of_burn.dart';
import 'package:test/test.dart';

void main() {
  group('PoB', () {
    test('burn increases weight', () {
      final pob = PoB();
      pob.applyBurn(BurnEvent('alice', 100.0, 1));
      expect(pob.weight('alice'), equals(100.0));
    });
  });
}
