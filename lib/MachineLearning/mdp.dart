/// Markov Decision Process (MDP) utilities - generic
///
/// A compact, engineering-oriented MDP helper that provides:
/// - generic value iteration and policy iteration solvers for discrete MDPs
/// - support for arbitrary state/action indexes with transition and reward
///   represented as dense arrays (List)
/// - convergence criteria and iteration limits
///
/// Contract:
/// - Input: number of states, number of actions, transition P[s][a][s'] (prob),
///   reward R[s][a][s'], discount gamma.
/// - Output: value function and greedy policy.
/// - Errors: throws ArgumentError on shape mismatches.
library;

class MDP {
  final int nStates;
  final int nActions;
  final List<List<List<double>>> P; // P[s][a][s']
  final List<List<List<double>>> R; // R[s][a][s']

  MDP({
    required this.nStates,
    required this.nActions,
    required this.P,
    required this.R,
  }) {
    if (P.length != nStates) throw ArgumentError('P shape mismatch');
    if (R.length != nStates) throw ArgumentError('R shape mismatch');
  }

  /// Value iteration: returns pair (values, policy)
  Map<String, dynamic> valueIteration({
    double gamma = 0.99,
    double tol = 1e-6,
    int maxIter = 10000,
  }) {
    final V = List<double>.filled(nStates, 0.0);
    for (var it = 0; it < maxIter; it++) {
      var delta = 0.0;
      for (var s = 0; s < nStates; s++) {
        double best = double.negativeInfinity;
        for (var a = 0; a < nActions; a++) {
          var q = 0.0;
          for (var sp = 0; sp < nStates; sp++) {
            q += P[s][a][sp] * (R[s][a][sp] + gamma * V[sp]);
          }
          if (q > best) best = q;
        }
        final diff = (best - V[s]).abs();
        if (diff > delta) delta = diff;
        V[s] = best;
      }
      if (delta < tol) break;
    }
    final policy = List<int>.filled(nStates, 0);
    for (var s = 0; s < nStates; s++) {
      var bestA = 0;
      var bestVal = double.negativeInfinity;
      for (var a = 0; a < nActions; a++) {
        var q = 0.0;
        for (var sp = 0; sp < nStates; sp++) {
          q += P[s][a][sp] * (R[s][a][sp] + gamma * V[sp]);
        }
        if (q > bestVal) {
          bestVal = q;
          bestA = a;
        }
      }
      policy[s] = bestA;
    }
    return {'values': V, 'policy': policy};
  }

  /// Policy iteration
  Map<String, dynamic> policyIteration({
    double gamma = 0.99,
    int maxIter = 1000,
  }) {
    var policy = List<int>.filled(nStates, 0);
    final V = List<double>.filled(nStates, 0.0);
    for (var it = 0; it < maxIter; it++) {
      // policy evaluation (solve linear system (I - gamma P_pi) V = r_pi)
      final A = List.generate(
        nStates,
        (_) => List<double>.filled(nStates, 0.0),
      );
      final b = List<double>.filled(nStates, 0.0);
      for (var s = 0; s < nStates; s++) {
        A[s][s] = 1.0;
        final a = policy[s];
        for (var sp = 0; sp < nStates; sp++) {
          A[s][sp] -= gamma * P[s][a][sp];
          b[s] += P[s][a][sp] * R[s][a][sp];
        }
      }
      final solved = _solveLinear(A, b);
      for (var i = 0; i < nStates; i++) {
        V[i] = solved[i];
      }

      // policy improvement
      var changed = false;
      for (var s = 0; s < nStates; s++) {
        var bestA = policy[s];
        var bestVal = double.negativeInfinity;
        for (var a = 0; a < nActions; a++) {
          var q = 0.0;
          for (var sp = 0; sp < nStates; sp++) {
            q += P[s][a][sp] * (R[s][a][sp] + gamma * V[sp]);
          }
          if (q > bestVal) {
            bestVal = q;
            bestA = a;
          }
        }
        if (bestA != policy[s]) {
          policy[s] = bestA;
          changed = true;
        }
      }
      if (!changed) break;
    }
    return {'values': V, 'policy': policy};
  }

  List<double> _solveLinear(List<List<double>> A, List<double> b) {
    // simple Gaussian elimination for small systems
    final n = A.length;
    final M = List.generate(n, (i) => List<double>.from(A[i]));
    final rhs = List<double>.from(b);
    for (var i = 0; i < n; i++) {
      // pivot
      var pivot = M[i][i];
      if (pivot.abs() < 1e-12) {
        for (var r = i + 1; r < n; r++) {
          if (M[r][i].abs() > 1e-12) {
            final tmp = M[i];
            M[i] = M[r];
            M[r] = tmp;
            final tmpb = rhs[i];
            rhs[i] = rhs[r];
            rhs[r] = tmpb;
            pivot = M[i][i];
            break;
          }
        }
      }
      if (pivot.abs() < 1e-12) throw StateError('Singular matrix');
      for (var j = i; j < n; j++) {
        M[i][j] /= pivot;
      }
      rhs[i] /= pivot;
      for (var r = i + 1; r < n; r++) {
        final factor = M[r][i];
        for (var c = i; c < n; c++) {
          M[r][c] -= factor * M[i][c];
        }
        rhs[r] -= factor * rhs[i];
      }
    }
    final x = List<double>.filled(n, 0.0);
    for (var i = n - 1; i >= 0; i--) {
      var s = rhs[i];
      for (var j = i + 1; j < n; j++) {
        s -= M[i][j] * x[j];
      }
      x[i] = s / M[i][i];
    }
    return x;
  }
}
