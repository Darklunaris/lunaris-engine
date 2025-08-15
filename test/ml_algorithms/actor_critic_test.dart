import 'package:test/test.dart';
import 'package:lunaris_engine/MachineLearning/actor_critic.dart';

void main() {
  group('ActorCritic', () {
    test('selectAction in range', () {
      final ac = ActorCritic(
        nActions: 3,
        actorLayers: [3, 8, 3],
        criticLayers: [3, 8, 1],
        seed: 3,
      );
      final a = ac.selectAction([0.0, 0.0, 0.0]);
      expect(a, inInclusiveRange(0, 2));
    });
  });
}
