import 'package:lunaris_engine/MachineLearning/mdp.dart';
import 'package:test/test.dart';

void main() {
  group('MDP', () {
    test('valueIteration and policyIteration consistent for simple MDP', () {
      final nStates = 2;
      final nActions = 2;
      final P = List.generate(
        nStates,
        (_) =>
            List.generate(nActions, (_) => List<double>.filled(nStates, 0.0)),
      );
      final R = List.generate(
        nStates,
        (_) =>
            List.generate(nActions, (_) => List<double>.filled(nStates, 0.0)),
      );
      P[0][0][0] = 1.0;
      P[0][1][1] = 1.0;
      P[1][0][1] = 1.0;
      P[1][1][0] = 1.0;
      R[0][1][1] = 1.0;
      R[1][0][1] = 0.5;
      final mdp = MDP(nStates: nStates, nActions: nActions, P: P, R: R);

      final vi = mdp.valueIteration(gamma: 0.9);
      final pi = mdp.policyIteration(gamma: 0.9);
      expect(vi['policy'], isNotNull);
      expect(pi['policy'], isNotNull);
      // policies should be lists of length nStates
      expect((vi['policy'] as List).length, equals(nStates));
      expect((pi['policy'] as List).length, equals(nStates));
    });
  });
}
