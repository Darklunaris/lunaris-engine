/// SARSA (on-policy TD control)
///
/// Simple SARSA implementation for discrete state and action spaces. This
/// algorithm follows the on-policy update rule and exposes an epsilon-greedy
/// action selection. The API mirrors the tabular Q-Learning class so users can
/// swap algorithms easily in examples and tests.
///
/// Contract:
/// - states/actions: integers
/// - update(state, action, reward, nextState, nextAction)
library;

import 'dart:convert';
import 'dart:math';

/// SARSA (on-policy TD control) with optional schedules and helpers
///
/// Enhancements over the minimal SARSA:
/// - decaying epsilon and alpha schedules
/// - optional eligibility traces (lambda) for SARSA(lambda)
/// - helpers: bestAction, maxQ, reset, clone
/// - serialization to/from Map/JSON
class SARSA {
  final int nStates;
  final int nActions;
  double alpha;
  final double gamma;
  double epsilon;

  // Optional schedules
  final double? epsilonMin;
  final double? epsilonDecay;
  final double? alphaMin;
  final double? alphaDecay;

  // Eligibility traces parameter (optional); if null or 0, standard SARSA is used
  final double lambda;

  final Random _rand;

  late List<List<double>> qTable;
  List<List<double>>? _eTrace;
  int _steps = 0;

  SARSA({
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
    this.lambda = 0.0,
  }) : _rand = seed != null ? Random(seed) : Random() {
    if (nStates <= 0 || nActions <= 0) {
      throw ArgumentError('nStates and nActions must be > 0');
    }
    qTable = List.generate(nStates, (_) => List<double>.filled(nActions, 0.0));
    if (lambda > 0.0) {
      _eTrace = List.generate(
        nStates,
        (_) => List<double>.filled(nActions, 0.0),
      );
    }
  }

  int chooseAction(int state) {
    if (_rand.nextDouble() < epsilon) return _rand.nextInt(nActions);
    return bestAction(state);
  }

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

  double maxQ(int state) => qTable[state].reduce((a, b) => a > b ? a : b);

  void update(
    int state,
    int action,
    double reward,
    int nextState,
    int nextAction,
  ) {
    final q = qTable[state][action];
    final qNext = qTable[nextState][nextAction];
    final delta = reward + gamma * qNext - q;

    if (lambda > 0.0 && _eTrace != null) {
      // accumulation traces
      _eTrace![state][action] += 1.0;
      for (var s = 0; s < nStates; s++) {
        for (var a = 0; a < nActions; a++) {
          qTable[s][a] += alpha * delta * _eTrace![s][a];
          _eTrace![s][a] *= gamma * lambda;
        }
      }
    } else {
      qTable[state][action] = q + alpha * delta;
    }

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

  void reset({double defaultValue = 0.0}) {
    qTable = List.generate(
      nStates,
      (_) => List<double>.filled(nActions, defaultValue),
    );
    if (lambda > 0.0) {
      _eTrace = List.generate(
        nStates,
        (_) => List<double>.filled(nActions, 0.0),
      );
    }
    _steps = 0;
  }

  SARSA clone() {
    return SARSA.fromMap(toMap());
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
    'lambda': lambda,
    'qTable': qTable,
    'steps': _steps,
  };

  static SARSA fromMap(Map<String, dynamic> m, {int? seed}) {
    final model = SARSA(
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
      lambda: (m['lambda'] as num?)?.toDouble() ?? 0.0,
    );
    final raw = m['qTable'] as List;
    model.qTable = raw.map((r) => List<double>.from(r as List)).toList();
    model._steps = (m['steps'] as num?)?.toInt() ?? 0;
    return model;
  }

  String toJson() => jsonEncode(toMap());

  static SARSA fromJson(String s, {int? seed}) =>
      fromMap(jsonDecode(s) as Map<String, dynamic>, seed: seed);
}
