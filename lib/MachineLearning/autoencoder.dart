/// 🧠 Autoencoder (simple dense feed-forward encoder/decoder)
///
/// A small, configurable autoencoder using fully-connected layers and mean
/// squared error reconstruction loss. Designed to be explicit and easy to
/// understand with clear docs for engineering adaptation.
///
/// Contract:
/// - Input: X (n x m), hidden dimension `h`.
/// - Output: encoded representations and reconstruction function.
/// - Error: throws for invalid dimensions.
///
/// Time Complexity: O(n * m * h * iters)
/// Space Complexity: O(m * h)
library;

import 'dart:math';

List<List<double>> _matMul(List<List<double>> A, List<List<double>> B) {
  final r = A.length, c = B[0].length, k = A[0].length;
  final out = List.generate(r, (_) => List<double>.filled(c, 0.0));
  for (var i = 0; i < r; i++) {
    for (var j = 0; j < c; j++) {
      for (var t = 0; t < k; t++) {
        out[i][j] += A[i][t] * B[t][j];
      }
    }
  }
  return out;
}

class Autoencoder {
  final int hidden;
  final int epochs;
  final double lr;
  List<List<double>>? w1, w2;
  List<double>? b1, b2;

  Autoencoder(this.hidden, {this.epochs = 100, this.lr = 0.01}) {
    if (hidden <= 0) throw ArgumentError('hidden must be positive');
  }

  void fit(List<List<double>> X) {
    final n = X.length;
    if (n == 0) throw ArgumentError('Empty dataset');
    final m = X[0].length;
    final rnd = Random(0);

    w1 = List.generate(
      m,
      (_) => List.generate(hidden, (_) => rnd.nextDouble() * 0.01),
    );
    w2 = List.generate(
      hidden,
      (_) => List.generate(m, (_) => rnd.nextDouble() * 0.01),
    );
    b1 = List<double>.filled(hidden, 0.0);
    b2 = List<double>.filled(m, 0.0);

    for (var epoch = 0; epoch < epochs; epoch++) {
      // Forward pass
      final Z = _matMul(X, w1!);
      for (var i = 0; i < Z.length; i++) {
        for (var j = 0; j < Z[0].length; j++) {
          Z[i][j] += b1![j];
        }
      }
      // ReLU
      for (var i = 0; i < Z.length; i++) {
        for (var j = 0; j < Z[0].length; j++) {
          Z[i][j] = max(0.0, Z[i][j]);
        }
      }
      var recon = _matMul(Z, w2!);
      for (var i = 0; i < recon.length; i++) {
        for (var j = 0; j < recon[0].length; j++) {
          recon[i][j] += b2![j];
        }
      }
      // compute simple gradients (MSE) and update (very small step implementation)
      final gradOut = List.generate(n, (_) => List<double>.filled(m, 0.0));
      for (var i = 0; i < n; i++) {
        for (var j = 0; j < m; j++) {
          gradOut[i][j] = recon[i][j] - X[i][j];
        }
      }
      final dW2 = List.generate(hidden, (_) => List<double>.filled(m, 0.0));
      for (var i = 0; i < hidden; i++) {
        for (var j = 0; j < m; j++) {
          for (var t = 0; t < n; t++) {
            dW2[i][j] += Z[t][i] * gradOut[t][j];
          }
        }
      }
      final dW1 = List.generate(m, (_) => List<double>.filled(hidden, 0.0));
      for (var i = 0; i < m; i++) {
        for (var j = 0; j < hidden; j++) {
          for (var t = 0; t < n; t++) {
            dW1[i][j] += X[t][i] * gradOut[t][j] * (Z[t][j] > 0 ? 1.0 : 0.0);
          }
        }
      }
      // updates
      for (var i = 0; i < m; i++) {
        for (var j = 0; j < hidden; j++) {
          w1![i][j] -= lr * dW1[i][j];
        }
      }
      for (var i = 0; i < hidden; i++) {
        for (var j = 0; j < m; j++) {
          w2![i][j] -= lr * dW2[i][j];
        }
      }
      for (var j = 0; j < hidden; j++) {
        for (var i = 0; i < n; i++) {
          b1![j] -= lr * gradOut[i][j];
        }
      }
      for (var j = 0; j < m; j++) {
        for (var i = 0; i < n; i++) {
          b2![j] -= lr * gradOut[i][j];
        }
      }
    }
  }

  List<List<double>> encode(List<List<double>> X) {
    if (w1 == null) throw StateError('Model not fitted');
    final Z = _matMul(X, w1!);
    for (var i = 0; i < Z.length; i++) {
      for (var j = 0; j < Z[0].length; j++) {
        Z[i][j] += b1![j];
      }
    }
    for (var i = 0; i < Z.length; i++) {
      for (var j = 0; j < Z[0].length; j++) {
        Z[i][j] = max(0.0, Z[i][j]);
      }
    }
    return Z;
  }
}
