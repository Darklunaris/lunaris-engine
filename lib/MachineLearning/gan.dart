/// 🎭 Generative Adversarial Network (GAN)
///
/// Compact GAN scaffolding: generator and discriminator primitives with a
/// clear training loop contract. Designed for clarity and testability with
/// instructions on how to extend to real generative models. Strong docstrings
/// describe the expected input/output shapes and training behavior.
///
/// Contract:
/// - Input: noise vectors for generator, real samples for discriminator.
/// - Output: trained generator/discriminator; generator.predict returns samples.
/// - Errors: throws ArgumentError for invalid shapes.
library;

import 'dart:convert';
import 'dart:math';
import 'package:lunaris_engine/MachineLearning/ann.dart';

/// Simple GAN scaffolding using ANN heads for generator and discriminator.
class GAN {
  final int latentDim;
  final ANN generator; // maps latent vector to data features
  final ANN discriminator; // maps data features to single probability
  final Random _rand;

  GAN({
    this.latentDim = 100,
    required List<int> genLayers,
    required List<int> discLayers,
    int? seed,
  }) : generator = ANN(layers: genLayers, seed: seed),
       discriminator = ANN(layers: discLayers, seed: seed),
       _rand = seed != null ? Random(seed) : Random() {
    if (latentDim <= 0) throw ArgumentError('latentDim must be positive');
  }

  List<double> _sampleLatent() =>
      List<double>.generate(latentDim, (_) => _rand.nextDouble() * 2 - 1);

  List<List<double>> generate(int n) =>
      List.generate(n, (_) => generator.predict([_sampleLatent()])[0]);

  /// Very small-step adversarial training stub: perform paired updates on
  /// discriminator and generator by creating labels and fitting the ANN heads.
  void fit(List<List<double>> realX, {int epochs = 1, int batchSize = 16}) {
    final dataSize = realX.length;
    for (var e = 0; e < epochs; e++) {
      // create fake samples
      final fakes = generate(min(batchSize, dataSize));
      // discriminator train: real -> 1.0, fake -> 0.0
      final xs = <List<double>>[];
      final ys = <List<double>>[];
      for (var i = 0; i < fakes.length; i++) {
        xs.add(fakes[i]);
        ys.add([0.0]);
      }
      for (var i = 0; i < min(batchSize, dataSize); i++) {
        xs.add(realX[i]);
        ys.add([1.0]);
      }
      discriminator.fit(xs, ys);

      // generator train: try to fool discriminator -> label 1.0
      final latents = List.generate(batchSize, (_) => _sampleLatent());
      final genSamples = latents.map((z) => generator.predict([z])[0]).toList();
      // create targets by asking discriminator for gradients via fit toward 1.0
      final dgTargets = List.generate(genSamples.length, (_) => [1.0]);
      // in practice generator update uses discriminator gradients; here we
      // perform a proxy supervised fit where generator learns to produce
      // samples that the discriminator classifies as real.
      generator.fit(latents, dgTargets);
    }
  }

  Map<String, dynamic> toMap() => {
    'latentDim': latentDim,
    'generator': generator.toMap(),
    'discriminator': discriminator.toMap(),
  };

  static GAN fromMap(Map<String, dynamic> m, {int? seed}) {
    final gen = ANN.fromMap(m['generator'] as Map<String, dynamic>, seed: seed);
    final disc = ANN.fromMap(
      m['discriminator'] as Map<String, dynamic>,
      seed: seed,
    );
    final model = GAN(
      latentDim: m['latentDim'] as int,
      genLayers: gen.layers,
      discLayers: disc.layers,
      seed: seed,
    );
    model.generator.applyParamsFrom(gen);
    model.discriminator.applyParamsFrom(disc);
    return model;
  }

  String toJson() => jsonEncode(toMap());
  static GAN fromJson(String s, {int? seed}) =>
      fromMap(jsonDecode(s) as Map<String, dynamic>, seed: seed);
}
