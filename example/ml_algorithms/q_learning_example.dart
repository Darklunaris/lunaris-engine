import 'package:lunaris_engine/MachineLearning/q_learning.dart';

void main() {
  final q = QLearning(
    nStates: 5,
    nActions: 2,
    alpha: 0.5,
    gamma: 0.9,
    epsilon: 0.2,
    seed: 1,
  );
  // toy update
  q.update(0, 1, 1.0, 1);
  print('Q[0][1]=${q.qTable[0][1]}');
}
