import 'package:lunaris_engine/MachineLearning/sarsa.dart';

void main() {
  final s = SARSA(
    nStates: 4,
    nActions: 2,
    alpha: 0.5,
    gamma: 0.9,
    epsilon: 0.1,
    seed: 1,
  );
  s.update(0, 1, 1.0, 1, 0);
  print('ok');
}
