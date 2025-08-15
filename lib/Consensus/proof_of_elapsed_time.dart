/// Proof of Elapsed Time (PoET) - trusted wait simulation
///
/// PoET relies on trusted execution to enforce randomized waiting periods.
/// This compact simulation offers a deterministic 'wait lottery' that models
/// selection by elapsed time without dependencies on TEEs. It is useful for
/// protocol-level testing and simulation where a full TEE-backed stack is not
/// available.
///
/// Contract:
/// - Input: node ids and an RNG seed to produce wait times
/// - Output: the node with the smallest elapsed wait (winner)
/// - Errors: throws on empty node list
library;

import 'dart:math';

class PoET {
  final int? seed;
  PoET({this.seed});

  /// Run a deterministic selection using optional seed. Returns the winning node
  /// and a map of node->wait ms for diagnostics.
  MapEntry<String, double> winnerWithStats(List<String> nodes, {int? runSeed}) {
    if (nodes.isEmpty) throw ArgumentError('nodes required');
    final s = runSeed ?? seed ?? nodes.length;
    final rnd = Random(s);
    String bestNode = nodes.first;
    double best = double.infinity;
    for (var n in nodes) {
      final wait = rnd.nextDouble() * 1000.0; // synthetic ms
      if (wait < best || (wait == best && n.compareTo(bestNode) < 0)) {
        best = wait;
        bestNode = n;
      }
    }
    return MapEntry(bestNode, best);
  }

  String winner(List<String> nodes, {int? runSeed}) =>
      winnerWithStats(nodes, runSeed: runSeed).key;
}
