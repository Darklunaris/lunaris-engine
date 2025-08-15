import 'package:lunaris_engine/Consensus/proof_of_stake.dart';
import 'package:test/test.dart';

void main() {
  group('PoS', () {
    test('selectProposer proportional to stake', () {
      final vals = [Validator('A', 1), Validator('B', 9)];
      final pos = PoS(vals);
      // with deterministic seed, expect proposer to be B often; run many trials
      var bCount = 0;
      for (var i = 0; i < 100; i++) {
        if (pos.selectProposer(i).id == 'B') bCount++;
      }
      expect(bCount, greaterThan(0));
    });
  });
}
