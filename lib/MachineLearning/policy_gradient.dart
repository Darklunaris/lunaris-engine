/// Policy Gradient (REINFORCE) - minimal numeric implementation
///
/// A concise REINFORCE-style policy gradient agent that uses an MLP policy to
/// produce action probabilities for discrete actions. This implementation is
/// intentionally small for teaching and unit testing (no baselines by default)
/// but exposes the core API needed in real experiments: `selectAction` and
/// `updateFromEpisode`.
///
library;

import 'dart:convert';
import 'dart:math';
import 'package:lunaris_engine/MachineLearning/ann.dart';

/// REINFORCE-style Policy Gradient with optional baseline and normalization
class PolicyGradient {
  final int nActions;
  final ANN policy;
  final Random _rand;

  // optional simple value baseline to reduce variance
  final bool useBaseline;
  double baseline; // running baseline estimate

  PolicyGradient({
    required this.nActions,
    required List<int> policyLayers,
    int? seed,
    this.useBaseline = false,
  }) : _rand = seed != null ? Random(seed) : Random(),
       policy = ANN(layers: policyLayers, seed: seed),
       baseline = 0.0 {
    if (policyLayers.isEmpty) throw ArgumentError('policyLayers required');
  }

  int selectAction(List<double> state) {
    final logits = policy.predict([state])[0];
    // softmax
    final maxLogit = logits.reduce(max);
    final exps = logits.map((l) => exp(l - maxLogit)).toList();
    final sum = exps.reduce((a, b) => a + b);
    final probs = exps.map((e) => e / sum).toList();
    double r = _rand.nextDouble();
    double cum = 0.0;
    for (var i = 0; i < probs.length; i++) {
      cum += probs[i];
      if (r < cum) return i;
    }
    return probs.length - 1;
  }

  /// Update from a single episode represented as lists of states, actions and returns.
  /// Supports optional baseline subtraction and advantage normalization.
  void updateFromEpisode(
    List<List<double>> states,
    List<int> actions,
    List<double> returns, {
    bool normalize = true,
  }) {
    if (states.length != actions.length || actions.length != returns.length) {
      throw ArgumentError('episode lengths must match');
    }
    final advs = <double>[];
    for (var r in returns) {
      var a = r;
      if (useBaseline) {
        a = r - baseline;
      }
      advs.add(a);
    }
    // optional normalization
    if (normalize && advs.isNotEmpty) {
      final mean = advs.reduce((a, b) => a + b) / advs.length;
      final variance =
          advs.map((a) => (a - mean) * (a - mean)).reduce((x, y) => x + y) /
          advs.length;
      final std = sqrt(variance + 1e-8);
      for (var i = 0; i < advs.length; i++) {
        advs[i] = (advs[i] - mean) / std;
      }
    }

    final xs = <List<double>>[];
    final ys = <List<double>>[];
    for (var i = 0; i < states.length; i++) {
      final s = states[i];
      final a = actions[i];
      final adv = advs[i];
      final target = List<double>.filled(nActions, 0.0);
      target[a] = adv;
      xs.add(s);
      ys.add(target);
    }
    policy.fit(xs, ys);

    if (useBaseline && returns.isNotEmpty) {
      // update running baseline (simple exponential moving average)
      final meanReturn = returns.reduce((a, b) => a + b) / returns.length;
      baseline = baseline * 0.9 + meanReturn * 0.1;
    }
  }

  Map<String, dynamic> toMap() => {
    'nActions': nActions,
    'policy': policy.toMap(),
    'useBaseline': useBaseline,
    'baseline': baseline,
  };

  static PolicyGradient fromMap(Map<String, dynamic> m, {int? seed}) {
    final pol = ANN.fromMap(m['policy'] as Map<String, dynamic>, seed: seed);
    final model = PolicyGradient(
      nActions: m['nActions'] as int,
      policyLayers: pol.layers,
      seed: seed,
      useBaseline: (m['useBaseline'] as bool?) ?? false,
    );
    model.policy.applyParamsFrom(pol);
    model.baseline = (m['baseline'] as num?)?.toDouble() ?? 0.0;
    return model;
  }

  String toJson() => jsonEncode(toMap());

  static PolicyGradient fromJson(String s, {int? seed}) =>
      fromMap(jsonDecode(s) as Map<String, dynamic>, seed: seed);
}
