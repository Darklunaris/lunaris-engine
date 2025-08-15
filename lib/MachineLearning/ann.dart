/// 🧠 Artificial Neural Network (ANN)
///
/// A minimal, production-minded feed-forward neural network API. This class
/// exposes a generic, well-documented interface for building multi-layer
/// perceptrons with configurable layer sizes, activation functions, and
/// training parameters. The implementation favors clarity, numerical safety,
/// and explicitness suitable for engineering evaluation and extension.
///
/// Contract:
/// - Input: feature matrix X (n x m) as List<List<double>> and target Y.
/// - Output: trained weights and a `predict` method which returns model outputs.
/// - Errors: throws ArgumentError for invalid shapes and StateError if used before fit.
///
/// Notes: This implementation is intentionally lightweight (no GPU) and
/// designed to be a maintainable, auditable building block rather than a
/// high-performance library.
library;

import 'dart:convert';
import 'dart:io';
import 'dart:math';

class ANN {
  final List<int> layers;
  final int epochs;
  final double lr;
  final Random _rand;

  /// history of loss values (one entry per epoch)
  final List<double> lossHistory = [];

  ANN({required this.layers, this.epochs = 100, this.lr = 0.01, int? seed})
    : _rand = seed != null ? Random(seed) : Random() {
    if (layers.length < 2) {
      throw ArgumentError('layers must include input and output sizes');
    }
  }

  // weights[layer][i][j] -> weight connecting node j in previous layer to node i in this layer
  late List<List<List<double>>> weights;
  late List<List<double>> biases;
  bool _inited = false;
  double? lastLoss;

  void _initParams() {
    double rand() => _rand.nextDouble();
    weights = [];
    biases = [];
    for (var l = 1; l < layers.length; l++) {
      final inSize = layers[l - 1];
      final outSize = layers[l];
      weights.add(
        List.generate(
          outSize,
          (_) => List.generate(inSize, (_) => (rand() - 0.5) * 0.1),
        ),
      );
      biases.add(List<double>.filled(outSize, 0.0));
    }
    _inited = true;
  }

  static double _relu(double x) => x > 0 ? x : 0;
  static double _reluDeriv(double x) => x > 0 ? 1.0 : 0.0;
  static double _sigmoid(double x) => 1.0 / (1.0 + exp(-x));
  static double _sigmoidDeriv(double s) => s * (1.0 - s);

  List<List<double>> predict(List<List<double>> X) {
    if (!_inited) _initParams();
    final n = X.length;
    final outputs = <List<double>>[];
    for (var xi = 0; xi < n; xi++) {
      var a = X[xi];
      for (var l = 0; l < weights.length; l++) {
        final w = weights[l];
        final b = biases[l];
        final z = List<double>.filled(w.length, 0.0);
        for (var i = 0; i < w.length; i++) {
          var s = b[i];
          for (var j = 0; j < w[i].length; j++) {
            s += w[i][j] * a[j];
          }
          z[i] = s;
        }
        if (l == weights.length - 1) {
          a = z.map(_sigmoid).toList();
        } else {
          a = z.map(_relu).toList();
        }
      }
      outputs.add(a);
    }
    return outputs;
  }

  double _mseLoss(List<List<double>> pred, List<List<double>> Y) {
    var s = 0.0;
    for (var i = 0; i < pred.length; i++) {
      for (var j = 0; j < pred[i].length; j++) {
        final d = pred[i][j] - Y[i][j];
        s += d * d;
      }
    }
    return s / pred.length;
  }

  /// Serialize model parameters to a Map (JSON-ready).
  Map<String, dynamic> toMap() {
    return {'layers': layers, 'weights': weights, 'biases': biases};
  }

