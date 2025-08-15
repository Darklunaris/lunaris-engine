import 'package:lunaris_engine/MachineLearning/bayesian_optimization.dart';
import 'package:test/test.dart';

void main() {
  group('BayesianOptimization', () {
    test('picks best from initial data when evaluate missing', () {
      final initialX = [
        [0.0],
        [3.0],
        [10.0],
      ];
      final initialY = [
        -(0.0 - 3.0) * (0.0 - 3.0),
        -(3.0 - 3.0) * (3.0 - 3.0),
        -(10.0 - 3.0) * (10.0 - 3.0),
      ];
      final bo = BayesianOptimization(
        initialX: initialX,
        initialY: initialY,
        lower: [0.0],
        upper: [10.0],
        seed: 42,
      );
      final out = bo.optimize(budget: 0);
      expect(out['bestY'], equals(initialY[1]));
    });
  });
}
