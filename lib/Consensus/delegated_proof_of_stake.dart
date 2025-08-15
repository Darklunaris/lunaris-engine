/// Delegated Proof of Stake (DPoS) - delegate scheduling
///
/// A DPoS helper modeling the core ideas: token holders delegate stake to
/// block producers, a voting/rotation schedule among delegates, deterministic
/// tie-breaking, and simple vote weight updates. This is a simulation toolkit
/// intended for protocol research and unit testing.
///
/// Contract:
/// - Input: delegates and delegations mapping, epoch/slot parameters
/// - Output: ordered schedule of producers for slots
/// - Errors: throws on empty delegates or invalid delegation weights
library;

import 'dart:math';

class Delegate {
  final String id;
  double weight;
  Delegate(this.id, this.weight) {
    if (weight.isNaN || weight < 0) throw ArgumentError('invalid weight');
  }
  Map<String, dynamic> toMap() => {'id': id, 'weight': weight};
}

/// Delegated Proof of Stake (DPoS) - delegate scheduling
///
/// Features:
/// - delegation registry mapping delegator->delegate->amount
/// - aggregated effective weight per delegate
/// - deterministic slot schedule derived from slot seed and weights
class DPoS {
  final List<Delegate> delegates;
  final Map<String, Map<String, double>> delegations = {};

  DPoS(this.delegates) {
    if (delegates.isEmpty) throw ArgumentError('delegates required');
  }

  /// Register a delegation: delegator delegates amount to delegateId.
  void delegate(String delegator, String delegateId, double amount) {
    if (amount <= 0) throw ArgumentError('amount>0');
    delegations.putIfAbsent(delegator, () => {})[delegateId] =
        (delegations[delegator]![delegateId] ?? 0) + amount;
  }

  /// Aggregate effective weights for delegates from the delegation registry.
  Map<String, double> aggregatedWeights() {
    final map = <String, double>{};
    for (var d in delegates) {
      map[d.id] = d.weight;
    }
    for (var delegator in delegations.keys) {
      final m = delegations[delegator]!;
      for (var e in m.entries) {
        map[e.key] = (map[e.key] ?? 0) + e.value;
      }
    }
    return map;
  }

  /// Deterministic schedule for `slots` using a slot-derived seed. Picks delegates
  /// proportionally to their aggregated effective weights.
  List<String> scheduleForSlots(int slots) {
    final agg = aggregatedWeights();
    final total = agg.values.fold(0.0, (a, b) => a + b);
    if (total <= 0) throw StateError('non-positive total weight');
    final res = <String>[];
    for (var s = 0; s < slots; s++) {
      final rnd = Random(s ^ delegates.length);
      final r = rnd.nextDouble() * total;
      double acc = 0.0;
      for (var e in agg.entries) {
        acc += e.value;
        if (r <= acc) {
          res.add(e.key);
          break;
        }
      }
    }
    return res;
  }
}
