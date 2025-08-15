/// Particle Swarm Optimization (PSO) - generic
///
/// A compact, production-minded particle swarm optimizer that supports:
/// - generic particle position type represented as List<double> (vector)
/// - velocity-based updates, inertia, cognitive and social coefficients
/// - per-particle best and global best tracking, seeded RNG
///
/// Contract:
/// - Input: initial swarm positions generator, fitness(List<double>)->double
///   where higher is better, and hyperparameters.
/// - Output: `optimize` returns `bestPosition` and `bestFitness`.
/// - Errors: throws ArgumentError for invalid shapes.
/// Particle Swarm Optimization (PSO) - generic over particle type T
///
/// A production-minded particle swarm optimizer that is generic over the
/// particle representation `T`. The implementation internally operates on
/// numeric vectors, but the API accepts any `T` provided the caller supplies
/// mapping functions between `T` and `List<double>`.
///
/// Features:
/// - generic particle type `T` via `toVector` / `fromVector` converters
/// - inertia, cognitive and social coefficients with seeded RNG
/// - maintains per-particle best and global best
///
/// Contract:
/// - Input: `initParticles` -> List<T>, `toVector(T)->List<double>`,
///   `fromVector(List<double>)->T`, and `fitness(T)->double` (higher is better).
/// - Output: `optimize` returns a map with `best` (T) and `bestFitness`.
/// - Errors: throws ArgumentError for invalid shapes.
library;

import 'dart:math';

class ParticleSwarm<T> {
  final List<T> Function() initParticles;
  final List<double> Function(T) toVector;
  final T Function(List<double>) fromVector;
  final double Function(T) fitness; // higher is better
  final int swarmSize;
  final int dim;
  final double inertia;
  final double cognitive;
  final double social;
  final Random _rand;

  ParticleSwarm({
    required this.initParticles,
    required this.toVector,
    required this.fromVector,
    required this.fitness,
    required this.dim,
    this.swarmSize = 30,
    this.inertia = 0.7,
    this.cognitive = 1.4,
    this.social = 1.4,
    int? seed,
  }) : _rand = seed != null ? Random(seed) : Random() {
    if (dim <= 0) throw ArgumentError('dim > 0');
    if (swarmSize <= 0) throw ArgumentError('swarmSize > 0');
  }

  /// Run optimization and return best particle and fitness.
  Map<String, dynamic> optimize({int iterations = 200}) {
    var particles = initParticles();
    if (particles.isEmpty) throw ArgumentError('empty particle set');

    // convert particles to vector form
    var vectors = particles.map(toVector).toList();
    if (vectors.any((v) => v.length != dim)) {
      throw ArgumentError('vector dimension mismatch');
    }

    // initialize velocities
    final velocities = List.generate(
      swarmSize,
      (_) => List<double>.filled(dim, 0.0),
    );

    // ensure swarm size
    if (vectors.length != swarmSize) {
      final buf = <List<double>>[];
      while (buf.length < swarmSize) {
        buf.addAll(vectors);
      }
      vectors = buf.sublist(0, swarmSize);
    }

    final pBestVec = List.generate(
      swarmSize,
      (i) => List<double>.from(vectors[i]),
    );
    final pBestVal = List.generate(
      swarmSize,
      (i) => fitness(fromVector(vectors[i])),
    );

    var gBestVec = List<double>.from(pBestVec[0]);
    var gBestVal = pBestVal[0];
    for (var i = 1; i < swarmSize; i++) {
      if (pBestVal[i] > gBestVal) {
        gBestVal = pBestVal[i];
        gBestVec = List<double>.from(pBestVec[i]);
      }
    }

    for (var it = 0; it < iterations; it++) {
      for (var i = 0; i < swarmSize; i++) {
        final pos = vectors[i];
        final vel = velocities[i];
        for (var d = 0; d < dim; d++) {
          final r1 = _rand.nextDouble();
          final r2 = _rand.nextDouble();
          vel[d] =
              inertia * vel[d] +
              cognitive * r1 * (pBestVec[i][d] - pos[d]) +
              social * r2 * (gBestVec[d] - pos[d]);
          pos[d] = pos[d] + vel[d];
        }
        final val = fitness(fromVector(pos));
        if (val > pBestVal[i]) {
          pBestVal[i] = val;
          pBestVec[i] = List<double>.from(pos);
          if (val > gBestVal) {
            gBestVal = val;
            gBestVec = List<double>.from(pos);
          }
        }
      }
    }

    return {'best': fromVector(gBestVec), 'bestFitness': gBestVal};
  }
}