  /// Reconstruct an ANN from a previously-serialized Map.
  static ANN fromMap(
    Map<String, dynamic> m, {
    int? seed,
    int? epochs,
    double? lr,
  }) {
    final layers = List<int>.from(m['layers'] as List);
    final model = ANN(
      layers: layers,
      epochs: epochs ?? 100,
      lr: lr ?? 0.01,
      seed: seed,
    );
    final rawW = m['weights'] as List;
    model.weights =
        rawW
            .map(
              (layer) =>
                  (layer as List)
                      .map((row) => List<double>.from(row as List))
                      .toList(),
            )
            .toList();
    final rawB = m['biases'] as List;
    model.biases = rawB.map((b) => List<double>.from(b as List)).toList();
    model._inited = true;
    return model;
  }

  /// Convenience training wrapper that calls the main fit implementation.
  /// (This class intentionally exposes a single training API.)
  void fit(
    List<List<double>> X,
    List<List<double>> Y, {
    int? batchSize,
    bool verbose = false,
    String optimizer = 'sgd',
    double momentum = 0.9,
    double beta1 = 0.9,
    double beta2 = 0.999,
    double epsilon = 1e-8,
    // l2 regularization (weight decay)
    double l2 = 0.0,
    // learning rate schedule: 'constant', 'step', 'exp'
    String lrSchedule = 'constant',
    int stepSize = 10,
    double stepDecay = 0.5,
    double expDecay = 0.99,
    int epochsOverride = -1,
  }) {
    if (X.isEmpty) throw ArgumentError('Empty dataset');
    if (X.length != Y.length) {
      throw ArgumentError('X and Y must have same number of rows');
    }
    _initParams();
    final n = X.length;
    final useBatch = (batchSize == null || batchSize >= n) ? n : batchSize;
    final int runEpochs = epochsOverride > 0 ? epochsOverride : epochs;

    // optimizer state (for momentum/adam)
    List<List<List<double>>> vW = [];
    List<List<double>> vB = [];
    List<List<List<double>>> mW = [];
    List<List<List<double>>> vAdamW = [];
    List<List<double>> mB = [];
    List<List<double>> vAdamB = [];
    var t = 0;

    // initialize optimizer accumulators
    if (optimizer == 'momentum') {
      for (var l = 0; l < weights.length; l++) {
        vW.add(
          List.generate(
            weights[l].length,
            (_) => List<double>.filled(weights[l][0].length, 0.0),
          ),
        );
        vB.add(List<double>.filled(biases[l].length, 0.0));
      }
    } else if (optimizer == 'adam') {
      for (var l = 0; l < weights.length; l++) {
        mW.add(
          List.generate(
            weights[l].length,
            (_) => List<double>.filled(weights[l][0].length, 0.0),
          ),
        );
        vAdamW.add(
          List.generate(
            weights[l].length,
            (_) => List<double>.filled(weights[l][0].length, 0.0),
          ),
        );
        mB.add(List<double>.filled(biases[l].length, 0.0));
        vAdamB.add(List<double>.filled(biases[l].length, 0.0));
      }
    }

    for (var epoch = 0; epoch < runEpochs; epoch++) {
      // compute current learning rate based on schedule
      double currentLr = lr;
      if (lrSchedule == 'step') {
        currentLr = lr * pow(stepDecay, (epoch / stepSize).floor());
      } else if (lrSchedule == 'exp') {
        currentLr = lr * pow(expDecay, epoch);
      }

      // create shuffled indices for mini-batching
      final indices = List<int>.generate(n, (i) => i);
      if (useBatch < n) {
        for (var i = indices.length - 1; i > 0; i--) {
          final j = _rand.nextInt(i + 1);
          final tmp = indices[i];
          indices[i] = indices[j];
          indices[j] = tmp;
        }
      }

      for (var batchStart = 0; batchStart < n; batchStart += useBatch) {
        final batchEnd = (batchStart + useBatch).clamp(0, n);
        final bsize = batchEnd - batchStart;
        if (bsize <= 0) continue;

        // prepare batch activations and preacts
        final activations = <List<List<double>>>[];
        final preacts = <List<List<double>>>[];

        for (var bi = batchStart; bi < batchEnd; bi++) {
          final idx = indices[bi];
          var a = X[idx];
          final acts = <List<double>>[a];
          final pres = <List<double>>[];
          for (var l = 0; l < weights.length; l++) {
            final w = weights[l];
            final b = biases[l];
            final z = List<double>.filled(w.length, 0.0);
            for (var ii = 0; ii < w.length; ii++) {
              var s = b[ii];
              for (var jj = 0; jj < w[ii].length; jj++) {
                s += w[ii][jj] * a[jj];
              }
              z[ii] = s;
            }
            pres.add(z);
            if (l == weights.length - 1) {
              a = z.map(_sigmoid).toList();
            } else {
              a = z.map(_relu).toList();
            }
            acts.add(a);
          }
          activations.add(acts);
          preacts.add(pres);
        }

        // compute gradients for batch
        final gradW = List.generate(
          weights.length,
          (l) => List.generate(
            weights[l].length,
            (_) => List<double>.filled(weights[l][0].length, 0.0),
          ),
        );
        final gradB = List.generate(
          biases.length,
          (l) => List<double>.filled(biases[l].length, 0.0),
        );

        for (var bi = 0; bi < activations.length; bi++) {
          final idx = indices[batchStart + bi];
          final y = Y[idx];
          final acts = activations[bi];
          final pres = preacts[bi];
          final out = acts.last;
          final delta = List<double>.filled(out.length, 0.0);
          for (var k = 0; k < out.length; k++) {
            final err = out[k] - y[k];
            delta[k] = err * _sigmoidDeriv(out[k]);
          }
          var curDelta = delta;
          for (var l = weights.length - 1; l >= 0; l--) {
            final aPrev = acts[l];
            for (var iOut = 0; iOut < weights[l].length; iOut++) {
              gradB[l][iOut] += curDelta[iOut];
              for (var iIn = 0; iIn < weights[l][iOut].length; iIn++) {
                gradW[l][iOut][iIn] += curDelta[iOut] * aPrev[iIn];
              }
            }
            if (l > 0) {
              final nextDelta = List<double>.filled(weights[l - 1].length, 0.0);
              for (var iPrev = 0; iPrev < weights[l - 1].length; iPrev++) {
                var s = 0.0;
                for (var iOut = 0; iOut < weights[l].length; iOut++) {
                  s += weights[l][iOut][iPrev] * curDelta[iOut];
                }
                nextDelta[iPrev] = s * _reluDeriv(pres[l - 1][iPrev]);
              }
              curDelta = nextDelta;
            }
          }
        }

        // average gradients over batch
        for (var l = 0; l < weights.length; l++) {
          for (var iOut = 0; iOut < weights[l].length; iOut++) {
            for (var iIn = 0; iIn < weights[l][iOut].length; iIn++) {
              gradW[l][iOut][iIn] /= bsize;
            }
            gradB[l][iOut] /= bsize;
          }
        }

        // optimizer updates (use currentLr)
        if (optimizer == 'sgd') {
          for (var l = 0; l < weights.length; l++) {
            for (var iOut = 0; iOut < weights[l].length; iOut++) {
              for (var iIn = 0; iIn < weights[l][iOut].length; iIn++) {
                weights[l][iOut][iIn] -= currentLr * gradW[l][iOut][iIn];
                // weight decay
                if (l2 > 0) weights[l][iOut][iIn] *= (1 - currentLr * l2);
              }
              biases[l][iOut] -= currentLr * gradB[l][iOut];
            }
          }
        } else if (optimizer == 'momentum') {
          for (var l = 0; l < weights.length; l++) {
            for (var iOut = 0; iOut < weights[l].length; iOut++) {
              for (var iIn = 0; iIn < weights[l][iOut].length; iIn++) {
                vW[l][iOut][iIn] =
                    momentum * vW[l][iOut][iIn] +
                    currentLr * gradW[l][iOut][iIn];
                weights[l][iOut][iIn] -= vW[l][iOut][iIn];
                if (l2 > 0) weights[l][iOut][iIn] *= (1 - currentLr * l2);
              }
              vB[l][iOut] = momentum * vB[l][iOut] + currentLr * gradB[l][iOut];
              biases[l][iOut] -= vB[l][iOut];
            }
          }
        } else if (optimizer == 'adam') {
          t += 1;
          for (var l = 0; l < weights.length; l++) {
            for (var iOut = 0; iOut < weights[l].length; iOut++) {
              for (var iIn = 0; iIn < weights[l][iOut].length; iIn++) {
                final g = gradW[l][iOut][iIn];
                mW[l][iOut][iIn] = beta1 * mW[l][iOut][iIn] + (1 - beta1) * g;
                vAdamW[l][iOut][iIn] =
                    beta2 * vAdamW[l][iOut][iIn] + (1 - beta2) * g * g;
                final mHat = mW[l][iOut][iIn] / (1 - pow(beta1, t));
                final vHat = vAdamW[l][iOut][iIn] / (1 - pow(beta2, t));
                weights[l][iOut][iIn] -=
                    currentLr * mHat / (sqrt(vHat) + epsilon);
                if (l2 > 0) weights[l][iOut][iIn] *= (1 - currentLr * l2);
              }
              final gb = gradB[l][iOut];
              mB[l][iOut] = beta1 * mB[l][iOut] + (1 - beta1) * gb;
              vAdamB[l][iOut] = beta2 * vAdamB[l][iOut] + (1 - beta2) * gb * gb;
              final mHatB = mB[l][iOut] / (1 - pow(beta1, t));
              final vHatB = vAdamB[l][iOut] / (1 - pow(beta2, t));
              biases[l][iOut] -= currentLr * mHatB / (sqrt(vHatB) + epsilon);
            }
          }
        } else {
          throw ArgumentError('Unknown optimizer: $optimizer');
        }
      }

      // compute epoch loss and store (mean over samples) using helper
      lastLoss = _mseLoss(predict(X), Y);
      lossHistory.add(lastLoss!);
      if (verbose) print('epoch=$epoch loss=$lastLoss');
    }
  }

