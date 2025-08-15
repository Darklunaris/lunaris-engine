import 'package:lunaris_engine/MachineLearning/simulated_annealing.dart';
import 'package:test/test.dart';

void main() {
  group('SimulatedAnnealing', () {
    test('finds minimum of quadratic', () {
      final sa = SimulatedAnnealing<double>(
        initial: 0.0,
        energy: (x) => (x - 3.0) * (x - 3.0),
        neighbor: (x, rnd) => x + (rnd.nextDouble() - 0.5) * 0.5,
        temperature: (t) => 1.0 / (t + 1.0),
        seed: 42,
      );
      final out = sa.optimize(iterations: 1000);
      final best = out['best'] as double;
      expect((best - 3.0).abs(), lessThan(0.5));
    });
  });
}
