import 'package:lunaris_engine/Consensus/bft.dart';
import 'package:test/test.dart';

void main() {
  group('BFT', () {
    test('commit quorum rules', () {
      final bft = BFT(4, 1);
      expect(bft.commit({0: true, 1: true, 2: false, 3: true}), isTrue);
    });
  });
}
