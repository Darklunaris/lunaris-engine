import 'package:test/test.dart';
import 'package:lunaris_engine/MachineLearning/q_learning.dart';

void main() {
  group('QLearning', () {
    test('chooseAction and update behave', () {
      final q = QLearning(
        nStates: 3,
        nActions: 2,
        alpha: 1.0,
        gamma: 0.0,
        epsilon: 0.0,
        seed: 2,
      );
      // deterministic: zero epsilon, all zeros => choose index 0
      expect(q.chooseAction(0), equals(0));
      q.update(0, 1, 5.0, 0);
      expect(q.qTable[0][1], equals(5.0));
    });
  });
}
