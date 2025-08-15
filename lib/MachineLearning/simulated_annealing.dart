/// Simulated Annealing (generic)
///
/// A production-minded, generic simulated annealing optimizer.
/// The implementation is small, auditable and includes features expected
/// by engineering teams: generic candidate type `T`, pluggable energy and
/// neighbor functions, a temperature schedule and reproducible RNG.
///
/// Contract:
/// - Input: initial candidate `T`, `energy(T)->double` to minimize,
///   `neighbor(T, Random)->T` that proposes a local move, and `temperature(step)`.
/// - Output: `optimize` returns a map with `best` and `energy`.
/// - Errors: throws ArgumentError for invalid inputs.
library;

import 'dart:math';

class SimulatedAnnealing<T> {
  final T initial;
  final double Function(T) energy; // lower is better
  final T Function(T, Random) neighbor;
  final double Function(int) temperature; // must be >0 for steps
  final Random _rand;

  SimulatedAnnealing({
    required this.initial,
    required this.energy,
    required this.neighbor,
    required this.temperature,
    int? seed,
  }) : _rand = seed != null ? Random(seed) : Random() {
    if (temperature(0) <= 0) {
      throw ArgumentError('temperature must be positive for step=0');
    }
  }

  /// Run optimization for `iterations` steps. Returns a map with keys:
  /// - `best`: best candidate found
  /// - `energy`: energy of the best candidate
  Map<String, dynamic> optimize({int iterations = 1000}) {
    var current = initial;
    var currentE = energy(current);
    var best = current;
    var bestE = currentE;

    for (var t = 1; t <= iterations; t++) {
      final temp = temperature(t);
      if (temp <= 0) break;
      final cand = neighbor(current, _rand);
      final candE = energy(cand);
      final delta = candE - currentE;
      if (delta <= 0) {
        current = cand;
        currentE = candE;
      } else {
        final prob = exp(-delta / temp);
        if (_rand.nextDouble() < prob) {
          current = cand;
          currentE = candE;
        }
      }
      if (currentE < bestE) {
        best = current;
        bestE = currentE;
      }
    }

    return {'best': best, 'energy': bestE};
  }

  Map<String, dynamic> toMap() => {'initialEnergy': energy(initial)};
}
