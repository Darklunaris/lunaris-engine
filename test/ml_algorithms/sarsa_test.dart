import 'package:test/test.dart';
import 'package:lunaris_engine/MachineLearning/sarsa.dart';

void main() {
  group('SARSA', () {
    test('update works', () {
      final s = SARSA(
        nStates: 2,
        nActions: 2,
        alpha: 1.0,
        gamma: 0.0,
        epsilon: 0.0,
        seed: 3,
      );
      s.update(0, 0, 2.0, 1, 1);
      expect(s.qTable[0][0], equals(2.0));
    });
  });
}
