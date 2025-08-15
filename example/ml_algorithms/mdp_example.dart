import 'package:lunaris_engine/MachineLearning/mdp.dart';

void main() {
  // Simple 2-state MDP with 2 actions
  final nStates = 2;
  final nActions = 2;
  // P[s][a][s']
  final P = List.generate(
    nStates,
    (_) => List.generate(nActions, (_) => List<double>.filled(nStates, 0.0)),
  );
  final R = List.generate(
    nStates,
    (_) => List.generate(nActions, (_) => List<double>.filled(nStates, 0.0)),
  );
  // action 0: stay with reward 0, action 1: move to state1 with reward 1
  P[0][0][0] = 1.0;
  P[0][1][1] = 1.0;
  P[1][0][1] = 1.0;
  P[1][1][0] = 1.0;
  R[0][1][1] = 1.0;
  R[1][0][1] = 0.5;

  final mdp = MDP(nStates: nStates, nActions: nActions, P: P, R: R);
  final vi = mdp.valueIteration(gamma: 0.9);
  print('values=${vi['values']} policy=${vi['policy']}');
}
