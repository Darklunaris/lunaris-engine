/// Q-Learning (tabular)
///
/// A compact, well-documented tabular Q-Learning implementation suitable for
/// discrete state/action spaces. This class intentionally keeps the API simple
/// (states and actions are integers) so it can be composed into larger agents
/// or used in unit tests and examples.
///
/// Public contract:
/// - Inputs: state (int), action (int), reward (double), nextState (int)
/// - Storage: internal Q-table of shape (nStates x nActions)
/// - Outputs: Q-values, action selection via epsilon-greedy
library;

import 'dart:convert';
import 'dart:math';

/// Tabular Q-Learning (advanced)
///
/// This implementation keeps the simple, well-documented API from the
/// original version but adds commonly used features that make it practical
/// in experiments and tests:
/// - decaying epsilon (exploration) with configurable schedule
/// - optional decaying learning-rate (alpha) schedule
/// - safe helpers (bestAction, maxQ, reset, clone)
/// - serialization to/from Map/JSON
///
/// The class maintains backwards-compatible constructor arguments where
/// possible. States and actions are integers and the Q-table is a
/// List<List<double>> of shape (nStates x nActions).
class QLearning {
  final int nStates;
  final int nActions;
  double alpha; // learning rate (may be decayed)
  final double gamma; // discount factor
  double epsilon; // current epsilon

  // Optional schedule parameters
  final double? epsilonMin;
  final double? epsilonDecay; // multiplicative decay per step (e.g. 0.999)
  final double? alphaMin;
  final double? alphaDecay; // multiplicative decay per update

  final Random _rand;

  late List<List<double>> qTable;
  int _steps = 0; // number of updates taken

  QLearning({
    required this.nStates,
    required this.nActions,
    this.alpha = 0.1,
    this.gamma = 0.99,
    this.epsilon = 0.1,
    int? seed,
    this.epsilonMin,
    this.epsilonDecay,
    this.alphaMin,
    this.alphaDecay,
  }) : _rand = seed != null ? Random(seed) : Random() {
    if (nStates <= 0 || nActions <= 0) {
      throw ArgumentError('nStates and nActions must be > 0');
    }
    qTable = List.generate(nStates, (_) => List<double>.filled(nActions, 0.0));
  }

  /// Choose an action for `state` using epsilon-greedy.
  /// Ties are broken by first occurrence (stable determinism under a seed).
  int chooseAction(int state) {
    if (state < 0 || state >= nStates) {
      throw RangeError.index(state, List.filled(nStates, 0), 'state');
    }
    if (_rand.nextDouble() < epsilon) return _rand.nextInt(nActions);
    return bestAction(state);
  }

  /// Returns the greedy (best) action for a given state.
  int bestAction(int state) {
    final row = qTable[state];
    double best = row[0];
    int bestIdx = 0;
    for (var i = 1; i < row.length; i++) {
      if (row[i] > best) {
        best = row[i];
        bestIdx = i;
      }
    }
    return bestIdx;
  }

  /// Maximum Q-value for a given state.
  double maxQ(int state) => qTable[state].reduce((a, b) => a > b ? a : b);

  /// Perform one Q-Learning update and advance internal schedules.
  void update(int state, int action, double reward, int nextState) {
    final q = qTable[state][action];
    final maxNext = maxQ(nextState);
    qTable[state][action] = q + alpha * (reward + gamma * maxNext - q);
    _steps += 1;
    _applySchedules();
  }

  void _applySchedules() {
    if (epsilonDecay != null && epsilon > (epsilonMin ?? 0.0)) {
      epsilon = epsilon * (epsilonDecay ?? 1.0);
      if (epsilonMin != null && epsilon < epsilonMin!) epsilon = epsilonMin!;
    }
    if (alphaDecay != null && alpha > (alphaMin ?? 0.0)) {
      alpha = alpha * (alphaDecay ?? 1.0);
      if (alphaMin != null && alpha < alphaMin!) alpha = alphaMin!;
    }
  }

  /// Reset Q-table (keeps schedules and hyperparameters).
  void reset({double defaultValue = 0.0}) {
    qTable = List.generate(
      nStates,
      (_) => List<double>.filled(nActions, defaultValue),
    );
    _steps = 0;
  }

  /// Create a deep clone of this agent (useful for experiments).
  QLearning clone() {
    final m = toMap();
    return QLearning.fromMap(m);
  }

  Map<String, dynamic> toMap() => {
    'nStates': nStates,
    'nActions': nActions,
    'alpha': alpha,
    'gamma': gamma,
    'epsilon': epsilon,
    'epsilonMin': epsilonMin,
    'epsilonDecay': epsilonDecay,
    'alphaMin': alphaMin,
    'alphaDecay': alphaDecay,
    'qTable': qTable,
    'steps': _steps,
  };

  static QLearning fromMap(Map<String, dynamic> m, {int? seed}) {
    final model = QLearning(
      nStates: m['nStates'] as int,
      nActions: m['nActions'] as int,
      alpha: (m['alpha'] as num).toDouble(),
      gamma: (m['gamma'] as num).toDouble(),
      epsilon: (m['epsilon'] as num).toDouble(),
      seed: seed,
      epsilonMin:
          m['epsilonMin'] == null ? null : (m['epsilonMin'] as num).toDouble(),
      epsilonDecay:
          m['epsilonDecay'] == null
              ? null
              : (m['epsilonDecay'] as num).toDouble(),
      alphaMin:
          m['alphaMin'] == null ? null : (m['alphaMin'] as num).toDouble(),
      alphaDecay:
          m['alphaDecay'] == null ? null : (m['alphaDecay'] as num).toDouble(),
    );
    final raw = m['qTable'] as List;
    model.qTable = raw.map((r) => List<double>.from(r as List)).toList();
    model._steps = (m['steps'] as num?)?.toInt() ?? 0;
    return model;
  }

  String toJson() => jsonEncode(toMap());

  static QLearning fromJson(String s, {int? seed}) =>
      fromMap(jsonDecode(s) as Map<String, dynamic>, seed: seed);
}
