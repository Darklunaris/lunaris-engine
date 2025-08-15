/// Monte Carlo Tree Search (MCTS) - minimal implementation
///
/// Small, well-documented MCTS implementation suitable for deterministic or
/// stochastic small games. The API expects the user to provide a light-weight
/// State interface via callbacks (isTerminal, expand, reward, actions, next).
/// This keeps the MCTS core generic and testable.
///
library;

import 'dart:math';

typedef IsTerminal<S> = bool Function(S state);
typedef Expand<S> = List<dynamic> Function(S state);
typedef NextState<S> = S Function(S state, dynamic action);
typedef Reward<S> = double Function(S state);

class MCTSNode<S> {
  final S state;
  MCTSNode? parent;
  final dynamic actionFromParent;
  final List<MCTSNode<S>> children = [];
  double value = 0.0;
  int visits = 0;

  MCTSNode(this.state, {this.parent, this.actionFromParent});
}

class MCTS<S> {
  final Random _rand;
  final IsTerminal<S> isTerminal;
  final Expand<S> expand;
  final NextState<S> nextState;
  final Reward<S> reward;

  MCTS({
    required this.isTerminal,
    required this.expand,
    required this.nextState,
    required this.reward,
    int? seed,
  }) : _rand = seed != null ? Random(seed) : Random();

  MCTSNode<S> _select(MCTSNode<S> node) {
    while (node.children.isNotEmpty) {
      node = node.children.reduce((a, b) {
        final ua =
            a.value / (a.visits + 1e-9) +
            sqrt(2 * log(node.visits + 1) / (a.visits + 1e-9));
        final ub =
            b.value / (b.visits + 1e-9) +
            sqrt(2 * log(node.visits + 1) / (b.visits + 1e-9));
        return ua > ub ? a : b;
      });
    }
    return node;
  }

  void _expand(MCTSNode<S> node) {
    final actions = expand(node.state);
    for (var a in actions) {
      final ns = nextState(node.state, a);
      node.children.add(MCTSNode<S>(ns, parent: node, actionFromParent: a));
    }
  }

  double _simulate(S state) {
    // random rollout until terminal or depth limit
    var cur = state;
    var depth = 0;
    while (!isTerminal(cur) && depth < 20) {
      final actions = expand(cur);
      if (actions.isEmpty) break;
      final a = actions[_rand.nextInt(actions.length)];
      cur = nextState(cur, a);
      depth++;
    }
    return reward(cur);
  }

  void _backup(MCTSNode<S> node, double value) {
    MCTSNode<S>? cur = node;
    while (cur != null) {
      cur.visits += 1;
      cur.value += value;
      cur = cur.parent as MCTSNode<S>?;
    }
  }

  dynamic search(S rootState, {int iterations = 100}) {
    final root = MCTSNode<S>(rootState);
    for (var i = 0; i < iterations; i++) {
      final leaf = _select(root);
      if (!isTerminal(leaf.state)) {
        _expand(leaf);
        if (leaf.children.isNotEmpty) {
          final child = leaf.children[_rand.nextInt(leaf.children.length)];
          final value = _simulate(child.state);
          _backup(child, value);
        } else {
          final value = _simulate(leaf.state);
          _backup(leaf, value);
        }
      } else {
        final value = reward(leaf.state);
        _backup(leaf, value);
      }
    }
    // return best action
    if (root.children.isEmpty) return null;
    root.children.sort((a, b) => b.visits.compareTo(a.visits));
    return root.children.first.actionFromParent;
  }
}
