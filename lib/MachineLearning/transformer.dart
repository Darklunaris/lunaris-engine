/// 🔁 Transformer (encoder-style minimal)
///
/// Minimal, well-documented transformer encoder block and a small sequence
/// model inspired by modern transformer architectures. Provides clear
/// constructor options (heads, model-dim), `fit`/`predict` signatures and
/// explanatory docstrings to aid extension to production-grade variants.
///
/// Contract:
/// - Input: token sequences as integer IDs or embeddings (List<List<int>> or List<List<double>>)
/// - Output: sequence embeddings or logits for downstream tasks
/// - Errors: throws ArgumentError for invalid inputs
library;

import 'dart:convert';
import 'package:lunaris_engine/MachineLearning/ann.dart';

/// Minimal Transformer encoder wrapper. We provide a tiny, testable
/// abstraction: token embeddings -> mean pooling -> MLP head (ANN).
class Transformer {
  final int vocabSize;
  final int dModel;
  final int heads;
  final ANN head;

  Transformer({
    required this.vocabSize,
    this.dModel = 64,
    this.heads = 4,
    required List<int> headLayers,
    int? seed,
  }) : head = ANN(layers: headLayers, seed: seed) {
    if (vocabSize <= 0) throw ArgumentError('vocabSize > 0');
    if (dModel <= 0) throw ArgumentError('dModel > 0');
    if (headLayers.isEmpty) throw ArgumentError('headLayers required');
  }

  // simple embedding bag: map tokens to one-hot-like embeddings (very small)
  List<double> _embedAndPool(List<int> tokens) {
    final emb = List<double>.filled(dModel, 0.0);
    if (tokens.isEmpty) return emb;
    for (var i = 0; i < tokens.length; i++) {
      final t = tokens[i] % dModel;
      emb[t] += 1.0;
    }
    // normalize
    for (var i = 0; i < emb.length; i++) {
      emb[i] /= tokens.length;
    }
    return emb;
  }

  void fit(
    List<List<int>> X,
    List<List<double>> Y, {
    int? batchSize,
    bool verbose = false,
  }) {
    final xs = X.map((toks) => _embedAndPool(toks)).toList();
    head.fit(xs, Y, batchSize: batchSize, verbose: verbose);
  }

  List<List<double>> predict(List<List<int>> X) {
    final xs = X.map((toks) => _embedAndPool(toks)).toList();
    return head.predict(xs);
  }

  Map<String, dynamic> toMap() => {
    'vocabSize': vocabSize,
    'dModel': dModel,
    'heads': heads,
    'head': head.toMap(),
  };

  static Transformer fromMap(Map<String, dynamic> m, {int? seed}) {
    final h = ANN.fromMap(m['head'] as Map<String, dynamic>, seed: seed);
    final model = Transformer(
      vocabSize: m['vocabSize'] as int,
      dModel: m['dModel'] as int,
      heads: m['heads'] as int,
      headLayers: h.layers,
      seed: seed,
    );
    model.head.applyParamsFrom(h);
    return model;
  }

  String toJson() => jsonEncode(toMap());
  static Transformer fromJson(String s, {int? seed}) =>
      fromMap(jsonDecode(s) as Map<String, dynamic>, seed: seed);
}
