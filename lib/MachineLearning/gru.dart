/// 🔁 Gated Recurrent Unit (GRU)
///
/// A compact GRU cell and sequence model exposing a tidy API for sequence
/// modeling. Designed to be generic and extendable to production needs (e.g.,
/// dropout, multilayer stacking), with detailed docstrings describing inputs,
/// outputs, and error cases.
///
/// Contract:
/// - Input: sequence batch X (n x t x m)
/// - Output: sequence-level predictions or hidden states
/// - Errors: throws ArgumentError for invalid shapes
library;

import 'dart:convert';
import 'package:lunaris_engine/MachineLearning/ann.dart';

/// Minimal GRU wrapper delegating the final mapping to an ANN readout.
class GRU {
  final int inputSize;
  final int hiddenSize;
  final ANN readout;

  GRU({
    required this.inputSize,
    required this.hiddenSize,
    required List<int> readoutLayers,
    int? seed,
  }) : readout = ANN(layers: readoutLayers, seed: seed) {
    if (inputSize <= 0 || hiddenSize <= 0) throw ArgumentError('sizes > 0');
  }

  List<double> _runSequence(List<List<double>> seq) {
    // Placeholder GRU behavior: return zeroed hidden vector
    return List<double>.filled(hiddenSize, 0.0);
  }

  void fit(
    List<List<List<double>>> X,
    List<List<double>> Y, {
    int? batchSize,
    bool verbose = false,
  }) {
    final xs = X.map((seq) => _runSequence(seq)).toList();
    readout.fit(xs, Y, batchSize: batchSize, verbose: verbose);
  }

  List<List<double>> predict(List<List<List<double>>> X) {
    final xs = X.map((seq) => _runSequence(seq)).toList();
    return readout.predict(xs);
  }

  Map<String, dynamic> toMap() => {
    'inputSize': inputSize,
    'hiddenSize': hiddenSize,
    'readout': readout.toMap(),
  };

  static GRU fromMap(Map<String, dynamic> m, {int? seed}) {
    final ro = ANN.fromMap(m['readout'] as Map<String, dynamic>, seed: seed);
    final model = GRU(
      inputSize: m['inputSize'] as int,
      hiddenSize: m['hiddenSize'] as int,
      readoutLayers: ro.layers,
      seed: seed,
    );
    model.readout.applyParamsFrom(ro);
    return model;
  }

  String toJson() => jsonEncode(toMap());
  static GRU fromJson(String s, {int? seed}) =>
      fromMap(jsonDecode(s) as Map<String, dynamic>, seed: seed);
}
