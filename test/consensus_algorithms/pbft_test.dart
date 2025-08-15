import 'package:lunaris_engine/Consensus/pbft.dart';
import 'package:test/test.dart';

void main() {
  group('PBFT', () {
    test('commit thresholds', () {
      final pbft = PBFT(4, 1);
      expect(pbft.canCommit(2, 3), isTrue);
    });
  });
}
