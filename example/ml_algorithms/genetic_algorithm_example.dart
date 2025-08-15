import 'dart:math';
import 'package:lunaris_engine/MachineLearning/genetic_algorithm.dart';

// Example: maximize fitness = - (x-5)^2 with individuals encoded as double
void main() {
  final ga = GeneticAlgorithm<double>(
    initPopulation:
        () => List.generate(50, (_) => Random().nextDouble() * 10.0),
    fitness: (x) => -(x - 5.0) * (x - 5.0),
    crossover: (a, b, rnd) => (a + b) / 2.0,
    mutate: (a, rnd) => a + (rnd.nextDouble() - 0.5) * 0.5,
    populationSize: 50,
    mutationRate: 0.1,
    elitism: 2,
    seed: 123,
  );
  final res = ga.run(generations: 100);
  print('best=${res['best']} fitness=${res['fitness']}');
}