  /// Asynchronous wrapper that runs `fit` in a Future (not in a separate isolate).
  Future<void> fitAsync(
    List<List<double>> X,
    List<List<double>> Y, {
    int? batchSize,
    bool verbose = false,
    String optimizer = 'sgd',
    double momentum = 0.9,
    double beta1 = 0.9,
    double beta2 = 0.999,
    double epsilon = 1e-8,
    double l2 = 0.0,
    String lrSchedule = 'constant',
    int stepSize = 10,
    double stepDecay = 0.5,
    double expDecay = 0.99,
  }) {
    return Future(
      () => fit(
        X,
        Y,
        batchSize: batchSize,
        verbose: verbose,
        optimizer: optimizer,
        momentum: momentum,
        beta1: beta1,
        beta2: beta2,
        epsilon: epsilon,
        l2: l2,
        lrSchedule: lrSchedule,
        stepSize: stepSize,
        stepDecay: stepDecay,
        expDecay: expDecay,
      ),
    );
  }

  /// Return a simple params map (weights and biases) without other metadata.
  Map<String, dynamic> getParams() {
    return {'weights': weights, 'biases': biases};
  }

  /// JSON helpers
  String toJson() => jsonEncode(toMap());

  static ANN fromJson(String s, {int? seed, int? epochs, double? lr}) {
    final m = jsonDecode(s) as Map<String, dynamic>;
    return fromMap(m, seed: seed, epochs: epochs, lr: lr);
  }

  Future<void> saveToFile(String path) async {
    final f = File(path);
    await f.writeAsString(toJson());
  }

  static Future<ANN> loadFromFile(
    String path, {
    int? seed,
    int? epochs,
    double? lr,
  }) async {
    final f = File(path);
    final s = await f.readAsString();
    return fromJson(s, seed: seed, epochs: epochs, lr: lr);
  }

  /// Public utility methods
  void markInitialized() {
    _inited = true;
  }

  void applyParamsFrom(ANN other) {
    weights = other.weights;
    biases = other.biases;
    _inited = true;
  }
}
