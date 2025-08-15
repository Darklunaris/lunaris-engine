import 'dart:math';
import 'package:lunaris_engine/MachineLearning/genetic_algorithm.dart';
import 'package:test/test.dart';

void main() {
  group('GeneticAlgorithm', () {
    test('optimizes simple parabola', () {
      final rnd = Random(123);
      final ga = GeneticAlgorithm<double>(
        initPopulation: () => List.generate(20, (_) => rnd.nextDouble() * 10),
        fitness: (x) => -(x - 5.0) * (x - 5.0),
        crossover: (a, b, rnd) => (a + b) / 2.0,
        mutate: (a, rnd) => a + (rnd.nextDouble() - 0.5) * 0.2,
        populationSize: 20,
        mutationRate: 0.2,
        elitism: 1,
        seed: 42,
      );
      final res = ga.run(generations: 100);
      final best = res['best'] as double;
      expect((best - 5.0).abs(), lessThan(0.5));
    });
  });
}
