import 'dart:math';
import 'package:lunaris_engine/MachineLearning/particle_swarm.dart';
import 'package:test/test.dart';

void main() {
  group('ParticleSwarm', () {
    test('finds approximate maximum', () {
      final pso = ParticleSwarm(
        initParticles:
            () => List.generate(
              10,
              (_) => [Random().nextDouble() * 10, Random().nextDouble() * 10],
            ),
        fitness: (pos) {
          final x = pos[0];
          final y = pos[1];
          return -((x - 3) * (x - 3) + (y - 3) * (y - 3));
        },
        dim: 2,
        swarmSize: 10,
        toVector: (p) => p,
        fromVector: (v) => List<double>.from(v),
        seed: 1,
      );

      final out = pso.optimize(iterations: 200);
      final best =
          out['best']
              as List<double>; // Fixed: use 'best' instead of 'bestPosition'
      expect((best[0] - 3.0).abs() + (best[1] - 3.0).abs(), lessThan(2.0));
    });
  });
}
