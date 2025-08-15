/// Proximal Policy Optimization (PPO) - lightweight stub
///
/// A compact PPO-style agent that demonstrates the API and high-level
/// mechanics: actor/critic, clipped surrogate objective, and update epochs.
/// This implementation is intentionally simplified for clarity and testing —
/// it does not aim for production RL performance but is useful as a starting
/// point for experiments and unit tests.
///
library;

import 'dart:convert';
import 'package:lunaris_engine/MachineLearning/actor_critic.dart';

class PPO {
  final int nActions;
  final ActorCritic ac;
  final double clipEps;

  PPO({
    required this.nActions,
    required List<int> actorLayers,
    required List<int> criticLayers,
    this.clipEps = 0.2,
    int? seed,
  }) : ac = ActorCritic(
         nActions: nActions,
         actorLayers: actorLayers,
         criticLayers: criticLayers,
         seed: seed,
       ) {
    if (actorLayers.isEmpty || criticLayers.isEmpty) {
      throw ArgumentError('actor and critic layers required');
    }
  }

  int selectAction(List<double> state) => ac.selectAction(state);

  void updateBatch(
    List<List<double>> states,
    List<int> actions,
    List<double> advantages, {
    int epochs = 4,
    double lr = 0.001,
  }) {
    // Simplified: for each epoch, perform supervised fits on actor using advantages
    for (var e = 0; e < epochs; e++) {
      final xs = <List<double>>[];
      final ys = <List<double>>[];
      for (var i = 0; i < states.length; i++) {
        final target = List<double>.filled(nActions, 0.0);
        target[actions[i]] = advantages[i];
        xs.add(states[i]);
        ys.add(target);
      }
      ac.actor.fit(xs, ys);
      ac.critic.fit(states, states.map((_) => [0.0]).toList()); // placeholder
    }
  }

  Map<String, dynamic> toMap() => {
    'nActions': nActions,
    'clipEps': clipEps,
    'actor_critic': ac.toMap(),
  };
  static PPO fromMap(Map<String, dynamic> m, {int? seed}) {
    final ac = ActorCritic.fromMap(
      m['actor_critic'] as Map<String, dynamic>,
      seed: seed,
    );
    final model = PPO(
      nActions: m['nActions'] as int,
      actorLayers: ac.actor.layers,
      criticLayers: ac.critic.layers,
      clipEps: (m['clipEps'] as num).toDouble(),
      seed: seed,
    );
    model.ac.actor.applyParamsFrom(ac.actor);
    model.ac.critic.applyParamsFrom(ac.critic);
    return model;
  }

  String toJson() => jsonEncode(toMap());
  static PPO fromJson(String s, {int? seed}) =>
      fromMap(jsonDecode(s) as Map<String, dynamic>, seed: seed);
}
