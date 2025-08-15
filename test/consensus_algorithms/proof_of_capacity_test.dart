import 'package:lunaris_engine/Consensus/proof_of_capacity.dart';
import 'package:test/test.dart';

void main() {
  group('PoC', () {
    test('bestResponder returns owner string', () {
      final plots = [Plot('a', 1, 1), Plot('b', 2, 2)];
      final poc = ProofOfCapacity(plots);
      final r = poc.bestResponder(123);
      expect(r, anyOf('a', 'b'));
    });
  });
}
