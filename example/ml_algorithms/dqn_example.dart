import 'package:lunaris_engine/MachineLearning/dqn.dart';

void main() {
  final d = DQN(
    nActions: 2,
    netLayers: [4, 8, 2],
    memoryCapacity: 10,
    epsilon: 0.1,
    seed: 1,
  );
  d.remember([0.0, 0.0, 0.0, 0.0], 0, 1.0, [0.0, 0.0, 0.0, 0.0]);
  d.replay();
  print('replay ok');
}
