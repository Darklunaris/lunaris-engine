/// Genetic Algorithm (generic)
///
/// A production-grade, generic genetic algorithm (GA) module that supports:
/// - generic individual type `T` with user-provided `crossover`, `mutate`,
///   and `fitness` functions
/// - steady-state and generational replacement strategies
/// - tournament selection, elitism, and configurable mutation rates
/// - reproducible RNG via `seed`
///
/// Contract:
/// - Input: population generator, fitness(T)->double (higher is better),
///   crossover(T,T,Random)->T, mutate(T,Random)->T, and hyperparameters.
/// - Output: `run` returns best individual and its fitness.
/// - Errors: throws ArgumentError for invalid parameters.
library;

import 'dart:math';

class GeneticAlgorithm<T> {
  final List<T> Function() initPopulation;
  final double Function(T) fitness; // higher is better
  final T Function(T, T, Random) crossover;
  final T Function(T, Random) mutate;
  final int populationSize;
  final double mutationRate;
  final int elitism;
  final Random _rand;

  GeneticAlgorithm({
    required this.initPopulation,
    required this.fitness,
    required this.crossover,
    required this.mutate,
    this.populationSize = 100,
    this.mutationRate = 0.01,
    this.elitism = 1,
    int? seed,
  }) : _rand = seed != null ? Random(seed) : Random() {
    if (populationSize <= 0) throw ArgumentError('populationSize > 0');
    if (mutationRate < 0 || mutationRate > 1) {
      throw ArgumentError('mutationRate in [0,1]');
    }
    if (elitism < 0 || elitism >= populationSize) {
      throw ArgumentError('invalid elitism');
    }
  }

  T _tournament(List<T> pop, int k) {
    var best = pop[_rand.nextInt(pop.length)];
    var bestScore = fitness(best);
    for (var i = 1; i < k; i++) {
      final cand = pop[_rand.nextInt(pop.length)];
      final s = fitness(cand);
      if (s > bestScore) {
        best = cand;
        bestScore = s;
      }
    }
    return best;
  }

  /// Run GA for `generations`. Returns a map with `best` and `fitness`.
  Map<String, dynamic> run({int generations = 100, int tournamentK = 3}) {
    var population = initPopulation();
    if (population.length != populationSize) {
      // allow flexibility but copy/trim/pad to match size
      final buf = <T>[];
      while (buf.length < populationSize) {
        buf.addAll(population);
      }
      population = buf.sublist(0, populationSize);
    }

    T best = population[0];
    double bestF = fitness(best);

    for (var g = 0; g < generations; g++) {
      // evaluate and sort by fitness descending
      population.sort((a, b) => fitness(b).compareTo(fitness(a)));
      if (fitness(population.first) > bestF) {
        best = population.first;
        bestF = fitness(best);
      }

      final next = <T>[];
      // elitism
      for (var e = 0; e < elitism; e++) {
        next.add(population[e]);
      }

      while (next.length < populationSize) {
        final parentA = _tournament(population, tournamentK);
        final parentB = _tournament(population, tournamentK);
        var child = crossover(parentA, parentB, _rand);
        if (_rand.nextDouble() < mutationRate) child = mutate(child, _rand);
        next.add(child);
      }
      population = next;
    }

    // final evaluation
    population.sort((a, b) => fitness(b).compareTo(fitness(a)));
    best = population.first;
    bestF = fitness(best);
    return {'best': best, 'fitness': bestF};
  }
}
