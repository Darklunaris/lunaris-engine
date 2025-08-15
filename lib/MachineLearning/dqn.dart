/// Deep Q-Network (DQN) - minimal numeric example
///
/// A compact DQN wrapper that uses the project's `ANN` MLP as a function
/// approximator. This implementation is intentionally small and educational —
/// it demonstrates replay memory, epsilon-greedy actions, and periodic updates
/// so it can be used in examples and unit tests without GPU dependencies.
///
/// Notes:
/// - States are represented as List<double> feature vectors
/// - Actions are integer indices
library;

import 'dart:convert';
import 'dart:math';
import 'package:lunaris_engine/MachineLearning/ann.dart';

/// DQN wrapper with optional target network and configurable replay buffer
///
/// Enhancements:
/// - optional target network with periodic hard updates
/// - configurable discount (gamma) and batch size
/// - simple (FIFO) replay buffer with capacity
/// - serialization to/from Map/JSON
class DQN {
  final int nActions;
  final ANN network;
  ANN? _targetNetwork; // optional target network
  final int memoryCapacity;
  final Random _rand;

  final List<List<double>> _states = [];
  final List<int> _actions = [];
  final List<double> _rewards = [];
  final List<List<double>> _nextStates = [];

  double epsilon;
  double gamma;
  final int targetUpdateSteps; // hard update frequency
  int _updates = 0;

  DQN({
    required this.nActions,
    required List<int> netLayers,
    this.memoryCapacity = 1000,
    this.epsilon = 0.1,
    this.gamma = 0.99,
    this.targetUpdateSteps = 100,
    bool useTarget = true,
    int? seed,
  }) : _rand = seed != null ? Random(seed) : Random(),
       network = ANN(layers: netLayers, seed: seed) {
    if (netLayers.isEmpty) throw ArgumentError('netLayers required');
    // Ensure the network parameters are initialized before serializing/cloning.
    // ANN initializes lazily on predict(), so force a lightweight predict.
    network.predict([List<double>.filled(network.layers[0], 0.0)]);
    if (useTarget) {
      _targetNetwork = ANN.fromMap(network.toMap(), seed: seed);
    }
  }

  int chooseAction(List<double> state) {
    if (_rand.nextDouble() < epsilon) return _rand.nextInt(nActions);
    final pred = network.predict([state]);
    final row = pred[0];
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

  void remember(
    List<double> state,
    int action,
    double reward,
    List<double> nextState,
  ) {
    if (_states.length >= memoryCapacity) {
      _states.removeAt(0);
      _actions.removeAt(0);
      _rewards.removeAt(0);
      _nextStates.removeAt(0);
    }
    _states.add(state);
    _actions.add(action);
    _rewards.add(reward);
    _nextStates.add(nextState);
  }

  void replay({int batchSize = 16}) {
    if (_states.isEmpty) return;
    final b = min(batchSize, _states.length);
    final idxs = List<int>.generate(_states.length, (i) => i);
    idxs.shuffle(_rand);
    final batchIdx = idxs.sublist(0, b);
    final xs = <List<double>>[];
    final ys = <List<double>>[];
    for (var i in batchIdx) {
      final s = _states[i];
      final a = _actions[i];
      final r = _rewards[i];
      final ns = _nextStates[i];
      final q = network.predict([s])[0];
      final qNext = (_targetNetwork ?? network).predict([ns])[0];
      final target = List<double>.from(q);
      final maxNext = qNext.reduce((x, y) => x > y ? x : y);
      target[a] = r + gamma * maxNext;
      xs.add(s);
      ys.add(target);
    }
    network.fit(xs, ys);
    _updates += 1;
    if (_targetNetwork != null && _updates % targetUpdateSteps == 0) {
      _targetNetwork!.applyParamsFrom(network);
    }
  }

  Map<String, dynamic> toMap() => {
    'nActions': nActions,
    'epsilon': epsilon,
    'gamma': gamma,
    'memoryCapacity': memoryCapacity,
    'network': network.toMap(),
    'targetNetwork': _targetNetwork?.toMap(),
  };

  static DQN fromMap(Map<String, dynamic> m, {int? seed}) {
    final net = ANN.fromMap(m['network'] as Map<String, dynamic>, seed: seed);
    final model = DQN(
      nActions: m['nActions'] as int,
      netLayers: net.layers,
      memoryCapacity: (m['memoryCapacity'] as num?)?.toInt() ?? 1000,
      epsilon: (m['epsilon'] as num?)?.toDouble() ?? 0.1,
      gamma: (m['gamma'] as num?)?.toDouble() ?? 0.99,
      seed: seed,
    );
    model.network.applyParamsFrom(net);
    if (m['targetNetwork'] != null) {
      final tnet = ANN.fromMap(
        m['targetNetwork'] as Map<String, dynamic>,
        seed: seed,
      );
      model._targetNetwork = ANN.fromMap(tnet.toMap(), seed: seed);
      model._targetNetwork!.applyParamsFrom(tnet);
    }
    return model;
  }

  String toJson() => jsonEncode(toMap());

  static DQN fromJson(String s, {int? seed}) =>
      fromMap(jsonDecode(s) as Map<String, dynamic>, seed: seed);
}
