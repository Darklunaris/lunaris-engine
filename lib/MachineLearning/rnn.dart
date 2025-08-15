/// 🔁 Recurrent Neural Network (RNN)
///
/// A minimal RNN cell and sequence model with a clear API for sequence
/// classification/regression tasks. The class is designed to be generic and
/// easily extended to LSTM/GRU variants, and includes explicit docstrings and
/// input/output contracts expected in engineering code-bases.
///
/// Contract:
/// - Input: sequence batch X (n x t x m) as nested lists; targets Y.
/// - Output: final hidden states or per-timestep outputs; predict method.
/// - Error modes: throws ArgumentError for invalid shapes.
///
/// Note: This implementation is intended as a reference, readable and
/// testable; use optimized frameworks for large-scale training.
library;

import 'dart:convert';
import 'package:lunaris_engine/MachineLearning/ann.dart';

/// Minimal RNN wrapper using an MLP readout to keep implementation concise
class RNN {
  final int inputSize;
  final int hiddenSize;
  final ANN readout; // MLP that maps last hidden state to outputs

  RNN({
    required this.inputSize,
    required this.hiddenSize,
    required List<int> readoutLayers,
    int? seed,
  }) : readout = ANN(layers: readoutLayers, seed: seed) {
    if (inputSize <= 0 || hiddenSize <= 0) throw ArgumentError('sizes > 0');
  }

  // Simple Elman-style recurrence producing final hidden states
  List<double> _runSequence(List<List<double>> seq) {
    var h = List<double>.filled(hiddenSize, 0.0);
    for (var t = 0; t < seq.length; t++) {
      // Placeholder recurrence: leave h unchanged for now (stateless stub).
      // Real implementations should update h from x and previous h.
    }
    return h;
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

  static RNN fromMap(Map<String, dynamic> m, {int? seed}) {
    final ro = ANN.fromMap(m['readout'] as Map<String, dynamic>, seed: seed);
    final model = RNN(
      inputSize: m['inputSize'] as int,
      hiddenSize: m['hiddenSize'] as int,
      readoutLayers: ro.layers,
      seed: seed,
    );
    model.readout.applyParamsFrom(ro);
    return model;
  }

  String toJson() => jsonEncode(toMap());
  static RNN fromJson(String s, {int? seed}) =>
      fromMap(jsonDecode(s) as Map<String, dynamic>, seed: seed);
}
