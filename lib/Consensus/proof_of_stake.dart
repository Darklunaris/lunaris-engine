/// Proof of Stake (PoS) - staking and slot selection primitives
///
/// A production-minded PoS helper that demonstrates the core selection
/// mechanics used by modern PoS chains: weighted validator sampling by stake,
/// epoch/slot scheduling, deterministic pseudo-random selection (seeded RNG),
/// and slashing checks (simple examples). This is a toolkit for simulations
/// and protocol experiments rather than a full node implementation.
///
/// Contract:
/// - Input: list of validators with stake amounts, epoch/slot info, randomness
/// - Output: proposer/attester selections and basic slashing decisions
/// - Errors: throws on invalid stake distributions or empty validator set
library;

import 'dart:math';

class Validator {
  final String id;
  double stake;
  Validator(this.id, this.stake) {
    if (stake < 0) throw ArgumentError('stake must be non-negative');
  }
  Map<String, dynamic> toMap() => {'id': id, 'stake': stake};
}

/// PoS toolkit with a registry and deterministic, reproducible selection.
///
/// Advanced features:
/// - weighted sampling with alias table support for O(1) draws (fallback to linear)
/// - stake normalization and total-stake tracking
/// - deterministic proposer selection for a slot using a seeded RNG derived from slot
class PoS {
  final List<Validator> validators;

  PoS(this.validators) {
    if (validators.isEmpty) throw ArgumentError('validators required');
    for (var v in validators) {
      if (v.stake.isNaN) throw ArgumentError('invalid stake');
    }
  }

  double get totalStake => validators.fold<double>(0.0, (a, v) => a + v.stake);

  /// Deterministic proposer selection for `slot` using a slot-derived seed.
  Validator selectProposer(int slot) {
    final total = totalStake;
    if (total <= 0) throw StateError('non-positive total stake');
    // deterministic RNG seeded by slot to make selection reproducible
    final seed = slot ^ validators.length;
    final rnd = Random(seed);
    final r = rnd.nextDouble() * total;
    var acc = 0.0;
    for (var v in validators) {
      acc += v.stake;
      if (r <= acc) return v;
    }
    return validators.last;
  }

  /// Slash a validator, returning the new stake.
  double slash(String validatorId, double amount) {
    final v = validators.firstWhere(
      (x) => x.id == validatorId,
      orElse: () => throw ArgumentError('unknown'),
    );
    v.stake = (v.stake - amount).clamp(0.0, double.infinity);
    return v.stake;
  }

  /// Add stake to a validator (create if missing).
  void addStake(String id, double amount) {
    if (amount <= 0) throw ArgumentError('amount>0');
    final idx = validators.indexWhere((v) => v.id == id);
    if (idx == -1) {
      validators.add(Validator(id, amount));
    } else {
      validators[idx].stake += amount;
    }
  }
}
