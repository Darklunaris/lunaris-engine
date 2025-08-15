import 'dart:math';
import 'package:lunaris_engine/MachineLearning/simulated_annealing.dart';

// Example: minimize f(x) = (x-3)^2 over real numbers represented as double
void main() {
  final sa = SimulatedAnnealing<double>(
    initial: 0.0,
    energy: (x) => (x - 3.0) * (x - 3.0),
    neighbor: (x, rnd) => x + (rnd.nextDouble() - 0.5) * 1.0,
    temperature: (t) => 1.0 / log(t + 1.0 + 1e-9),
    seed: 42,
  );

  final out = sa.optimize(iterations: 1000);
  print('best=${out['best']} energy=${out['energy']}');
}
