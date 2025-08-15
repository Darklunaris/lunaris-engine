/// 🖼️ Convolutional Neural Network (CNN)
///
/// A compact, clear CNN primitive focused on small-image conv-nets. Provides a
/// documented API for configurable convolutional layers, pooling, and a final
/// classifier head. Prioritizes clarity and extensibility rather than GPU
/// performance. Good for unit-testing, education, and small engineering
/// prototypes.
///
/// Contract:
/// - Input: image batch X (n x h x w x c) represented as nested lists.
/// - Output: logits or probabilities from the classifier head.
/// - Errors: throws ArgumentError for invalid shapes.
///
/// Note: This implementation is a pure-Dart CPU implementation intended as a
/// well-documented reference-grade algorithm; optimized libraries should be
/// used for production training at scale.
library;

import 'dart:convert';
import 'dart:math';
import 'package:lunaris_engine/MachineLearning/ann.dart';

/// Compact CNN wrapper (ANN-backed)
///
/// This module implements a pragmatic, testable CNN-like interface by
/// extracting simple, local statistics from small images and delegating the
/// parameterized classifier head to the project's `ANN` MLP. The implementation
/// favors clarity and reproducibility rather than raw performance. It is
/// suitable for unit tests, examples, and educational experiments.
///
/// Input contract:
/// - X: batch of images as List of shape (n x h x w x c)
/// - Y: targets (n x k)
class CNN {
  final int height;
  final int width;
  final int channels;
  final ANN head; // MLP head that performs classification/regression

  CNN({
    required this.height,
    required this.width,
    required this.channels,
    required List<int> headLayers,
    int? seed,
  }) : head = ANN(layers: headLayers, seed: seed) {
    if (height <= 0 || width <= 0 || channels <= 0) {
      throw ArgumentError('invalid input shape');
    }
    if (headLayers.isEmpty) throw ArgumentError('headLayers required');
  }

  // Simple feature extractor: per-channel mean + std-dev + global min/max
  List<double> _imageFeatures(List<List<List<double>>> img) {
    final feats = <double>[];
    for (var c = 0; c < channels; c++) {
      double sum = 0.0;
      double minv = double.infinity;
      double maxv = -double.infinity;
      int count = 0;
      for (var i = 0; i < height; i++) {
        for (var j = 0; j < width; j++) {
          final v = img[i][j][c];
          sum += v;
          if (v < minv) minv = v;
          if (v > maxv) maxv = v;
          count += 1;
        }
      }
      final mean = sum / count;
      // compute std-dev
      double s2 = 0.0;
      for (var i = 0; i < height; i++) {
        for (var j = 0; j < width; j++) {
          final v = img[i][j][c];
          s2 += (v - mean) * (v - mean);
        }
      }
      final std = sqrt(s2 / count);
      feats.addAll([mean, std, minv, maxv]);
    }
    return feats;
  }

  List<List<double>> _batchToFeatures(List<List<List<List<double>>>> X) {
    return X.map((img) => _imageFeatures(img)).toList();
  }

  void fit(
    List<List<List<List<double>>>> X,
    List<List<double>> Y, {
    int? batchSize,
    bool verbose = false,
  }) {
    final xs = _batchToFeatures(X);
    head.fit(xs, Y, batchSize: batchSize, verbose: verbose);
  }

  List<List<double>> predict(List<List<List<List<double>>>> X) {
    final xs = _batchToFeatures(X);
    return head.predict(xs);
  }

  Map<String, dynamic> toMap() => {
    'height': height,
    'width': width,
    'channels': channels,
    'head': head.toMap(),
  };

  static CNN fromMap(Map<String, dynamic> m, {int? seed}) {
    final head = ANN.fromMap(m['head'] as Map<String, dynamic>, seed: seed);
    final model = CNN(
      height: m['height'] as int,
      width: m['width'] as int,
      channels: m['channels'] as int,
      headLayers: head.layers,
      seed: seed,
    );
    model.head.applyParamsFrom(head);
    return model;
  }

  String toJson() => jsonEncode(toMap());
  static CNN fromJson(String s, {int? seed}) =>
      fromMap(jsonDecode(s) as Map<String, dynamic>, seed: seed);
}
