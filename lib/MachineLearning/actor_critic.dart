/// Actor-Critic (minimal)
///
/// A small Actor-Critic agent combining an actor network (policy) and a critic
/// network (value estimator). Both networks are simple MLPs from the project's
/// `ANN` module. The implementation focuses on API clarity so it can be used
/// in examples and tests without external dependencies.
///
library;

import 'dart:convert';
import 'dart:math';
import 'package:lunaris_engine/MachineLearning/ann.dart';

class ActorCritic {
  final int nActions;
  final ANN actor;
  final ANN critic;
  final Random _rand;

  ActorCritic({
    required this.nActions,
    required List<int> actorLayers,
    required List<int> criticLayers,
    int? seed,
  }) : _rand = seed != null ? Random(seed) : Random(),
       actor = ANN(layers: actorLayers, seed: seed),
       critic = ANN(layers: criticLayers, seed: seed) {
    if (actorLayers.isEmpty || criticLayers.isEmpty) {
      throw ArgumentError('actor and critic layers required');
    }
  }

  int selectAction(List<double> state) {
    final logits = actor.predict([state])[0];
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

  void update(
    List<double> state,
    int action,
    double reward,
    List<double> nextState, {
    double actorLr = 0.01,
    double criticLr = 0.01,
  }) {
    final v = critic.predict([state])[0][0];
    final vNext = critic.predict([nextState])[0][0];
    final td = reward + 0.99 * vNext - v;
    // critic target
    critic.fit(
      [state],
      [
        [v + td],
      ],
    );
    // actor target: increase logit for action proportionally to td
    final target = List<double>.filled(nActions, 0.0);
    target[action] = td;
    actor.fit([state], [target]);
  }

  Map<String, dynamic> toMap() => {
    'nActions': nActions,
    'actor': actor.toMap(),
    'critic': critic.toMap(),
  };
  static ActorCritic fromMap(Map<String, dynamic> m, {int? seed}) {
    final act = ANN.fromMap(m['actor'] as Map<String, dynamic>, seed: seed);
    final cri = ANN.fromMap(m['critic'] as Map<String, dynamic>, seed: seed);
    final model = ActorCritic(
      nActions: m['nActions'] as int,
      actorLayers: act.layers,
      criticLayers: cri.layers,
      seed: seed,
    );
    model.actor.applyParamsFrom(act);
    model.critic.applyParamsFrom(cri);
    return model;
  }

  String toJson() => jsonEncode(toMap());
  static ActorCritic fromJson(String s, {int? seed}) =>
      fromMap(jsonDecode(s) as Map<String, dynamic>, seed: seed);
}
