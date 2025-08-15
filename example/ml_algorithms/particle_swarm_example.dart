import 'dart:math';
import 'package:lunaris_engine/MachineLearning/particle_swarm.dart';

void main() {
  final pso = ParticleSwarm(
    initParticles:
        () => List.generate(
          30,
          (_) => [Random().nextDouble() * 10, Random().nextDouble() * 10],
        ),
    toVector: (p) => p,
    fromVector: (v) => v,
    fitness: (pos) {
      final x = pos[0];
      final y = pos[1];
      // simple multimodal objective with maximum near (3,3)
      return -((x - 3) * (x - 3) + (y - 3) * (y - 3));
    },
    dim: 2,
    swarmSize: 30,
    seed: 1,
  );

  final out = pso.optimize(iterations: 200);
  print(
    'bestPosition=${out['bestPosition']} bestFitness=${out['bestFitness']}',
  );
}
