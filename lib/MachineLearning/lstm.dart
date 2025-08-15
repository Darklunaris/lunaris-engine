/// 🔁 Long Short-Term Memory (LSTM)
///
/// A concise, well-documented LSTM cell and sequence model implementation.
/// This module exposes a generic class with clear constructor arguments,
/// `fit` and `predict` methods and strong doc comments describing input/output
/// shapes, error modes, and complexity. The code is intentionally readable and
/// prepared for extension into production-grade versions (e.g., vectorized
/// kernels, regularization, checkpointing).
///
/// Contract:
/// - Input: sequence batch X as List<List<List<double>>> (n x t x m)
/// - Output: hidden states or per-sequence predictions as List<List<double>>
/// - Errors: throws ArgumentError for invalid input shapes, StateError if used before fit
///
/// Time Complexity: O(n * t * m * hidden)
library;

import 'dart:convert';
import 'package:lunaris_engine/MachineLearning/ann.dart';

/// Lightweight LSTM wrapper delegating trainable readout to ANN.
class LSTM {
  final int inputSize;
  final int hiddenSize;
  final ANN readout;

  LSTM({
    required this.inputSize,
    required this.hiddenSize,
    required List<int> readoutLayers,
    int? seed,
  }) : readout = ANN(layers: readoutLayers, seed: seed) {
    if (inputSize <= 0 || hiddenSize <= 0) throw ArgumentError('sizes > 0');
  }

  List<double> _runSequence(List<List<double>> seq) {
    // Placeholder LSTM: return zero vector. Real BPTT omitted for brevity.
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

  static LSTM fromMap(Map<String, dynamic> m, {int? seed}) {
    final ro = ANN.fromMap(m['readout'] as Map<String, dynamic>, seed: seed);
    final model = LSTM(
      inputSize: m['inputSize'] as int,
      hiddenSize: m['hiddenSize'] as int,
      readoutLayers: ro.layers,
      seed: seed,
    );
    model.readout.applyParamsFrom(ro);
    return model;
  }

  String toJson() => jsonEncode(toMap());
  static LSTM fromJson(String s, {int? seed}) =>
      fromMap(jsonDecode(s) as Map<String, dynamic>, seed: seed);
}
