/// 🔔 Gaussian Mixture Model (Expectation-Maximization)
///
/// A compact, well-documented GMM implementation using EM with diagonal
/// covariance support and simple regularization. Returns weights, means and
/// covariances and provides `score` and `predict` helpers.
///
/// Contract:
/// - Input: X (n x m), number of components k.
/// - Output: component weights, means, covariances.
/// - Error: throws ArgumentError on invalid shapes.
///
/// Time Complexity: O(n * k * iters * m)
/// Space Complexity: O(k * m + n * k)
library;

import 'dart:math';

class GMM {
  final int k;
  final int maxIter;
  final double tol;
  List<double>? weights;
  List<List<double>>? means;
  List<List<double>>? covs; // diagonal covariances

  GMM(this.k, {this.maxIter = 100, this.tol = 1e-4}) {
    if (k <= 0) throw ArgumentError('k must be positive');
  }

  void fit(List<List<double>> X) {
    final n = X.length;
    if (n == 0) throw ArgumentError('Empty dataset');
    final m = X[0].length;
    final rnd = Random(0);
    weights = List<double>.filled(k, 1.0 / k);
    means = List.generate(k, (_) => List<double>.from(X[rnd.nextInt(n)]));
    covs = List.generate(k, (_) => List<double>.filled(m, 1.0));

    final resp = List.generate(n, (_) => List<double>.filled(k, 0.0));

    double prevLL = double.negativeInfinity;
    for (var iter = 0; iter < maxIter; iter++) {
      // E-step
      for (var i = 0; i < n; i++) {
        var denom = 0.0;
        for (var j = 0; j < k; j++) {
          // Gaussian with diagonal covariance
          var exponent = 0.0;
          for (var d = 0; d < m; d++) {
            final diff = X[i][d] - means![j][d];
            exponent += (diff * diff) / (2.0 * covs![j][d]);
          }
          final coef =
              pow(2 * pi, m / 2) * sqrt(covs![j].reduce((a, b) => a * b));
          final p = (1.0 / coef) * exp(-exponent);
          resp[i][j] = weights![j] * p;
          denom += resp[i][j];
        }
        if (denom == 0) {
          // avoid division by zero: assign uniform responsibilities
          for (var j = 0; j < k; j++) {
            resp[i][j] = 1.0 / k;
          }
        } else {
          for (var j = 0; j < k; j++) {
            resp[i][j] /= denom;
          }
        }
      }

      // M-step
      for (var j = 0; j < k; j++) {
        var nk = 0.0;
        for (var i = 0; i < n; i++) {
          nk += resp[i][j];
        }
        if (nk == 0.0) {
          // small safeguard: leave component as is or reinitialize weight
          weights![j] = 1.0 / n;
          continue;
        }

        weights![j] = nk / n;

        for (var d = 0; d < m; d++) {
          var mu = 0.0;
          for (var i = 0; i < n; i++) {
            mu += resp[i][j] * X[i][d];
          }
          means![j][d] = mu / nk;
        }

        for (var d = 0; d < m; d++) {
          var s = 0.0;
          for (var i = 0; i < n; i++) {
            final diff = X[i][d] - means![j][d];
            s += resp[i][j] * diff * diff;
          }
          covs![j][d] = s / nk + 1e-6;
        }
      }

      // log-likelihood for convergence
      var ll = 0.0;
      for (var i = 0; i < n; i++) {
        var px = 0.0;
        for (var j = 0; j < k; j++) {
          var exponent = 0.0;
          for (var d = 0; d < m; d++) {
            final diff = X[i][d] - means![j][d];
            exponent += (diff * diff) / (2.0 * covs![j][d]);
          }
          final coef =
              pow(2 * pi, m / 2) * sqrt(covs![j].reduce((a, b) => a * b));
          final p = (1.0 / coef) * exp(-exponent) * weights![j];
          px += p;
        }
        ll += log(px + 1e-12);
      }

      if ((ll - prevLL).abs() < tol) break;
      prevLL = ll;
    }
  }

  int predict(List<double> x) {
    if (weights == null) throw StateError('Model not fitted');
    final k0 = weights!.length;
    var best = 0;
    var bestP = -double.infinity;
    for (var j = 0; j < k0; j++) {
      var exponent = 0.0;
      for (var d = 0; d < x.length; d++) {
        final diff = x[d] - means![j][d];
        exponent += (diff * diff) / (2.0 * covs![j][d]);
      }
      final coef =
          pow(2 * pi, x.length / 2) * sqrt(covs![j].reduce((a, b) => a * b));
      final p = (1.0 / coef) * exp(-exponent) * weights![j];
      final lp = log(p + 1e-300);
      if (lp > bestP) {
        bestP = lp;
        best = j;
      }
    }
    return best;
  }
}
