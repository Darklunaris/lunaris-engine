import 'package:test/test.dart';
import 'package:lunaris_engine/MachineLearning/dqn.dart';

void main() {
  group('DQN', () {
    test('remember and replay', () {
      final d = DQN(
        nActions: 2,
        netLayers: [2, 4, 2],
        memoryCapacity: 10,
        epsilon: 0.0,
        seed: 5,
      );
      d.remember([0.0, 1.0], 1, 1.0, [0.0, 0.0]);
      d.replay(batchSize: 1);
      expect(() => d.replay(batchSize: 1), returnsNormally);
    });
  });
}
