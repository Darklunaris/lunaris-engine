/// Proof of Burn (PoB) - burn-and-weight mechanics
///
/// A demonstration of proof-of-burn economics: users irrevocably 'burn'
/// coins to obtain long-term weight or staking power. This module provides
/// bookkeeping for burns, weight calculation, and simple reweighting rules.
/// It is intended for simulations, protocol experiments, and tests.
///
/// Contract:
/// - Input: burn events (account, amount, timestamp)
/// - Output: effective weights for accounts
/// - Errors: throws for invalid events
library;

import 'dart:math';

class BurnEvent {
  final String account;
  final double amount;
  final int timestamp;
  BurnEvent(this.account, this.amount, this.timestamp) {
    if (amount <= 0) throw ArgumentError('amount>0');
  }
}

/// Proof of Burn ledger with optional decay to model time-discounted burns.
class PoB {
  final Map<String, double> _burned = {};
  final double decayPerSecond;

  PoB({this.decayPerSecond = 0.0}) {
    if (decayPerSecond < 0) throw ArgumentError('decay must be >= 0');
  }

  void applyBurn(BurnEvent e) {
    _burned[e.account] = (_burned[e.account] ?? 0.0) + e.amount;
  }

  /// Effective weight optionally applying exponential decay based on elapsed seconds.
  double weight(String account, {int? nowTimestamp}) {
    var w = _burned[account] ?? 0.0;
    if (decayPerSecond > 0 && nowTimestamp != null) {
      // For simulation: approximate decayed weight over time.
      w = w * pow(effectiveDecay(nowTimestamp), 1);
    }
    return w;
  }

  double effectiveDecay(int nowTimestamp) =>
      exp(-decayPerSecond * nowTimestamp);
}
